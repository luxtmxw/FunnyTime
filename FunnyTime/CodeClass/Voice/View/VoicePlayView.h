//
//  VoicePlayView.h
//  FunnyTime
//
//  Created by luxt on 15/9/25.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayingImageView.h"

@interface VoicePlayView : UIView

@property (nonatomic, strong) UIImageView *picImage;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UILabel *time_begin;
@property (nonatomic, strong) UILabel *time_end;
@property (nonatomic, strong) UILabel *audioName;
@property (nonatomic, strong) UILabel *albumName;
@property (nonatomic, strong) UIImageView *backImage;

@property (nonatomic, strong) UIButton *playPageButton;
@property (nonatomic, strong) UIButton *prevPlayerButton;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *nextPlayButton;
@property (nonatomic, strong) UIButton *playDownloadButton;

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *listButton;

@property (nonatomic, strong) UIButton *collectionButton;
@property (nonatomic, strong) UIButton *shareButton;

@property (nonatomic, strong) PlayingImageView *playingView;

- (void)setUpVoiceViewWithAudioName:(NSString *)audioName albumName:(NSString *)albumName backPic:(NSString *)backPic orderNum:(NSString *)orderNum;

@end
