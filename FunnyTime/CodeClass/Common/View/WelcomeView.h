//
//  WelcomeView.h
//  FunnyTime
//
//  Created by luxt on 15/10/7.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WelcomeView : UIView

//@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIButton *enterButton;


- (instancetype)initWithFrame:(CGRect)frame target:(id)target enterButtonAction:(SEL)buttonAction imageNameArray:(NSArray *)imageNameArray;

@end
