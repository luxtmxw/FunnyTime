//
//  AppHeader.h
//  FunnyTime
//
//  Created by luxt on 15/9/19.
//  Copyright (c) 2015年 luxt. All rights reserved.
//


//AppHeader（宏定义，例如 kWhite [UIColor whiteColor]）

#ifndef FunnyTime_AppHeader_h
#define FunnyTime_AppHeader_h


#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kBlurView [[BlurImageView alloc] initWithFrame:[UIScreen mainScreen].bounds]

#define kADC ADCustomTableView *ADCTableView = [[ADCustomTableView alloc] initWithFrame:self.tableView.frame style:(UITableViewStylePlain)];self.tableView = ADCTableView;

#define kUMAppkey @"56131c3067e58e1aef00143d"
#define kWXAppId @"wxee5ad9a29124f726"
#define kWXAppSecret @"d56025136ac29843783765edac50a8b5"
#define kQQAppId @"1104896568"
#define kQQAppKey @"utXcHZrWrnMMEfeu"
//分享平台，新浪，腾讯微博，人人，豆瓣，微信朋友圈
#define kShareToSnsNames [NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToDouban,UMShareToWechatTimeline,nil]

#endif
