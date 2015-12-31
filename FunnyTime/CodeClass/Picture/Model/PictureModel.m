//
//  PictureModel.m
//  FunnyTime
//
//  Created by luxt on 15/9/19.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import "PictureModel.h"

@implementation PictureModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    
    if ([key isEqualToString:@"id"]) {
        self.ID = [NSString stringWithFormat:@"%@",value];
    }
    
    if ([key isEqualToString:@"wid"]) {
        self.ID = [NSString stringWithFormat:@"%@",value];
    }
    
    if ([key isEqualToString:@"is_gif"]) {
        if ([value isEqualToString:@"1"]) {
            self.pic_t = @"gif";
        }
        
        if ([value isEqualToString:@"0"]) {
            self.pic_t = @"jpg";
        }
    }
    
    if ([key isEqualToString:@"pic_t"]) {
        if ([value isEqualToString:@"gif"]) {
            self.is_gif = @"1";
        }
        
        if ([value isEqualToString:@"jpg"]) {
            self.is_gif = @"0";
        }
    }
    
    if ([key isEqualToString:@"update_time"]) {
        self.cTime = [NSString stringWithFormat:@"%@",value];

        self.timeStr = [self transformToTimeStringWithTimeStamp:[NSString stringWithFormat:@"%@",value]];
    }
    
    if ([key isEqualToString:@"wpic_large"]) {
        self.pic = [NSString stringWithFormat:@"%@",value];
    }
    
    if ([key isEqualToString:@"wpic_m_height"]) {
        self.pic_h = [NSString stringWithFormat:@"%@",value];
    }
    
    if ([key isEqualToString:@"wpic_m_width"]) {
        self.pic_w = [NSString stringWithFormat:@"%@",value];
    }
    
    if ([key isEqualToString:@"wbody"]) {
        self.title = [NSString stringWithFormat:@"%@",value];
    }
    
    //新的model
    if ([key isEqualToString:@"Pubtime"]) {
        self.cTime = [NSString stringWithFormat:@"%@",value];
        
        self.timeStr = [self transformToTimeStringWithTimeStamp:[NSString stringWithFormat:@"%@",value]];
    }
    
    if ([key isEqualToString:@"Title"]) {
        self.title = [NSString stringWithFormat:@"%@",value];
    }
    
    if ([key isEqualToString:@"ArticleId"]) {
        self.ID = [NSString stringWithFormat:@"%@",value];
    }
    
    if ([key isEqualToString:@"Height"]) {
        self.pic_h = [NSString stringWithFormat:@"%@",value];
    }
    
    if ([key isEqualToString:@"Width"]) {
        self.pic_w = [NSString stringWithFormat:@"%@",value];
    }
    
    if ([key isEqualToString:@"Url"]) {
        self.pic = [NSString stringWithFormat:@"%@",value];
    }
    
    if ([key isEqualToString:@"id"]) {
        self.ID = [NSString stringWithFormat:@"%@",value];
    }
    
    
}

- (NSString *)transformToTimeStringWithTimeStamp:(NSString *)timeStamp
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[timeStamp floatValue]];
    NSDateFormatter *formtter = [[NSDateFormatter alloc] init];
    formtter.dateFormat = @"MM-dd HH:mm";
    NSString *timestr = [formtter stringFromDate:date];
    
    return timestr;
}

+ (PictureModel *)pictureModelWithDictionary:(NSDictionary *)dic
{
    PictureModel *model = [[PictureModel alloc] init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}

+ (PictureModel *)NewPictureModelWithMainDictionary:(NSDictionary *)mainDic ImageDic:(NSDictionary *)imageDic
{
    PictureModel *model = [[PictureModel alloc] init];
    [model setValuesForKeysWithDictionary:mainDic];
    [model setValuesForKeysWithDictionary:imageDic];
    model.pic_t = @"0";
    model.collectionType = @"0";
    return model;
}

@end
