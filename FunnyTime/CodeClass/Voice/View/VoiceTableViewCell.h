//
//  VoiceTableViewCell.h
//  FunnyTime
//
//  Created by luxt on 15/9/25.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoiceTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *picImageView;
@property (nonatomic, strong) UILabel *albumNameLabel;
@property (nonatomic, strong) UILabel *listenNumLabel;
@property (nonatomic, strong) UIImageView *musicIcon;
//@property (nonatomic, strong) UILabel *followdeNumLabel;

- (void)setUpWithPicImage:(NSString *)picUrl albumname:(NSString *)albumName listenNum:(NSString *)listenNum;

@end
