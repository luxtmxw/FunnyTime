//
//  BaseTabBarController.m
//  FunnyTime
//
//  Created by luxt on 15/9/19.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import "BaseTabBarController.h"

#import "JokesViewController.h"
//#import "PictureViewController.h"
#import "VideoListTableViewController.h"
#import "VoiceTableViewController.h"

#import "PictureNewTableViewController.h"

#import "AppDelegate.h"

@interface BaseTabBarController ()

@end

@implementation BaseTabBarController


- (void)viewDidLoad {
    [super viewDidLoad];

    JokesViewController *jokesVC = [[JokesViewController alloc] init];
    [self addVC:jokesVC title:@"段子" imageName:@"jokes_Icon_30.png"];
    
    PictureNewTableViewController *picVC = [[PictureNewTableViewController alloc] init];
    [self addVC:picVC title:@"趣图" imageName:@"bluePicIcon_30.png"];
    
    VideoListTableViewController *video = [[VideoListTableViewController alloc] init];
    [self addVC:video title:@"视频" imageName:@"video_Icon_30.png"];
    
    VoiceTableViewController *voiceVC = [[VoiceTableViewController alloc] init];
    [self addVC:voiceVC title:@"声音" imageName:@"NewMusic_Icon_30.png"];
    
    
    
//    self.tabBar.barTintColor = [UIColor colorWithWhite:0.200 alpha:1.000];
    self.tabBar.tintColor = [UIColor redColor];
    self.tabBar.alpha = 0.95;
    [self.tabBar setBackgroundImage:[UIImage imageNamed:@"TabBarIcon.png"]];
    
    
    //全局设置导航条
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"NavigationBarIcon.png"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    
}

- (void)addVC:(UIViewController *)childVC title:(NSString *)title imageName:(NSString *)imageName
{
    childVC.title = title;
    childVC.tabBarItem.image = [UIImage imageNamed:imageName];
    [childVC.tabBarItem setSelectedImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    
    //设置按钮
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(0, 0, 20, 18);
    menuBtn.tintColor = [UIColor redColor];
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"settingMenuIcon@2x"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(openOrCloseLeftList) forControlEvents:UIControlEventTouchUpInside];
    childVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:childVC];
    
    nvc.navigationBar.frame = CGRectMake(0, 0, nvc.navigationBar.frame.size.width, 64);//固定navigationBar高度
    
    
    [self addChildViewController:nvc];
}


- (void)openOrCloseLeftList{
    
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (tempAppDelegate.leftSlideVC.closed) {
        [tempAppDelegate.leftSlideVC openLeftView];
    }else{
        [tempAppDelegate.leftSlideVC closeLeftView];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.leftSlideVC setPanEnabled:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.leftSlideVC setPanEnabled:NO];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
