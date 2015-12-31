//
//  TapImageView.m
//  WXMusic
//
//  Created by luxt on 15/8/31.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import "TapImageView.h"

@implementation TapImageView
- (instancetype)initWithFrame:(CGRect)frame taget:(id)taget action:(SEL)action
{
    self = [super initWithFrame:frame];
    if (self) {
        //创建一个点击事件
        //将我们初始化方法内的参数填入该手势初始化方法内（taget和action），我们将在外部调用并设置我们的点击事件
        UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc]initWithTarget:taget action:action];
        //把当前类的交互打开，否则不能响应
        self.userInteractionEnabled = YES;
        //把该手势添加至当前类
        [self addGestureRecognizer:imageTap];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
