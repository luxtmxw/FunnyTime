//
//  CollectionHeaderView.m
//  FunnyTime
//
//  Created by luxt on 15/10/4.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import "CollectionHeaderView.h"

@implementation CollectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 200) / 2, 20, 200, 40)];
        self.titleLabel.font = [UIFont systemFontOfSize:24];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.text = @"收藏列表";
        [self addSubview:self.titleLabel];
        
        self.backButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.backButton setImage:[UIImage imageNamed:@"arrowdown.png"] forState:UIControlStateNormal];
        self.backButton.frame = CGRectMake(15, 30, 30, 30);
        [self addSubview:self.backButton];
        
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 63, kScreenWidth - 15, 1)];
        self.lineView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.690];
        [self addSubview:self.lineView];
        
    }
    return self;
}

@end
