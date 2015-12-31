//
//  CollectionView.h
//  FunnyTime
//
//  Created by luxt on 15/9/25.
//  Copyright © 2015年 luxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionView : UIView
@property (nonatomic, strong) UIImageView *collectionImage;
@property (nonatomic, strong) UILabel *title;

- (void)setCollectionWithImageName:(NSString *)imageName title:(NSString *)title;
@end
