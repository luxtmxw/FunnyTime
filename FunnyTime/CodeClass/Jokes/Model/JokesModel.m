//
//  JokesModel.m
//  FunnyTime
//
//  Created by luxt on 15/9/23.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import "JokesModel.h"

@implementation JokesModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
+ (JokesModel *)JockesModelWithDictionary:(NSDictionary *)dic{
    JokesModel *model = [[JokesModel alloc] init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}

- (void)setValue:(id)value forKey:(NSString *)key{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"id"]) {
        self.ID = [NSString stringWithFormat:@"%@", value];
    }
    
    if ([key isEqualToString:@"wbody"]) {
        self.title = [NSString stringWithFormat:@"%@", value];
    }
    
    if ([key isEqualToString:@"update_time"]) {
        self.cTime = [NSString stringWithFormat:@"%@", value];
        
        self.timeStr = [self transformToTimeStringWithTimeStamp:[NSString stringWithFormat:@"%@", value]];
    }
    
    if ([key isEqualToString:@"uname"])
    {
        self.uname = [NSString stringWithFormat:@"百科笑话"];
    }
}

//将时间转换格式
- (NSString *)transformToTimeStringWithTimeStamp:(NSString *)timeStamp
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[timeStamp floatValue]];
    NSDateFormatter *formtter = [[NSDateFormatter alloc] init];
    formtter.dateFormat = @"MM-dd HH:mm";
    NSString *timestr = [formtter stringFromDate:date];
    
    return timestr;
}




@end
