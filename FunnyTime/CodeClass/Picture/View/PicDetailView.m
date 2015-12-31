//
//  PicDetailView.m
//  FunnyTime
//
//  Created by luxt on 15/10/12.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import "PicDetailView.h"

@implementation PicDetailView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.scrollView.backgroundColor = [UIColor blackColor];
        self.scrollView.maximumZoomScale = 5;
        self.scrollView.minimumZoomScale = 0.5;
        self.scrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight);
        [self addSubview:self.scrollView];
        
        self.backButton = [UIButton buttonWithType:UIButtonTypeSystem];
//        [self.backButton setTitle:@"返回" forState:UIControlStateNormal];
        [self.backButton setBackgroundImage:[[UIImage imageNamed:@"arrowdown.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        self.backButton.tintColor = [UIColor whiteColor];
        self.backButton.frame = CGRectMake(20, 5, 40, 35);
        [self.scrollView addSubview:self.backButton];
        
        self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.backButton.bottom, kScreenWidth, kScreenHeight - 40)];
//        self.imageV.backgroundColor = [UIColor orangeColor];
        [self.scrollView addSubview:self.imageV];
        
    }
    return self;
}


@end
