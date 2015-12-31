//
//  FunnyTimeDataBase.m
//  FunnyTime
//
//  Created by luxt on 15/9/21.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import "FunnyTimeDataBase.h"

#define kDataBaseName @"FunnyTimeDataBase.sqlite"
#define kDataBasePath [self sqlitePathsWithSqliteName:kDataBaseName]

#define kPictureCollectionListTableName @"PictureCollectionList"
#define kJokesCollectionListTableName @"JokesCollectionList"
#define kVoiceCollectionListTableName @"VoiceCollectionList"
#define kVideoCollectionListTableName @"VideoCollectionList"

static FunnyTimeDataBase *handle = nil;

@implementation FunnyTimeDataBase

+ (FunnyTimeDataBase *)shareFunnyTimeDataBase
{
    static dispatch_once_t OnceToken;
    dispatch_once(&OnceToken, ^{
        if (handle == nil) {
            handle = [[FunnyTimeDataBase alloc] init];
        }
    });
    return handle;
}

- (FMDatabase *)dataBase
{
    if (!_dataBase) {
        _dataBase = [FMDatabase databaseWithPath:kDataBasePath];
    }
    return _dataBase;
}

//指定数据库路径
- (NSString *)sqlitePathsWithSqliteName:(NSString *)sqliteName
{
    NSString *str = [NSSearchPathForDirectoriesInDomains(9, 1, 1) lastObject];
    NSString *path = [str stringByAppendingPathComponent:sqliteName];
    return path;
}

//打开数据库
- (void)openFunnyTimeDataBase
{
    self.dataBase = [FMDatabase databaseWithPath:kDataBasePath];
//    NSLog(@"数据库路径:%@",kDataBasePath);
}

//关闭数据库
-  (void)closeSqlite
{
    [self.dataBase close];
}

//根据表名判断表是否存在
- (BOOL)isExistCollectionTableWithTableName:(NSString *)tableName
{
    //数据库不存在,创建并打开
    if (!_dataBase) {
        [self openFunnyTimeDataBase];
    }
    
    FMResultSet *rs = [_dataBase executeQuery:@"select count(*) as 'count' from sqlite_master where type = 'table' and name = ?", tableName];
    
    while ([rs next]) {
        if ([rs intForColumn:@"count"]) {
            return YES;
        }else{
            return NO;
        }
    }
    
    return NO;
}

//判断表中是否有数据
- (BOOL)isContainDataInTable:(NSString *)tableName
{
    //数据库不存在,创建并打开
    if (!_dataBase) {
        [self openFunnyTimeDataBase];
    }
    
    if ([self.dataBase open]) {
        
        FMResultSet *rs = [self.dataBase executeQuery:[NSString stringWithFormat:@"select count(*) as 'count' from %@",tableName]];
        while ([rs next]) {
            
            if ([rs intForColumn:@"count"]) {
                return YES;
            }else{
                return NO;
            }
        }
        
    }
    
    return NO;
}


#pragma mark - 图片收藏表

//创建图片收藏表
- (void)createPictureCollectionTable
{
    //数据库不存在,创建并打开
    if (!_dataBase) {
        [self openFunnyTimeDataBase];
    }
    
    //打开数据库
    if ([self.dataBase open]) {
        
        if ([self isExistCollectionTableWithTableName:kPictureCollectionListTableName]) { //表已存在,直接返回
            return;
        }else{  //表不存在,建表

            BOOL isCreateTable = [self.dataBase executeUpdate:@"create table if not exists PictureCollectionList(timeStamp text, picURL text, picHeight text, picWidth text, timeString text, title text, picType text, collectionType text)"];
            
            if (isCreateTable) {
                NSLog(@"建表成功");
            }else{
                NSLog(@"建表失败");
            }
        }
        
        
    }
    
}


//判断图片是否存在 根据时间戳和收藏类型
- (BOOL)isExistPictureModel:(PictureModel *)picModel
{
    //数据库不存在,创建并打开
    if (!_dataBase) {
        [self openFunnyTimeDataBase];
    }
    
    if ([self.dataBase open]) {
        
        FMResultSet *rs = [self.dataBase executeQuery:@"select count(*) as 'count' from PictureCollectionList where timeStamp = ? and collectionType = ?",picModel.cTime,picModel.collectionType];
        while ([rs next]) {
            
            if ([rs intForColumn:@"count"]) {
                return YES;
            }else{
                return NO;
            }
        }
    }
    return NO;
}

