//
//  PictureModel.h
//  FunnyTime
//
//  Created by luxt on 15/9/19.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PictureModel : NSObject

@property (nonatomic, strong) NSString *cTime; //时间戳
@property (nonatomic, strong) NSString *pic; //图片URL
@property (nonatomic, strong) NSString *pic_h;  //图片高度
@property (nonatomic, strong) NSString *pic_w;  //图片宽度
@property (nonatomic, strong) NSString *timeStr;    //图片时间
@property (nonatomic, strong) NSString *title;  //图片介绍

@property (nonatomic, strong) NSString *ID; //图片ID
@property (nonatomic, strong) NSString *pic_t;  //图片类型

@property (nonatomic, strong) NSString *collectionType; //自定义收藏类型

@property (nonatomic, strong) NSString *uname;  //图片来源
@property (nonatomic, strong) NSString *cate_id;    //
@property (nonatomic, strong) NSString *is_gif; //是否gif
@property (nonatomic, strong) NSString *likes;  //喜欢人数


+ (PictureModel *)pictureModelWithDictionary:(NSDictionary *)dic;

+ (PictureModel *)NewPictureModelWithMainDictionary:(NSDictionary *)mainDic ImageDic:(NSDictionary *)imageDic;

@end
