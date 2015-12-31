//
//  CollectionView.m
//  FunnyTime
//
//  Created by luxt on 15/9/25.
//  Copyright © 2015年 luxt. All rights reserved.
//

#import "CollectionView.h"

@implementation CollectionView

- (void)setCollectionWithImageName:(NSString *)imageName title:(NSString *)title {
    self.collectionImage.image = [UIImage imageNamed:imageName];
    self.title.text = title;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addView];
    }
    return self;
}

- (void)addView {
    UIVisualEffectView *backgroudVisual = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    backgroudVisual.frame = [UIScreen mainScreen].bounds;
    backgroudVisual.alpha = 0.0;
    [self addSubview:backgroudVisual];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(self.center.x - 60, self.center.y - 55, 120, 120)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 10;
    [self addSubview:backView];
    
    self.collectionImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.center.x - 45, self.center.y - 45, 90, 90)];
    [self addSubview:self.collectionImage];

    self.title = [[UILabel alloc] initWithFrame:CGRectMake(self.center.x - 45, self.collectionImage.frame.origin.y + 70, self.collectionImage.frame.size.width, 20)];
    self.title.textAlignment = NSTextAlignmentCenter;
    self.title.textColor = [UIColor brownColor];
    self.title.font = [UIFont boldSystemFontOfSize:18];
    [self addSubview:self.title];
    
    
}








@end
