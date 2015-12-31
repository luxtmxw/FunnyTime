//
//  PicDetailViewController.h
//  FunnyTime
//
//  Created by luxt on 15/10/12.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PicDetailViewController : UIViewController

@property (nonatomic) float picWidth;
@property (nonatomic) float picHeight;
@property (nonatomic, strong) NSString *picURLStr;
@property (nonatomic, strong) UIImage *detailImage;
@end
