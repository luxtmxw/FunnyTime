//
//  VideoListTableViewCell.m
//  FunnyTime
//
//  Created by luxt on 15/9/24.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import "VideoListTableViewCell.h"

#define kPicImageHeight self.picImage.bounds.size.height / 2
#define kPicImageWidth self.picImage.bounds.size.width / 2

@implementation VideoListTableViewCell


//初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addCellView];
    }
    return self;
}


//设置Cell
- (void)addCellView {
    
    self.backgroundColor = [UIColor clearColor];
    //选中状态为NO
    self.selectionStyle = NO;
    //设置背景图片
    //    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, kWidth - 20, 120)];
    //    backgroundImage.image = [UIImage imageNamed:@"bg_share_large@2x"];
    //    [self.contentView addSubview:backgroundImage];
    //设置标题图片
    self.picImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, (kScreenWidth - 20) * (180 / 375.0), kScreenHeight * 0.12)];
    [self.contentView addSubview:self.picImage];
    
    UIImageView *videoIcon = [[UIImageView alloc] initWithFrame:CGRectMake(kPicImageWidth - kPicImageHeight / 2, kPicImageHeight - kPicImageHeight / 2, kPicImageHeight, kPicImageHeight)];
    videoIcon.image = [UIImage imageNamed:@"newvideo_big@2x"];
    videoIcon.userInteractionEnabled = YES;
    [self.picImage addSubview:videoIcon];
    
    
    self.picImage.layer.masksToBounds = YES;
    self.picImage.layer.borderWidth = 2;
    self.picImage.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.picImage.layer.cornerRadius = 3;
    
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.picImage.right + 20, self.picImage.top, kScreenWidth - 20 - self.picImage.bounds.size.width - 10, self.picImage.height - 20)];
    self.titleLabel.font = [UIFont systemFontOfSize:13];
//    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.numberOfLines = 0;
//    self.titleLabel.backgroundColor = [UIColor greenColor];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    
    [self.contentView addSubview:self.titleLabel];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.frame.origin.x, self.titleLabel.bottom, 100, 20)];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.timeLabel];
    
    self.likeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 20 - 70, self.timeLabel.frame.origin.y, 100, 20)];
    self.likeLabel.font = [UIFont systemFontOfSize:12];
    self.likeLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.likeLabel];
    
    
    
}

- (void)setUpVideoTableCellWithPic:(NSString *)picImage titleLabel:(NSString *)titleLabel timeLabel:(NSString *)timeLabel likeLabelL:(NSString *)likeLabel; {
    [self.picImage sd_setImageWithURL:[NSURL URLWithString:picImage]];
//    CGRect titleFrame = [titleLabel boundingRectWithSize:CGSizeMake((kScreenWidth - 20) * (180 / 375.0), 1000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName] context:nil];
//    if (titleFrame.size.height > 90) {
//        titleFrame.size.height = 80;
//    }
//    self.titleLabel.frame = CGRectMake(self.picImage.bounds.size.width + 10 + 10, 5, kScreenWidth - 20 - self.picImage.bounds.size.width - 10, titleFrame.size.height);
    
    
    
    self.titleLabel.text = titleLabel;
    self.timeLabel.text = timeLabel;
    
    //    //自适应宽度
    //    CGRect frame = [likeLabel boundingRectWithSize:CGSizeMake(1000, 20) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:11] forKey:NSFontAttributeName] context:nil];
    //    //重新给拉本地frame赋值
    //    self.likeLabel.frame = CGRectMake(kWidth - 15 - frame.size.width, self.timeLabel.frame.origin.y, frame.size.width, 20);
    //
    //    self.likeLabel.text = likeLabel;
    
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
