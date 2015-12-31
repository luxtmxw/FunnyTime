//
//  BlurImageView.m
//  LYBMusic
//
//  Created by luxt on 15/8/31.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import "BlurImageView.h"

@implementation BlurImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        //设置图片
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *imageName = [userDefaults objectForKey:@"changeBackground"];
        if (imageName == nil) {
            imageName = @"BackGroundBlurImageView000.png";
            [[NSUserDefaults standardUserDefaults] setObject:@"BackGroundBlurImageView000.png" forKey:@"changeBackground"];
        }
        
        self.image = [UIImage imageNamed:imageName];
        
        
        //创建模糊视图
        UIVisualEffectView *backVisual = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:(UIBlurEffectStyleDark)]];
        //设置模糊视图的大小和透明度
        backVisual.frame = self.frame;
        backVisual.alpha = 0.8;
//        backVisual.userInteractionEnabled = YES;
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBackground) name:@"huanfu" object:nil];
        
        [self addSubview:backVisual];
        
    }
    return self;
    
}

- (instancetype)initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        UIVisualEffectView *backVisual = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        backVisual.frame = self.frame;
        backVisual.alpha = 1.0;
        
        [self addSubview:backVisual];
        
    }
    return self;
}

- (void)refreshBackgroundBlurView
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *imageName = [userDefaults objectForKey:@"changeBackground"];
    if (imageName == nil) {
        imageName = @"BackGroundBlurImageView000.png";
    }
    
    self.image = [UIImage imageNamed:imageName];
}

@end
