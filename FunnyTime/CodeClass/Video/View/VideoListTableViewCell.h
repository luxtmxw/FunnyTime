//
//  VideoListTableViewCell.h
//  FunnyTime
//
//  Created by luxt on 15/9/24.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoListTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *picImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *likeLabel;
//传参数方法
- (void)setUpVideoTableCellWithPic:(NSString *)picImage titleLabel:(NSString *)titleLabel timeLabel:(NSString *)timeLabel likeLabelL:(NSString *)likeLabel;

@end
