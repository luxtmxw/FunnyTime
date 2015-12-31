//
//  VoicePlayListTableViewCell.h
//  FunnyTime
//
//  Created by luxt on 15/9/25.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"
@interface VoicePlayListTableViewCell : UITableViewCell

//@property (nonatomic, strong) UILabel *audioNameLabel;
@property (nonatomic, strong) UILabel *updateTimeLabel;//更新时间
@property (nonatomic, strong) UILabel *titleLabel;  //标题
@property (nonatomic, strong)  TTTAttributedLabel *descLabel;   //简介
@property (nonatomic, strong) UIImageView *musicIcon;   //图标
@property (nonatomic, strong) UILabel *listenNumLabel;  //收听人数
////赋值
//- (void)setUpCellViewWithAudioName:(NSString *)audioName listenNum:(NSString *)listenNum likeNum:(NSString *)likeNum updateTime:(NSString *)updateTime orderNum:(NSString *)orderNum;

@end
