//
//  VoiceListModel.h
//  FunnyTime
//
//  Created by luxt on 15/9/24.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VoiceListModel : NSObject

@property (nonatomic, strong) NSString *nextPage;   //下个page的值
@property (nonatomic, strong) NSString *currentPage;    //当前page的值
@property (nonatomic, strong) NSString *prePage;    //前一个page的值
@property (nonatomic, strong) NSString *totalCounts;    //总共有多少个item
@property (nonatomic, strong) NSString *totalPages; //总共有多少个page

@property (nonatomic, strong) NSString *ID; // id名
@property (nonatomic, strong) NSString *listenNum;  //听众数量
@property (nonatomic, strong) NSString *followedNum;    //收藏人数

@property (nonatomic, strong) NSString *name;   //名字
@property (nonatomic, strong) NSString *albumName;  //专辑名
@property (nonatomic, strong) NSString *desc;   //专辑详情
@property (nonatomic, strong) NSString *pic;    //图片URL

+ (VoiceListModel *)shareWithResultDic:(NSDictionary *)resultDic dic:(NSDictionary *)dic;

@end
