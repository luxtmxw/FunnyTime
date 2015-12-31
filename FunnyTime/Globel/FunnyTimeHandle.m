//
//  FunnyTimeHandle.m
//  FunnyTime
//
//  Created by luxt on 15/10/6.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import "FunnyTimeHandle.h"

@implementation FunnyTimeHandle

static FunnyTimeHandle *handle = nil;

+ (FunnyTimeHandle *)shareFunnyTimeHandle
{
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        
        handle = [[FunnyTimeHandle alloc] init];

    });
    return handle;
}

- (float)statusBarHeight
{
    return [[UIApplication sharedApplication] statusBarFrame].size.height;
}


@end
