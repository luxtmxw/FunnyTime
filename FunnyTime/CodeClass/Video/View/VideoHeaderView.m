//
//  VideoHeaderView.m
//  FunnyTime
//
//  Created by luxt on 15/9/24.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import "VideoHeaderView.h"

@implementation VideoHeaderView

- (instancetype)initWithFrame:(CGRect)frame imageArray:(NSMutableArray *)imageArray delegate:(id)delegate action:(SEL)action timer:(NSTimeInterval)timer selector:(SEL)selector titleArray:(NSMutableArray *)titleArray
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor orangeColor];
        NSMutableArray *insterArray = [NSMutableArray arrayWithArray:imageArray];
        NSMutableArray *inertTitle = [NSMutableArray arrayWithArray:titleArray];
        //讲imageArray最后一张图片插入到insterArray的第0位
        [insterArray insertObject:[imageArray objectAtIndex:imageArray.count - 1] atIndex:0];
        [inertTitle insertObject:[titleArray objectAtIndex:titleArray.count - 1] atIndex:0];
        //将imageArray第0张图片插入到最后
        [insterArray insertObject:[imageArray objectAtIndex:0] atIndex:insterArray.count];
        [inertTitle insertObject:[titleArray objectAtIndex:0] atIndex:inertTitle.count];
        //设置ScrollerView的contentSize
        self.contentSize = CGSizeMake(kScreenWidth * [insterArray count], 0);
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.bounces = NO;
        self.delegate = delegate;
        self.contentOffset = CGPointMake(kScreenWidth, 0);
        //循环创建ImageView
        for (int i = 0; i < insterArray.count; i ++) {
            TapImageView *touchImage = [[TapImageView alloc]initWithFrame:CGRectMake(kScreenWidth * i, 0, kScreenWidth, self.bounds.size.height) taget:delegate action:action];
            //            touchImage.image = [UIImage imageNamed:[insterArray objectAtIndex:i]];
            [touchImage sd_setImageWithURL:[NSURL URLWithString:[insterArray objectAtIndex:i]]];
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, touchImage.bounds.size.height - 30, kScreenWidth - 10, 30)];
            titleLabel.textColor = [UIColor whiteColor];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.font = [UIFont systemFontOfSize:13];
            titleLabel.text = inertTitle[i];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            [touchImage addSubview:titleLabel];
            
            [self addSubview:touchImage];
            
        }
        
        
        self.scorllTimer = [NSTimer scheduledTimerWithTimeInterval:timer target:delegate selector:selector userInfo:nil repeats:YES];
    }
    return self;
}
- (NSTimer *)scorllTimer {
    if (!_scorllTimer) {
        _scorllTimer = [[NSTimer alloc] init];
    }
    return _scorllTimer;
}



@end
