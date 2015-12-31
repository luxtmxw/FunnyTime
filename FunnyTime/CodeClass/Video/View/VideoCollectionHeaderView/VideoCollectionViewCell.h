//
//  VideoCollectionViewCell.h
//  test
//
//  Created by luxt on 15/10/4.
//  Copyright © 2015年 luxt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
- (void)setUpCollectionCellWithImage:(NSString *)imageName title:(NSString *)title;

@end
