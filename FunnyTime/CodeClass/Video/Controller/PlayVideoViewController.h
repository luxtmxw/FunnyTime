//
//  PlayVideoViewController.h
//  FunnyTime
//
//  Created by luxt on 15/9/24.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoModel.h"

@interface PlayVideoViewController : UIViewController

@property (nonatomic, strong) VideoModel *videoModel;
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, assign) NSInteger index;
@end