//插入一条数据
- (void)insertPictureCollectionWithPictureModel:(PictureModel *)picModel
{
    //数据库不存在,创建并打开
    if (!_dataBase) {
        [self openFunnyTimeDataBase];
    }
    
    if (!picModel) {
        NSLog(@"insert faile");
        return;
    }
    
    if ([self.dataBase open]) {
        
        if (![self isExistPictureModel:picModel]) {
            
            NSString *sqlStmt = @"insert into PictureCollectionList(timeStamp, picURL, picHeight, picWidth, timeString, title, picType, collectionType) values (?,?,?,?,?,?,?,?) ";
            
            BOOL isInserted = [_dataBase executeUpdate:sqlStmt,picModel.cTime,picModel.pic, picModel.pic_h, picModel.pic_w, picModel.timeStr, picModel.title, picModel.pic_t, picModel.collectionType];
            
            if (isInserted) {
                NSLog(@"插入成功");
            }else{
                NSLog(@"插入失败");
            }
        }else{
            NSLog(@"图片已经存在");
        }
    }
}


//根据 根据时间戳和收藏类型 删除数据
- (void)deletePictureModel:(PictureModel *)picModel
{
    if (!_dataBase) {
        [self openFunnyTimeDataBase];
    }
    
    if (!picModel) {
        return;
    }
    
    if ([self.dataBase open]) {
        
        if ([self isExistPictureModel:picModel]) {  //数据存在才删除
           
            BOOL isDelete = [_dataBase executeUpdate:@"delete from PictureCollectionList where timeStamp = ? and collectionType = ?",picModel.cTime,picModel.collectionType];
            
            if (isDelete) {
                NSLog(@"删除成功");
            }else{
                NSLog(@"删除失败");
            }
        }
    }
    
}

//判断表中是否有数据
//- (BOOL)isContainedDataInPictureCollectionList
//{
//    //数据库不存在,创建并打开
//    if (!_dataBase) {
//        [self openFunnyTimeDataBase];
//    }
//    
//    if ([self.dataBase open]) {
//        
//        FMResultSet *rs = [self.dataBase executeQuery:@"select count(*) as 'count' from PictureCollectionList "];
//        while ([rs next]) {
//            
//            if ([rs intForColumn:@"count"]) {
//                return YES;
//            }else{
//                return NO;
//            }
//        }
//    }
//    return NO;
//    return NO;
//}


//取出所有数据
- (NSMutableArray *)selectedAllPictureCollection
{
    //数据库不存在,创建并打开
    if (!_dataBase) {
        [self openFunnyTimeDataBase];
    }
    
    NSMutableArray *mArray = nil;
    
    if ([self.dataBase open]) {
        
        if ([self isContainDataInTable:kPictureCollectionListTableName]) {
            
            mArray = [[NSMutableArray alloc] init];
            
            FMResultSet *rs = [_dataBase executeQuery:@"select * from PictureCollectionList"];
            
            while ([rs next]) {
                PictureModel *picModel = [[PictureModel alloc] init];
                
                picModel.cTime = [rs stringForColumn:@"timeStamp"];
                picModel.pic = [rs stringForColumn:@"picURL"];
                picModel.pic_h = [rs stringForColumn:@"picHeight"];
                picModel.pic_w = [rs stringForColumn:@"picWidth"];
                picModel.timeStr = [rs stringForColumn:@"timeString"];
                picModel.title = [rs stringForColumn:@"title"];
                picModel.pic_t = [rs stringForColumn:@"picType"];
                picModel.collectionType = [rs stringForColumn:@"collectionType"];
                
                [mArray addObject:picModel];
            }

            
            
        }
    }
    
    return mArray;
    
}


#pragma mark - 段子收藏表

//创建段子收藏表
- (void)createJokesCollectionTable
{
    //数据库不存在,创建并打开
    if (!_dataBase) {
        [self openFunnyTimeDataBase];
    }
    
    if ([self.dataBase open]) {
        
        if ([self isExistCollectionTableWithTableName:kJokesCollectionListTableName]) {
            return; //表已存在,直接返回
        }else{
            //表不存在,创建
            BOOL isCreated = [_dataBase executeUpdate:@"create table if not exists JokesCollectionList (title text PRIMARY KEY, ID text, cTime text, timeStr text, uname text, collectionType text)"];
            if (isCreated) {
                NSLog(@"段子收藏表创建成功");
            }else{
                NSLog(@"段子收藏表创建失败");
            }
            
        }
        
    }
    
}


