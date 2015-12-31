//
//  VideoPlayingTableViewCell.m
//  FunnyTime
//
//  Created by luxt on 15/10/5.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import "VideoPlayingTableViewCell.h"

@implementation VideoPlayingTableViewCell

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
        
        self.picImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 30, 30)];
        self.picImageView.layer.masksToBounds = YES;
        self.picImageView.layer.cornerRadius = self.picImageView.width / 2;
        [self.contentView addSubview:self.picImageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.picImageView.right + 5, 0, kScreenWidth - (self.picImageView.right + 40), 40)];
//        self.titleLabel.backgroundColor = [UIColor redColor];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.titleLabel];
        
    }
    return self;
}


@end
