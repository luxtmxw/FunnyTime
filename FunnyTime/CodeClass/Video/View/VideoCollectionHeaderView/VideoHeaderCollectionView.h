//
//  VideoHeaderCollectionView.h
//  FunnyTime
//
//  Created by luxt on 15/10/4.
//  Copyright © 2015年 luxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoHeaderCollectionView : UICollectionView
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout delegate:(id)delegate dataSource:(id)dataSource;
@end
