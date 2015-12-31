//
//  VideoModel.h
//  FunnyTime
//
//  Created by luxt on 15/9/24.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoModel : NSObject

@property (nonatomic, strong) NSString *mp4_url;
@property (nonatomic, strong) NSString *pic;
@property (nonatomic, strong) NSString *timeStr;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *uname;
@property (nonatomic, strong) NSString *cTime;

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *pic_h;
@property (nonatomic, strong) NSString *pic_t;
@property (nonatomic, strong) NSString *pic_w;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *web_url;

+ (VideoModel *)videoModelWithDic:(NSDictionary *)dic;

@end
