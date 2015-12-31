//
//  JokesTableViewCell.h
//  FunnyTime
//
//  Created by luxt on 15/9/23.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"
#define kDistanceOfEdge 0.04 * kScreenWidth
#define kHeightOfWord   0.11 * kScreenWidth


@interface JokesTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *background;

@property (nonatomic, strong) UILabel *timeLabel;
//@property (nonatomic, strong) UIImageView  *litterImage;
@property (nonatomic, strong) TTTAttributedLabel *contentLabel;


@property (nonatomic, strong) UIButton *collectionButton;
@property (nonatomic, strong) UILabel *collectionLabel;

@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UILabel *shareLabel;

@property (nonatomic, strong) UIButton *collectionBigButton;
@property (nonatomic, strong) UIButton *shareBigButton;

@end
