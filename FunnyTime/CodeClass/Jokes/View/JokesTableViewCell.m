//
//  JokesTableViewCell.m
//  FunnyTime
//
//  Created by luxt on 15/9/23.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import "JokesTableViewCell.h"

@implementation JokesTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setView];
    }
    return self;
}


- (void)setView{
    
    
    self.background = [[UIView alloc] initWithFrame:CGRectMake(kDistanceOfEdge, 7, kScreenWidth - 2 * kDistanceOfEdge, 50)];
    self.background.layer.cornerRadius = 10;
    self.background.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.800];
    [self.contentView addSubview:self.background];
    
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(16 * kDistanceOfEdge, 0, 83, 15)];
    self.timeLabel.font = [UIFont systemFontOfSize:11];
    self.timeLabel.textColor = [UIColor grayColor];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    //self.timeLabel.backgroundColor = [UIColor greenColor];
    [self.background addSubview:self.timeLabel];
    
    
    self.contentLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(0.7 * kDistanceOfEdge, self.timeLabel.bottom, kScreenWidth - 3.4 * kDistanceOfEdge, 0)];
    //self.contentLabel.backgroundColor = [UIColor redColor];
    self.contentLabel.numberOfLines = 0;
//    self.contentLabel.firstLineIndent = 30;
    //self.contentLabel.lineSpacing = 10;
    //在此处必须设置字体与自适应高度字体的大小相同
    self.contentLabel.font = [UIFont systemFontOfSize:16];
    [self.background addSubview:self.contentLabel];
    
    
    self.collectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.collectionButton.frame = CGRectMake(2 * kDistanceOfEdge, self.contentLabel.bottom, 30, 30);
    [self.collectionButton setImage:[UIImage imageNamed:@"unCollectedIcon_32"] forState:UIControlStateNormal];
    [self.background addSubview:self.collectionButton];
    
    //
    self.collectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(4 * kDistanceOfEdge + 5, self.contentLabel.bottom, 60, 30)];
    //self.collectionLabel.backgroundColor = [UIColor greenColor];
    self.collectionLabel.text = @"收藏";
    self.collectionButton.tag = 1000;
    self.collectionLabel.font = [UIFont systemFontOfSize:13];
    [self.background addSubview:self.collectionLabel];
    
    //
    self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shareButton.frame = CGRectMake(16 * kDistanceOfEdge, self.contentLabel.bottom, 30, 30);
    [self.shareButton setImage:[UIImage imageNamed:@"shareIcon_32"] forState:UIControlStateNormal];
    [self.background addSubview:self.shareButton];
    
    
    
    self.shareLabel = [[UILabel alloc] initWithFrame:CGRectMake(18 * kDistanceOfEdge + 5, self.contentLabel.bottom , 60, 30)];
    //self.shareLabel.backgroundColor = [UIColor greenColor];
    self.shareLabel.text = @"分享";
    self.shareLabel.font = [UIFont systemFontOfSize:13];
    [self.background addSubview:self.shareLabel];
    
    //大的空白Button
    self.collectionBigButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.collectionBigButton.frame = CGRectMake(self.collectionButton.left, self.collectionButton.top, self.collectionButton.width + self.collectionLabel.width, self.collectionButton.height);
    [self.background addSubview:self.collectionBigButton];
    
    self.shareBigButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.shareBigButton.frame = CGRectMake(self.shareButton.left, self.shareButton.top, self.shareButton.width + self.shareLabel.width, self.shareButton.height);
    [self.background addSubview:self.shareBigButton];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
