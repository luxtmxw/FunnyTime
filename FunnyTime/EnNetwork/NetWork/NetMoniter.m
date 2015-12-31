//
//  NetMoniter.m
//  FunnyTime
//
//  Created by luxt on 15/10/6.
//  Copyright © 2015年 luxt. All rights reserved.
//

#import "NetMoniter.h"

@implementation NetMoniter
static NetMoniter *_sharedClient = nil;
+ (instancetype)sharedClient {
    
    static dispatch_once_t onceToken;
    
    NSString * APIBaseURLString = [NSString stringWithFormat:@"https://api.app.net/"];
    ;
    
    dispatch_once(&onceToken, ^{
        _sharedClient = [[NetMoniter alloc] initWithBaseURL:[NSURL URLWithString:APIBaseURLString]];
        [_sharedClient setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey]];
        
        
    });
    
    return _sharedClient;
}
- (void)dismissAlertViewNoLine:(UIAlertView *)alertView {
    [alertView dismissWithClickedButtonIndex:[alertView cancelButtonIndex] animated:NO];
}
- (void)setMonter {
    [_sharedClient.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN: {
//                NSLog(@"网络已连接流量+++++");
                self.isCennected = YES;
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"当前使用的是流量" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
//                [self performSelector:@selector(dismissAlertViewNoLine:) withObject:alertView afterDelay:2];
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"网络已连接WIFI++++");
                self.isCennected = YES;
                
                break;
            case AFNetworkReachabilityStatusNotReachable: {
                NSLog(@"当前网络不可用,请联系管理员++++");
                self.isCennected = NO;
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"当前网络不可用" message:@"请检查网络" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [SVProgressHUD dismiss];
                [self performSelector:@selector(dismissAlertViewNoLine:) withObject:alertView afterDelay:2];
                
                [alertView show];
                break;
            }
                
            default:
                break;
        }
    }];
    [_sharedClient.reachabilityManager startMonitoring];
}

- (void)showNetWorkNotReachableAlert
{
    [self checkNetWork];
    
    if (!self.isCennected) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"当前网络不可用" message:@"请检查网络" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alertView show];
        [self performSelector:@selector(dismissAlertViewNoLine:) withObject:alertView afterDelay:2];
    }
    
    NSLog(@"showNetWorkNotReachableAlert");
}


- (void)checkNetWork
{
    [_sharedClient.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                self.isCennected = YES;
            }
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                self.isCennected = YES;
            }
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
            {
                self.isCennected = NO;
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"当前网络不可用" message:@"请检查网络" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alertView show];
                [self performSelector:@selector(dismissAlertViewNoLine:) withObject:alertView afterDelay:2];
            }
                break;
  
            default:
                break;
        }
        
    }];
}

@end
