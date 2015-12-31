//
//  VoicePlayListModel.m
//  FunnyTime
//
//  Created by luxt on 15/9/24.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import "VoicePlayListModel.h"

@implementation VoicePlayListModel

+ (VoicePlayListModel *)shareWithResultDic:(NSDictionary *)resultDic dic:(NSDictionary *)dic {
    VoicePlayListModel *model = [[VoicePlayListModel alloc] init];
    [model setValuesForKeysWithDictionary:resultDic];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    
    if ([key isEqualToString:@"count"]) {
        self.count = [NSString stringWithFormat:@"%@",value];
    }
    
    if ([key isEqualToString:@"currentpage"]) {
        self.currentpage = [NSString stringWithFormat:@"%@",value];
    }

    if ([key isEqualToString:@"nextPage"]) {
        self.nextPage = [NSString stringWithFormat:@"%@",value];
    }

    if ([key isEqualToString:@"pageSize"]) {
        self.pageSize = [NSString stringWithFormat:@"%@",value];
    }

    if ([key isEqualToString:@"albumId"]) {
        self.albumId = [NSString stringWithFormat:@"%@",value];
    }

    if ([key isEqualToString:@"audioId"]) {
        self.audioId = [NSString stringWithFormat:@"%@",value];
    }

    if ([key isEqualToString:@"likedNum"]) {
        self.likedNum = [NSString stringWithFormat:@"%@",value];
    }

    if ([key isEqualToString:@"listenNum"]) {
        self.listenNum = [NSString stringWithFormat:@"%@",value];
    }

    if ([key isEqualToString:@"orderNum"]) {
        self.orderNum = [NSString stringWithFormat:@"%@",value];
    }

    if ([key isEqualToString:@"createTime"]) {
        self.createTime = [NSString stringWithFormat:@"%@",value];
    }

    if ([key isEqualToString:@"duration"]) {
        self.duration = [NSString stringWithFormat:@"%@",value];
    }
    
    if ([key isEqualToString:@"haveNext"]) {
        self.haveNext = [NSString stringWithFormat:@"%@",value];
    }

    if ([key isEqualToString:@"audioDes"]) {
        NSString *des = [NSString stringWithFormat:@"%@",value];
        NSArray *array = [des componentsSeparatedByString:@"/n"];
        if (array) {
            self.audioDes = [array firstObject];
        }else{
            self.audioDes = des;
        }
   
    }
    
}

@end
