//
//  VoiceListTableViewCell.m
//  FunnyTime
//
//  Created by luxt on 15/10/2.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import "VoiceListTableViewCell.h"

#define kLengthOfImageView 25

@implementation VoiceListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.PlayingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kLengthOfImageView, self.frame.size.height)];
        
        NSMutableArray *marray = [NSMutableArray array];
        for (int i = 0; i < 4; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"isPlayingIcon_000%d",i]];
            [marray addObject:image];
        }
        self.PlayingImageView.animationImages = marray;
        self.PlayingImageView.animationDuration = 0.5;
//        [self.PlayingImageView startAnimating];
        
        [self.contentView addSubview:self.PlayingImageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLengthOfImageView, 0, 0.5 * kScreenWidth - kLengthOfImageView, self.frame.size.height)];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

@end