//判断段子是否存在
- (BOOL)isExistJokeModel:(JokesModel *)jokeModel
{
    //数据库不存在,创建并打开
    if (!_dataBase) {
        [self openFunnyTimeDataBase];
    }
    
    if (!jokeModel) {
        NSLog(@"joke model is nil!!!");
        return NO;
    }
    
    if ([self.dataBase open]) {
        
        FMResultSet *rs = [self.dataBase executeQuery:@"select count(*) as 'count' from JokesCollectionList where title = ?",jokeModel.title];
        while ([rs next]) {
            if ([rs intForColumn:@"count"]) {
                return YES;
            }else{
                return NO;
            }
        }
        
    }
    
    return NO;
}

//插入一条数据
- (void)insertJokeCollectionWithJokeModel:(JokesModel *)jokeModel
{
    //数据库不存在,创建并打开
    if (!_dataBase) {
        [self openFunnyTimeDataBase];
    }
    
    if (!jokeModel) {
        NSLog(@"joke model is nil!!!");
        return ;
    }
    
    if ([self.dataBase open]) {
        
        if ([self isExistJokeModel:jokeModel]) {
            return ;
        }else{
            
             BOOL isInseted = [self.dataBase executeUpdate:@"insert into JokesCollectionList (title,ID,cTime,timeStr,uname,collectionType) values (?,?,?,?,?,?)",jokeModel.title,jokeModel.ID, jokeModel.cTime, jokeModel.timeStr, jokeModel.uname, jokeModel.collectionType];
            
            if (isInseted) {
                NSLog(@"插入成功");
            }else{
                NSLog(@"插入失败");
            }
        }
    }

    
}

//根据 title 删除数据
- (void)deleteJokeModel:(JokesModel *)jokeModel
{
    //数据库不存在,创建并打开
    if (!_dataBase) {
        [self openFunnyTimeDataBase];
    }
    
    if (!jokeModel) {
        NSLog(@"joke model is nil!!!");
        return ;
    }
    
    if ([self.dataBase open]) {
        
        if ([self isExistJokeModel:jokeModel]) {    //数据存在才删除
            
            BOOL isDelete = [self.dataBase executeUpdate:@"delete from JokesCollectionList where title = ?",jokeModel.title];
            
            if (isDelete) {
                NSLog(@"删除成功");
            }else{
                NSLog(@"删除失败");
            }
            
        }
    }
    
}



//取出所有数据
- (NSMutableArray *)selectedAllJokesCollection
{
    //数据库不存在,创建并打开
    if (!_dataBase) {
        [self openFunnyTimeDataBase];
    }
    
    NSMutableArray *dataArray = nil;
    
    if ([self.dataBase open]) {
        
        if ([self isContainDataInTable:kJokesCollectionListTableName]) {
            
            dataArray = [[NSMutableArray alloc] init];
            
            FMResultSet *rs = [self.dataBase executeQuery:@"select * from JokesCollectionList"];
            
            while ([rs next]) {
                
                JokesModel *jokeModel = [[JokesModel alloc] init];
                
                jokeModel.title = [rs stringForColumn:@"title"];
                jokeModel.ID = [rs stringForColumn:@"ID"];
                jokeModel.cTime = [rs stringForColumn:@"cTime"];
                jokeModel.timeStr = [rs stringForColumn:@"timeStr"];
                jokeModel.uname = [rs stringForColumn:@"uname"];
                jokeModel.collectionType = [rs stringForColumn:@"collectionType"];
                
                [dataArray addObject:jokeModel];
                
            }
            
        }
    }
    
    return dataArray;
}


#pragma mark - 声音的增删改查

//创建音频收藏表
- (void)createVoiceCollectionTable
{
    //数据库不存在,创建并打开
    if (!_dataBase) {
        [self openFunnyTimeDataBase];
    }
    
    if ([self.dataBase open]) {
        
        if ([self isExistCollectionTableWithTableName:kVoiceCollectionListTableName]) {
            return; //表已存在,直接返回
        }else{
            //表不存在,创建
            BOOL isCreated = [_dataBase executeUpdate:@"create table if not exists VoiceCollectionList (audioId text PRIMARY KEY, listenNum text, orderNum text, createTime text, duration text, albumName text, albumPic text, audioDes text, audioName text, audioPic text, mp3PlayUrl text, updateTime text)"];
            if (isCreated) {
                NSLog(@"声音收藏表创建成功");
            }else{
                NSLog(@"声音收藏表创建失败");
            }
            
        }
        
    }
}

