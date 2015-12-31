//
//  VideoCollectionViewCell.m
//  test
//
//  Created by luxt on 15/10/4.
//  Copyright © 2015年 luxt. All rights reserved.
//

#import "VideoCollectionViewCell.h"

@implementation VideoCollectionViewCell
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    }
    return _imageView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _imageView.frame.size.height - 20, _imageView.bounds.size.width - 20, 20)];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:12];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return _titleLabel;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addView];
        
    }
    return self;
}
- (void)addView {
    [self.contentView addSubview:self.imageView];
    [self.imageView addSubview:self.titleLabel];
}
- (void)setUpCollectionCellWithImage:(NSString *)imageName title:(NSString *)title {
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:[UIImage imageNamed:@"loadingPic00"]];
    self.titleLabel.text = title;
    
}
@end
