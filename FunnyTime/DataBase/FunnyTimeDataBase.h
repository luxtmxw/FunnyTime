//
//  FunnyTimeDataBase.h
//  FunnyTime
//
//  Created by luxt on 15/9/21.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

#import "PictureModel.h"
#import "JokesModel.h"
#import "VoicePlayListModel.h"
#import "VideoModel.h"

@interface FunnyTimeDataBase : NSObject

@property (nonatomic, strong) FMDatabase *dataBase;

//创建单例类
+ (FunnyTimeDataBase *)shareFunnyTimeDataBase;

//打开数据库
- (void)openFunnyTimeDataBase;

//关闭数据库
-  (void)closeSqlite;

#pragma mark - 图片收藏表的增删改查

//创建图片收藏表
- (void)createPictureCollectionTable;

//判断图片是否存在
- (BOOL)isExistPictureModel:(PictureModel *)picModel;

//插入一条数据
- (void)insertPictureCollectionWithPictureModel:(PictureModel *)picModel;

//根据 根据时间戳和收藏类型 删除数据
- (void)deletePictureModel:(PictureModel *)picModel;

//取出所有数据
- (NSMutableArray *)selectedAllPictureCollection;

//根据 ... 取出数据


#pragma mark - 段子收藏表的增删改查

//创建段子收藏表
- (void)createJokesCollectionTable;

//判断段子是否存在
- (BOOL)isExistJokeModel:(JokesModel *)jokeModel;

//插入一条数据
- (void)insertJokeCollectionWithJokeModel:(JokesModel *)jokeModel;

//根据 title 删除数据
- (void)deleteJokeModel:(JokesModel *)jokeModel;

//取出所有数据
- (NSMutableArray *)selectedAllJokesCollection;

//根据 ... 取出数据

#pragma mark - 声音的增删改查

//创建音频收藏表
- (void)createVoiceCollectionTable;

//判断音频是否存在
- (BOOL)isExistVoiceModel:(VoicePlayListModel *)voiceModel;

//插入一条数据
- (void)insertVoiceCollectionWithJokeModel:(VoicePlayListModel *)voiceModel;

//根据 ID 删除数据
- (void)deleteVoiceModel:(VoicePlayListModel *)voiceModel;

//取出所有数据
- (NSMutableArray *)selectedAllVoicesCollection;

//根据 ... 取出数据

#pragma mark - 视屏收藏表的增删该查
//创建视屏收藏表
- (void)createVideoCollectionTable;

//判断视屏是否存在
- (BOOL)isExistVideoModel:(VideoModel *)videoModel;

//插入数据
- (void)insertVideoCollectionWithVideoModel:(VideoModel *)videoModel;

//根据 title 删除数据
- (void)deleteVideoModel:(VideoModel *)videoModel;

//所有数据
- (NSMutableArray *)selectedAllVideoCollection;




@end