//判断音频是否存在
- (BOOL)isExistVoiceModel:(VoicePlayListModel *)voiceModel
{
    //数据库不存在,创建并打开
    if (!_dataBase) {
        [self openFunnyTimeDataBase];
    }
    
    if (!voiceModel) {
        NSLog(@"voiceModel is nil!!!");
        return NO;
    }
    
    if ([self.dataBase open]) {
        
        FMResultSet *rs = [_dataBase executeQuery:@"select count(*) as 'count' from VoiceCollectionList where audioId = ?",voiceModel.audioId];
        while ([rs next]) {
            
            if ([rs intForColumn:@"count"]) {
                return YES;
            }else{
                return NO;
            }
        }
    }
    
    return NO;
}

//插入一条数据
- (void)insertVoiceCollectionWithJokeModel:(VoicePlayListModel *)voiceModel
{
    //数据库不存在,创建并打开
    if (!_dataBase) {
        [self openFunnyTimeDataBase];
    }
    
    if (!voiceModel) {
        NSLog(@"voiceModel is nil!!!");
        return ;
    }
    
    if ([self.dataBase open]) {
        
        BOOL isInserted = [_dataBase executeUpdate:@"insert into VoiceCollectionList (audioId,listenNum,orderNum,createTime,duration,albumName,albumPic,audioDes,audioName,audioPic,mp3PlayUrl,updateTime) values (?,?,?,?,?,?,?,?,?,?,?,?)",voiceModel.audioId,voiceModel.listenNum,voiceModel.orderNum,voiceModel.createTime,voiceModel.duration,voiceModel.albumName,voiceModel.albumPic,voiceModel.audioDes,voiceModel.audioName,voiceModel.audioPic,voiceModel.mp3PlayUrl,voiceModel.updateTime];
        if (isInserted) {
            NSLog(@"插入成功");
        }else{
            NSLog(@"插入失败");
        }
    }
    
}

//根据 ID 删除数据
- (void)deleteVoiceModel:(VoicePlayListModel *)voiceModel
{
    //数据库不存在,创建并打开
    if (!_dataBase) {
        [self openFunnyTimeDataBase];
    }
    
    if (!voiceModel) {
        NSLog(@"voiceModel is nil!!!");
        return ;
    }
    
    if ([self.dataBase open]) {
        
        if ([self isExistVoiceModel:voiceModel]) {
           
            BOOL isDeleted = [_dataBase executeUpdate:@"delete from VoiceCollectionList where audioId = ?",voiceModel.audioId];
            if (isDeleted) {
                NSLog(@"删除成功");
            }else{
                NSLog(@"删除失败");
            }
        }
        
    }
    
    
}


//取出所有数据
- (NSMutableArray *)selectedAllVoicesCollection
{
    //数据库不存在,创建并打开
    if (!_dataBase) {
        [self openFunnyTimeDataBase];
    }

    NSMutableArray *mArray = nil;
    
    if ([self.dataBase open]) {
        
        if ([self isContainDataInTable:kVoiceCollectionListTableName]) {
            mArray = [[NSMutableArray alloc] init];
            
            FMResultSet *rs = [_dataBase executeQuery:@"select * from VoiceCollectionList"];
            while ([rs next]) {
                VoicePlayListModel *voiceModel = [[VoicePlayListModel alloc] init];
                voiceModel.audioId = [rs stringForColumn:@"audioId"];
                voiceModel.listenNum = [rs stringForColumn:@"listenNum"];
                voiceModel.orderNum = [rs stringForColumn:@"orderNum"];
                voiceModel.createTime = [rs stringForColumn:@"createTime"];
                voiceModel.duration = [rs stringForColumn:@"duration"];
                voiceModel.albumName = [rs stringForColumn:@"albumName"];
                voiceModel.albumPic = [rs stringForColumn:@"albumPic"];
                voiceModel.audioDes = [rs stringForColumn:@"audioDes"];
                voiceModel.audioName = [rs stringForColumn:@"audioName"];
                voiceModel.audioPic = [rs stringForColumn:@"audioPic"];
                voiceModel.mp3PlayUrl = [rs stringForColumn:@"mp3PlayUrl"];
                voiceModel.updateTime = [rs stringForColumn:@"updateTime"];
                [mArray addObject:voiceModel];
            }
        }
        
    }

    return mArray;
}


