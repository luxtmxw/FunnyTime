//
//  PlayingImageView.m
//  KalaokeLrc
//
//  Created by luxt on 15/9/8.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import "PlayingImageView.h"

@implementation PlayingImageView

- (instancetype)initWithFrame:(CGRect)frame Target:(id)target Action:(SEL)action
{
    self = [super initWithFrame:frame taget:target action:action];
    if (self) {
//        self.tintColor = [UIColor redColor];
        
        NSMutableArray *mImageArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < 26; i++) {
            
            NSString *imageName = [NSString stringWithFormat:@"icon_upbar_icon_playing%d",i + 1];
            UIImage *image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [mImageArray addObject:image];
        }
//        self.backgroundColor = [UIColor blueColor];
        self.animationImages = mImageArray;
        self.animationDuration = 1.0;
//        [self startAnimating];
    }
    return self;
}

@end
