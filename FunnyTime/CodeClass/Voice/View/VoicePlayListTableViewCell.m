//
//  VoicePlayListTableViewCell.m
//  FunnyTime
//
//  Created by luxt on 15/9/25.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import "VoicePlayListTableViewCell.h"

@implementation VoicePlayListTableViewCell

//初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self addCellView];
    }
    return self;
}

//设置cell
- (void)addCellView {
    
    //从上到下
    
    //更新时间
    self.updateTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 180 - 15, 0, 180, 13)];
    self.updateTimeLabel.textColor = [UIColor grayColor];
    self.updateTimeLabel.textAlignment = NSTextAlignmentRight;
    self.updateTimeLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.updateTimeLabel];
    
    //标题
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, self.updateTimeLabel.bottom, kScreenWidth - 15 * 2, 30)];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.contentView addSubview:self.titleLabel];
    
    //介绍
    self.descLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(15, self.titleLabel.bottom, kScreenWidth - 15 * 2, 30)];
    self.descLabel.textColor = [UIColor blackColor];
    self.descLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
    self.descLabel.font = [UIFont systemFontOfSize:12];
    self.descLabel.numberOfLines = 0;
    [self.contentView addSubview:self.descLabel];
    
    //收听小图标
    self.musicIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15, self.descLabel.bottom, 20, 20)];
    self.musicIcon.image = [UIImage imageNamed:@"sing_img_note8@2x.png"];
    [self.contentView addSubview:self.musicIcon];
    
    //收听人数
    self.listenNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.musicIcon.right + 10, self.descLabel.bottom, 60, 20)];
    self.listenNumLabel.textColor = [UIColor grayColor];
    self.listenNumLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.listenNumLabel];
    
    //白线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, self.listenNumLabel.bottom, kScreenWidth - 30, 0.5)];
    lineView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:lineView];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
