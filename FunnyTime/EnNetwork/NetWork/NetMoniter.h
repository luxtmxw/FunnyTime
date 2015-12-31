//
//  NetMoniter.h
//  FunnyTime
//
//  Created by luxt on 15/10/6.
//  Copyright © 2015年 luxt. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import <UIKit/UIKit.h>
@interface NetMoniter : AFHTTPSessionManager<UIAlertViewDelegate>
@property (nonatomic, strong) UIAlertView *alertView;
@property (nonatomic) BOOL isCennected;
+ (instancetype)sharedClient;
- (void)setMonter;
//- (void)showNetWorkNotReachableAlert;
- (void)checkNetWork;
@end
