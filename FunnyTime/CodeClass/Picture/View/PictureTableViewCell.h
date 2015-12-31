//
//  PictureTableViewCell.h
//  FunnyTime
//
//  Created by luxt on 15/9/19.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"
#define kLengthOfBackViewToEdge 10
#define kLengthOfTitleToEdge (10)
#define kLengthOfMainPictureToEdge (10)

#define kLengthOfTitle (kScreenWidth - kLengthOfBackViewToEdge * 2 - kLengthOfTitleToEdge * 2)
#define kLengthOfMainPicture (kScreenWidth - kLengthOfBackViewToEdge * 2 - kLengthOfMainPictureToEdge * 2)

#define kHeightOfTimeLabel 15
#define kHeightOfCollectButton 30

#define kFontOfTitle [UIFont systemFontOfSize:16]


@interface PictureTableViewCell : UITableViewCell

@property (nonatomic, strong) TTTAttributedLabel *titleLabel;
@property (nonatomic, strong) UIImageView *mainImageView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) TTTAttributedLabel *timeLabel;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UIButton *collectButton;
@property (nonatomic, strong) UIButton *shareButton;

@property (nonatomic, strong) UIButton *collectBigButton;
@property (nonatomic, strong) UIButton *shareBigButton;


@end
