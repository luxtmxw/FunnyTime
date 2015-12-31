//
//  PlayVideoView.h
//  FunnyTime
//
//  Created by luxt on 15/9/24.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
@interface PlayVideoView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
//播放视频的view
//@property (nonatomic, strong) UIView *videoView;
@property (nonatomic, strong) UIImageView *videoImageView;
@property (nonatomic, strong) UIButton *playerButton;

@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;
//@property (nonatomic, strong) NSString *playVideoUrl;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UIButton *collectionButton;
@property (nonatomic, strong) UIButton *playSmallButton;
@property (nonatomic, strong) UITableView *listTableView;


//- (void)setUpPlayVideoViewWithTitle:(NSString *)titleLabel timeLabel:(NSString *)timeLabel playVideoUrl:(NSString *)playVideoUrl;
//设置视频播放器
- (void)setUpPlayVideoViewWithTitle:(NSString *)titleLabel timeLabel:(NSString *)timeLabel  pic:(NSString *)pic;
- (void)setUpMoviePlayerWithUrl:(NSString *)playVideoUrl;


@end
