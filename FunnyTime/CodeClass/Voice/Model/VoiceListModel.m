//
//  VoiceListModel.m
//  FunnyTime
//
//  Created by luxt on 15/9/24.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import "VoiceListModel.h"

@implementation VoiceListModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

+ (VoiceListModel *)shareWithResultDic:(NSDictionary *)resultDic dic:(NSDictionary *)dic {
    VoiceListModel *model = [[VoiceListModel alloc] init];
    [model setValuesForKeysWithDictionary:resultDic];
    [model setValuesForKeysWithDictionary:dic];
    
    return model;
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    
    if ([key isEqualToString:@"id"]) {
        self.ID = [NSString stringWithFormat:@"%@",value];
    }
    
    if ([key isEqualToString:@"nextPage"]) {
        self.nextPage = [NSString stringWithFormat:@"%@",value];
    }
    
    if ([key isEqualToString:@"currentPage"]) {
        self.currentPage = [NSString stringWithFormat:@"%@",value];
    }
    
    if ([key isEqualToString:@"prePage"]) {
        self.prePage = [NSString stringWithFormat:@"%@",value];
    }
    
    if ([key isEqualToString:@"totalCounts"]) {
        self.totalCounts = [NSString stringWithFormat:@"%@",value];
    }
    
    if ([key isEqualToString:@"totalPages"]) {
        self.totalPages = [NSString stringWithFormat:@"%@",value];
    }
    
    if ([key isEqualToString:@"followedNum"]) {
        self.followedNum = [NSString stringWithFormat:@"%@",value];
    }
    
    if ([key isEqualToString:@"desc"]) {
        NSString *des = [NSString stringWithFormat:@"%@",value];
        NSArray *array = [des componentsSeparatedByString:@"网友"];
        if (array) {
//            NSLog(@"%zi",array.count);
            self.desc = array[0];
//            NSLog(@"%@",self.desc);
        }else{
            self.desc = des;
        }
        
    }

    if ([key isEqualToString:@"二货一箩筐（微信erhuofm）"]) {
        self.albumName = @"二货一箩筐";
    }
}

@end
