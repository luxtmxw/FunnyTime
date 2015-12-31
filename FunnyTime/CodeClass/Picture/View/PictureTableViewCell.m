//
//  PictureTableViewCell.m
//  FunnyTime
//
//  Created by luxt on 15/9/19.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import "PictureTableViewCell.h"
#import "UIView+WLFrame.h"



@implementation PictureTableViewCell

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
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        //背景
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(kLengthOfBackViewToEdge, 0, kScreenWidth - kLengthOfBackViewToEdge * 2, 50)];
        self.backView.backgroundColor = [UIColor colorWithRed:0.646 green:0.917 blue:0.902 alpha:0.6];
        self.backView.layer.cornerRadius = 5;
        [self.contentView addSubview:self.backView];
        
       //时间
        self.timeLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(kScreenWidth - 200 - 30, 0, 200, kHeightOfTimeLabel)];
        self.timeLabel.textColor = [UIColor colorWithWhite:0.800 alpha:1.000];
        self.timeLabel.font = [UIFont systemFontOfSize:11];
//        self.timeLabel.backgroundColor = [UIColor greenColor];
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        [self.backView addSubview:self.timeLabel];
        
        
        
        //标题
        self.titleLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(kLengthOfTitleToEdge, self.timeLabel.bottom, kLengthOfTitle, 30)];
        self.titleLabel.font = kFontOfTitle;
        self.titleLabel.numberOfLines = 0;
//        self.titleLabel.backgroundColor = [UIColor lightGrayColor];
        [self.backView addSubview:self.titleLabel];
        
        //图片
        self.mainImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kLengthOfMainPictureToEdge, self.titleLabel.bottom + 5, kLengthOfMainPicture, 100)];
        self.mainImageView.layer.cornerRadius = 4;
//        self.mainImageView.backgroundColor = [UIColor redColor];
        [self.backView addSubview:self.mainImageView];
        
        //底部一排的背景
        self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(self.mainImageView.left, self.mainImageView.bottom, self.mainImageView.width , kHeightOfCollectButton)];
//        self.bottomView.backgroundColor = [UIColor greenColor];
        [self.backView addSubview:self.bottomView];
        
        
        //收藏Button
        self.collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.collectButton setImage:[UIImage imageNamed:@"unCollectedIcon_32"] forState:UIControlStateNormal];
        self.collectButton.frame = CGRectMake(30, 0, kHeightOfCollectButton, kHeightOfCollectButton);
        [self.bottomView addSubview:self.collectButton];
        

        
        //收藏Label
        UILabel *collectLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.collectButton.right, 0, kHeightOfCollectButton, kHeightOfCollectButton)];
        collectLabel.text = @"收藏";
        collectLabel.font = [UIFont systemFontOfSize:13];
        [self.bottomView addSubview:collectLabel];
        
        //大的空白Button
        self.collectBigButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.collectBigButton.frame = CGRectMake(self.collectButton.left, 0, kHeightOfCollectButton *2 , kHeightOfCollectButton);
        [self.bottomView addSubview:self.collectBigButton];
        
        
        //分享Button
        self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.shareButton setImage:[UIImage imageNamed:@"shareIcon_32"] forState:UIControlStateNormal];
        self.shareButton.frame = CGRectMake(self.bottomView.width - 30 - kHeightOfCollectButton * 2, 0, kHeightOfCollectButton, kHeightOfCollectButton);
        [self.bottomView addSubview:self.shareButton];
        
        //分享Label
        UILabel *shareLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bottomView.width - 30 - kHeightOfCollectButton, 0, kHeightOfCollectButton, kHeightOfCollectButton)];
        shareLabel.font = [UIFont systemFontOfSize:13];
        shareLabel.text = @"分享";
        [self.bottomView addSubview:shareLabel];
        
        //大的空白Button
        self.shareBigButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.shareBigButton.frame = CGRectMake(self.shareButton.left, 0, kHeightOfCollectButton * 2, kHeightOfCollectButton);
        [self.bottomView addSubview:self.shareBigButton];
        
       
        
        
        
        
        
        
    }
    return self;
}



@end
