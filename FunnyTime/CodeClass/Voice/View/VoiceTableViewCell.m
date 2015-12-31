//
//  VoiceTableViewCell.m
//  FunnyTime
//
//  Created by luxt on 15/9/25.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import "VoiceTableViewCell.h"

@implementation VoiceTableViewCell

//外界调用
- (void)setUpWithPicImage:(NSString *)picUrl albumname:(NSString *)albumName listenNum:(NSString *)listenNum
{
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"zhanweitu"]];
    self.albumNameLabel.text = albumName;
    self.listenNumLabel.text = [NSString stringWithFormat:@"%@",listenNum];
//    self.followdeNumLabel.text = [NSString stringWithFormat:@"%@",followedNum];
}

//初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addCellView];
    }
    return self;
}

//设置自定义cell
- (void)addCellView {
    self.backgroundColor = [UIColor clearColor];
    
    self.picImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
    [self.contentView addSubview:self.picImageView];
    
    self.albumNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.picImageView.bounds.size.width + 20, self.picImageView.frame.origin.y, kScreenWidth - 20 - self.picImageView.bounds.size.width - 10, 30)];
    self.albumNameLabel.font = [UIFont systemFontOfSize:20];
    [self.contentView addSubview:self.albumNameLabel];
    
    //收听小图标
    self.musicIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.picImageView.right + 20, 50, 20, 20)];
    self.musicIcon.image = [UIImage imageNamed:@"sing_img_note8@2x.png"];
    [self.contentView addSubview:self.musicIcon];

    
    self.listenNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.musicIcon.right + 10, 50, 100, 20)];
    self.listenNumLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.listenNumLabel];
    
    
    
//    self.followdeNumLabel = [[UILabel alloc ] initWithFrame:CGRectMake(self.listenNumLabel.frame.size.width + self.listenNumLabel.frame.origin.x + 10, self.listenNumLabel.frame.origin.y, 100, 20)];
//    [self.contentView addSubview:self.followdeNumLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 75, kScreenWidth - 20, 0.5)];
    lineView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:lineView];
    
}




- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}



@end
