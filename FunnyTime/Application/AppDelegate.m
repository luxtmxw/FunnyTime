//
//  AppDelegate.m
//  FunnyTime
//
//  Created by luxt on 15/9/19.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import "AppDelegate.h"
#import "LeftSettingViewController.h"
#import "WelcomeViewController.h"
#import "UMSocialWechatHandler.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //设置app的友盟appKey
    [UMSocialData setAppKey:kUMAppkey];
    //微信分享设置
    [UMSocialWechatHandler setWXAppId:kWXAppId appSecret:kWXAppSecret url:nil];

    //打开数据库 建表
    [[FunnyTimeDataBase shareFunnyTimeDataBase] createPictureCollectionTable];
    [[FunnyTimeDataBase shareFunnyTimeDataBase] createJokesCollectionTable];
    [[FunnyTimeDataBase shareFunnyTimeDataBase] createVideoCollectionTable];
    [[FunnyTimeDataBase shareFunnyTimeDataBase] createVoiceCollectionTable];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //背景图
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imageView.image = [UIImage imageNamed:@"leftBack_654684121"];
    imageView.userInteractionEnabled = YES;
    [self.window addSubview:imageView];
    
    self.window.backgroundColor = [UIColor greenColor];
    [self.window makeKeyAndVisible];
    
    self.baseTabBarC = [[BaseTabBarController alloc] init];
    
    LeftSettingViewController *leftSettingVC = [[LeftSettingViewController alloc] init];
    
    self.leftSlideVC = [[LeftSlideViewController alloc] initWithLeftView:leftSettingVC andMainView:self.baseTabBarC];
    [self.leftSlideVC setPanEnabled:YES];

    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goinApp) name:@"launchApp" object:nil];

    
    
    NSString *firstLaunchStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"firstLaunch"];
    
    //判断是否第一次进入程序
    if (firstLaunchStr) {
        self.window.rootViewController = self.leftSlideVC;
    }else{
        self.window.rootViewController = [[WelcomeViewController alloc] init];
    }
    
    //告诉系统，我们要接受远程控制事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self canBecomeFirstResponder];
    
    //网络监控
    [[NetMoniter sharedClient] setMonter];
    
    return YES;
}

- (void)goinApp
{
    self.window.rootViewController = self.leftSlideVC;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

//响应远程音乐播放控制消息
- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    if (event.type == UIEventTypeRemoteControl) {
        
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlTogglePlayPause:{
                if ([VoicePlayer shareVoicePlayer].isPlaying) {
                    [[VoicePlayer shareVoicePlayer] stopPlayVoice];
                }else{
                    [[VoicePlayer shareVoicePlayer] starPlayVoice];
                }
                
            }break;
                
            case UIEventSubtypeRemoteControlPlay:
            {
                [[VoicePlayer shareVoicePlayer] starPlayVoice];
            }break;
                
            case UIEventSubtypeRemoteControlPause:
            {
                [[VoicePlayer shareVoicePlayer] stopPlayVoice];
            }break;
                
            case UIEventSubtypeRemoteControlNextTrack:
            {
                [[VoicePlayer shareVoicePlayer] next];
            }break;
                
            case UIEventSubtypeRemoteControlPreviousTrack:
            {
                [[VoicePlayer shareVoicePlayer] prev];
            }break;
                
                
            default:
                break;
        }
        
    }
}



- (void)applicationWillResignActive:(UIApplication *)application {
   }

- (void)applicationDidEnterBackground:(UIApplication *)application {
   
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
   
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
   }

- (void)applicationWillTerminate:(UIApplication *)application {
   
}

@end
