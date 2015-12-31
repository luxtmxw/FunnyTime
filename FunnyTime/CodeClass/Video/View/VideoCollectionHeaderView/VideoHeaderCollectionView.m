//
//  VideoHeaderCollectionView.m
//  FunnyTime
//
//  Created by luxt on 15/10/4.
//  Copyright © 2015年 luxt. All rights reserved.
//

#import "VideoHeaderCollectionView.h"

@implementation VideoHeaderCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout delegate:(id)delegate dataSource:(id)dataSource {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.showsHorizontalScrollIndicator = NO;
//        self.pagingEnabled = YES;
        self.delegate = delegate;
        self.dataSource = dataSource;
        
    }
    return self;
}

@end
