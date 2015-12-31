//
//  SettingBackgroundBlurCollectionViewCell.m
//  FunnyTime
//
//  Created by luxt on 15/10/6.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import "SettingBackgroundBlurCollectionViewCell.h"

@implementation SettingBackgroundBlurCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.picView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        [self.contentView addSubview:self.picView];
        
        self.forePicView = [[UIImageView alloc] initWithFrame:self.picView.frame];
        self.forePicView.image = [UIImage imageNamed:@"selectedbackblurView_0002.png"];
        [self.contentView addSubview:self.forePicView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.picView.bottom, self.picView.width, 20)];
        self.nameLabel.numberOfLines = 0;
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.nameLabel.font = [UIFont systemFontOfSize:16];
        self.nameLabel.text = @"dfiodgfg";
//        self.nameLabel.backgroundColor = [UIColor greenColor];
        [self.contentView addSubview:self.nameLabel];
        
    }
    return self;
}

@end
