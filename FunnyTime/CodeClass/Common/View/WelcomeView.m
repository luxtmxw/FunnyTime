//
//  WelcomeView.m
//  FunnyTime
//
//  Created by luxt on 15/10/7.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import "WelcomeView.h"

@implementation WelcomeView

- (instancetype)initWithFrame:(CGRect)frame target:(id)target enterButtonAction:(SEL)buttonAction imageNameArray:(NSArray *)imageNameArray
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addViewWithImageNameArray:imageNameArray target:target buttonAction:buttonAction];
    }
    return self;
}

- (void)addViewWithImageNameArray:(NSArray *)imageNameArray target:(id)target buttonAction:(SEL)buttonAction {
    self.scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    self.scrollView.contentSize = CGSizeMake(kScreenWidth * imageNameArray.count, kScreenHeight);
    [self addSubview:self.scrollView];
    
    for (int i = 0; i < imageNameArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth * i, 0, kScreenWidth, kScreenHeight)];
        imageView.image = [UIImage imageNamed:imageNameArray[i]];
        
        [self.scrollView addSubview:imageView];
        
    }
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, kScreenHeight - 40, kScreenWidth, 30)];
    self.pageControl.numberOfPages = imageNameArray.count;
    self.pageControl.pageIndicatorTintColor = [UIColor yellowColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
//    [self.pageControl addTarget:target action:action forControlEvents:(UIControlEventValueChanged)];
    [self addSubview:self.pageControl];
    
    
    self.enterButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.enterButton.frame = CGRectMake(kScreenWidth * (imageNameArray.count - 1) + ((kScreenWidth - 200) / 2), kScreenHeight - 150, 200, 80);
    [self.enterButton setTitle:@"立即体验" forState:(UIControlStateNormal)];
    [self.enterButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [self.enterButton addTarget:target action:buttonAction forControlEvents:(UIControlEventTouchUpInside)];
    self.enterButton.layer.cornerRadius = 10;
    self.enterButton.layer.masksToBounds = YES;
    self.enterButton.layer.borderWidth = 0.7;
    self.enterButton.layer.borderColor = [[UIColor blackColor] CGColor];
    [self.scrollView addSubview:self.enterButton];
    
}

@end
