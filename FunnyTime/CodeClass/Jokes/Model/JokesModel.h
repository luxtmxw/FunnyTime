//
//  JokesModel.h
//  FunnyTime
//
//  Created by luxt on 15/9/23.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JokesModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *cTime;
@property (nonatomic, strong) NSString *timeStr;

@property (nonatomic, strong) NSString *uname;
@property (nonatomic, strong) NSString *ID;

@property (nonatomic, strong) NSString *collectionType;

//评论和喜欢(点赞)
@property (nonatomic, strong) NSString *comments;
@property (nonatomic, strong) NSString *likes;
@property (nonatomic, strong) NSString *wid;

+ (JokesModel *)JockesModelWithDictionary:(NSDictionary *)dic;

@end
