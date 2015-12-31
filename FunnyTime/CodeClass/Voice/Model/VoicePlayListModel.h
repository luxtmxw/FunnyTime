//
//  VoicePlayListModel.h
//  FunnyTime
//
//  Created by luxt on 15/9/24.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VoicePlayListModel : NSObject

@property (nonatomic, strong) NSString *currentpage;//当前page的值*
@property (nonatomic, strong) NSString *nextPage;   //下个page的值*

@property (nonatomic, strong) NSString *albumId;    //专辑id*
@property (nonatomic, strong) NSString *audioId;    //音频id*
@property (nonatomic, strong) NSString *likedNum;   //收藏人数*
@property (nonatomic, strong) NSString *listenNum;  //听众人数*
@property (nonatomic, strong) NSString *orderNum;   //第几期*
@property (nonatomic, strong) NSString *createTime;   //创建时间*
@property (nonatomic, strong) NSString *duration;   //持续时间*

@property (nonatomic, strong) NSString *albumName;  //专辑名*
@property (nonatomic, strong) NSString *albumPic;   //专辑图片地址*
@property (nonatomic, strong) NSString *audioDes;   //音频详情描述*
@property (nonatomic, strong) NSString *audioName;  //音频名称*
@property (nonatomic, strong) NSString *audioPic;   //音频图片地址*
@property (nonatomic, strong) NSString *mp3PlayUrl; //MP3音频链接地址*
@property (nonatomic, strong) NSString *updateTime; //更新时间*

@property (nonatomic, strong) NSString *haveNext; //是否有下一页*

@property (nonatomic, strong) NSString *count;      //节目总数
@property (nonatomic, strong) NSString *pageSize;   //page的size

+ (VoicePlayListModel *)shareWithResultDic:(NSDictionary *)resultDic dic:(NSDictionary *)dic;

@end
