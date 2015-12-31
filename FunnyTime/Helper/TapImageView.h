//
//  TapImageView.h
//  WXMusic
//
//  Created by luxt on 15/8/31.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TapImageView : UIImageView

//给当前imageView添加一个taget（响应者）和一个action（点击事件）
- (instancetype)initWithFrame:(CGRect)frame taget:(id)taget action:(SEL)action;
//- (void)addTaget:(id)taget action:(SEL)action;






@end
