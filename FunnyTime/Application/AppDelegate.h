//
//  AppDelegate.h
//  FunnyTime
//
//  Created by luxt on 15/9/19.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LeftSlideViewController.h"


#import "BaseTabBarController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) LeftSlideViewController *leftSlideVC;
@property (strong, nonatomic) BaseTabBarController *baseTabBarC;

@end

