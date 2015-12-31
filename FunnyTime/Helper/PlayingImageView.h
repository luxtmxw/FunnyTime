//
//  PlayingImageView.h
//  KalaokeLrc
//
//  Created by luxt on 15/9/8.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TapImageView.h"

@interface PlayingImageView : TapImageView

- (instancetype)initWithFrame:(CGRect)frame Target:(id)target Action:(SEL)action;

@end
