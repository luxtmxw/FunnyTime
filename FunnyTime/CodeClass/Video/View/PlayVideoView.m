//
//  PlayVideoView.m
//  FunnyTime
//
//  Created by luxt on 15/9/24.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import "PlayVideoView.h"

@implementation PlayVideoView

//- (void)dealloc {
//    self.videoView = nil;
//}

- (void)setUpPlayVideoViewWithTitle:(NSString *)titleLabel timeLabel:(NSString *)timeLabel  pic:(NSString *)pic{
    self.timeLabel.text = timeLabel;
    self.titleLabel.text = titleLabel;
    [self.videoImageView sd_setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@""]];
    //    [self setUpMoviePlayerWithUrl:playVideoUrl];
}

//设置视频播放器
- (void)setUpMoviePlayerWithUrl:(NSString *)playVideoUrl {
    //    self.moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
    //
    //    [self.moviePlayer setContentURL:[NSURL URLWithString:playVideoUrl]];
    //    [self.moviePlayer.view setFrame:self.videoView.bounds];
    ////    self.moviePlayer.fullscreen = YES;
    //    self.moviePlayer.initialPlaybackTime = 1;
    //    self.moviePlayer.repeatMode = 0;
    //    [self.moviePlayer prepareToPlay];
    ////    self.moviePlayer.controlStyle = NO;
    //    [self.moviePlayer play];
    //    [self.videoView addSubview:self.moviePlayer.view];
    
}


//初始化视图
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addView];
    }
    return self;
}
//添加视图
- (void)addView {
    
    //返回按钮
    self.backButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    self.backButton.frame = CGRectMake(5, 20, 30, 50);
    [self.backButton setImage:[UIImage imageNamed:@"btn_back_normal@2x"] forState:(UIControlStateNormal)];
    [self.backButton setTintColor:[UIColor blackColor]];
    [self addSubview:self.backButton];
    
    //标题
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 20, kScreenWidth - 60, 50)];
//    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.titleLabel.numberOfLines = 0;
    [self addSubview:self.titleLabel];
    
    //播放屏幕
    
    //    self.videoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight / 2 )];
    //
    //    [self addSubview:self.videoView];
    self.videoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 70, kScreenWidth, kScreenHeight * 0.4)];
    self.videoImageView.userInteractionEnabled = YES;
    [self addSubview:self.videoImageView];
    //播放按钮
    self.playerButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    self.playerButton.frame = CGRectMake(0, 0, self.videoImageView.width, self.videoImageView.height);
//    self.playerButton.backgroundColor = [UIColor redColor];
    [self.playerButton setTintColor:[UIColor whiteColor]];
//    [self.playerButton setImage:[UIImage imageNamed:@"hot_btnPlay_n@3x"] forState:(UIControlStateNormal)];
    [self.videoImageView addSubview:self.playerButton];
    
    
    
    
    //分享
    self.shareButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    self.shareButton.frame = CGRectMake(kScreenWidth - 20 - 30, self.videoImageView.bottom + 10, 30, 30);
    [self.shareButton setTintColor:[UIColor cyanColor]];
    [self.shareButton setImage:[UIImage imageNamed:@"shareIcon_32"] forState:(UIControlStateNormal)];
    [self addSubview:self.shareButton];
    
    //收藏
    self.collectionButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    self.collectionButton.frame = CGRectMake(10, self.shareButton.frame.origin.y, 30, 30);
    [self.collectionButton setImage:[UIImage imageNamed:@""] forState:(UIControlStateNormal)];
    [self setTintColor:[UIColor redColor]];
    [self addSubview:self.collectionButton];
    
    //播放
    self.playSmallButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    self.playSmallButton.frame = CGRectMake((kScreenWidth - 30) / 2, self.shareButton.frame.origin.y, 30, 30);
    [self.playSmallButton setImage:[UIImage imageNamed:@"hot_btnPlay_n@3x"] forState:(UIControlStateNormal)];
//    [self.playSmallButton setTitle:@"举报" forState:(UIControlStateNormal)];
//    self.playSmallButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    //    self.reportButton.titleLabel.textColor = [UIColor blueColor];
    [self.playSmallButton setTintColor:[UIColor whiteColor]];
    [self addSubview:self.playSmallButton];
//
    
    
    //白线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, self.shareButton.bottom + 10, kScreenWidth - 20, 1)];
    lineView.backgroundColor = [UIColor whiteColor];
    [self addSubview:lineView];
    
    //列表
    self.listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, lineView.frame.origin.y + 5, kScreenWidth, kScreenHeight - lineView.frame.origin.y) style:(UITableViewStylePlain)];
    self.listTableView.backgroundColor = [UIColor clearColor];
    self.listTableView.showsVerticalScrollIndicator = NO;
//    self.listTableView.backgroundColor = [UIColor greenColor];
    self.listTableView.separatorStyle = NO;
    [self addSubview:self.listTableView];
    
    
}


- (MPMoviePlayerController *)moviePlayer {
    if (!_moviePlayer) {
        _moviePlayer = [[MPMoviePlayerController alloc] init];
    }
    return _moviePlayer;
}



@end
