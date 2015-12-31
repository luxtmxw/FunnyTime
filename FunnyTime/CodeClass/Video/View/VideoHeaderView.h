//
//  VideoHeaderView.h
//  FunnyTime
//
//  Created by luxt on 15/9/24.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoHeaderView : UIScrollView

@property (nonatomic, strong) NSTimer *scorllTimer;

- (instancetype)initWithFrame:(CGRect)frame imageArray:(NSMutableArray *)imageArray delegate:(id)delegate action:(SEL)action timer:(NSTimeInterval)timer selector:(SEL)selector titleArray:(NSMutableArray *)titleArray;

@end