#pragma mark - 视屏收藏列表

- (void)createVideoCollectionTable {
    if (!_dataBase) {
        [self openFunnyTimeDataBase];
    }
    
    if ([self.dataBase open]) {
        if ([self isExistCollectionTableWithTableName:kVideoCollectionListTableName]) {
            return;
        }
        else {
            BOOL isCreate = [self.dataBase executeUpdate:@"create table if not exists VideoCollectionList(title text, mp4_url text, cTime text, ID text, pic text)"];
            if (isCreate) {
                NSLog(@"视屏建表成功");
            }
            else {
                NSLog(@"视屏建表失败");
            }
        }
    }
}

//判断视屏是否存在
- (BOOL)isExistVideoModel:(VideoModel *)videoModel {
    if (!_dataBase) {
        [self openFunnyTimeDataBase];
    }
    
    if ([self.dataBase open]) {
        FMResultSet *rs = [self.dataBase executeQuery:@"select count(*) as 'count' from VideoCollectionList where title = ?", videoModel.title];
        while ([rs next]) {
            if ([rs intForColumn:@"count"]) {
                return YES;
            }
            else {
                return NO;
            }
        }
    }
    return NO;
}
//插入一条数据
- (void)insertVideoCollectionWithVideoModel:(VideoModel *)videoModel {
    if (!_dataBase) {
        [self openFunnyTimeDataBase];
    }
    
    if (!videoModel) {
        NSLog(@"video model is nil !!!");
        return;
    }
    
    if ([self.dataBase open]) {
        if (![self isExistVideoModel:videoModel]) {
            NSString *sqlStmt = @"insert into VideoCollectionList (title, mp4_url, cTime, ID, pic) values(?,?,?,?,?)";
            
            BOOL isInserted = [_dataBase executeUpdate:sqlStmt,videoModel.title, videoModel.mp4_url, videoModel.cTime, videoModel.ID, videoModel.pic];
            
            if (isInserted) {
                NSLog(@"插入成功");
            }
            else
                NSLog(@"插入失败+++");
        }
        else
            NSLog(@"视屏已经存在");
    }
    
}
//根据 title 删除数据
- (void)deleteVideoModel:(VideoModel *)videoModel {
    if (!_dataBase) {
        [self openFunnyTimeDataBase];
    }
    if (!videoModel) {
        NSLog(@"video model is nil !!!");
    }
    
    if ([self.dataBase open]) {
        
        if ([self isExistVideoModel:videoModel]) {
            
            BOOL isDelete = [self.dataBase executeUpdate:@"delete from VideoCollectionList where title = ?", videoModel.title];
            
            if (isDelete) {
                NSLog(@"删除成功");
            }
            else {
                NSLog(@"删除失败");
            }
        }
    }
}

//判断表中是否有数据
- (BOOL)isContainDataInVideoCollectionList {
    if (!_dataBase) {
        [self openFunnyTimeDataBase];
    }
    
    if ([self.dataBase open]) {
        
        FMResultSet *rs = [self.dataBase executeQuery:@"select count(*) as 'count' from VideoCollectionList"];
        while ([rs next]) {
            if ([rs intForColumn:@"count"]) {
                return YES;
            }
            else
                return NO;
        }
    }
    return NO;
}

//去除所有数据
- (NSMutableArray *)selectedAllVideoCollection {
    if (!_dataBase) {
        [self openFunnyTimeDataBase];
    }
    
    NSMutableArray *dataArray = nil;
    
    if ([self.dataBase open]) {
        
        if ([self isContainDataInVideoCollectionList]) {
            dataArray = [NSMutableArray array];
            FMResultSet *rs = [self.dataBase executeQuery:@"select * from VideoCollectionList"];
            
            while ([rs next]) {
                VideoModel *videoModel = [[VideoModel alloc] init];
                
                videoModel.title = [rs stringForColumn:@"title"];
                videoModel.ID = [rs stringForColumn:@"ID"];
                videoModel.pic = [rs stringForColumn:@"pic"];
                videoModel.cTime = [rs stringForColumn:@"cTime"];
                videoModel.mp4_url = [rs stringForColumn:@"mp4_url"];
                [dataArray addObject:videoModel];
                
            }
        }
    }
    return dataArray;
}





@end
