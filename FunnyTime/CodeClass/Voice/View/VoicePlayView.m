//
//  VoicePlayView.m
//  FunnyTime
//
//  Created by luxt on 15/9/25.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import "VoicePlayView.h"

#define kLengthPlayModeButtonAndDownloadButton (kScreenHeight * 0.045) //最边按钮的边长
#define kLengthPrevButtonAndNextButonn (kScreenHeight * 0.076) //第二个按钮边长
#define kLengthPlayButton (kScreenHeight * 0.1) //播放按钮边长

#define kHeightToBotton 60 //底部一排按钮中心点到屏幕底的距离

#define kHeightToBottomOfSingerButton (kScreenHeight * 0.242)

#define kLengthPicImageView (kScreenHeight * 0.40)



@implementation VoicePlayView

- (void)setUpVoiceViewWithAudioName:(NSString *)audioName albumName:(NSString *)albumName backPic:(NSString *)backPic orderNum:(NSString *)orderNum{
    NSString *title = [NSString stringWithFormat:@"第%@期:%@", orderNum, audioName];
    self.audioName.text = title;
    self.albumName.text = albumName;
    [self.backImage sd_setImageWithURL:[NSURL URLWithString:backPic]];
    [self.picImage sd_setImageWithURL:[NSURL URLWithString:backPic]];
    
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addMyView];
    }
    return self;
}

//铺控件
- (void)addMyView
{
    self.backImage = [[UIImageView alloc] initWithFrame:self.bounds];
    self.backImage.userInteractionEnabled = YES;
    [self addSubview:self.backImage];
    
    UIVisualEffectView *backVisual = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:(UIBlurEffectStyleDark)]];
    backVisual.frame = self.bounds;
    backVisual.alpha = 0.9;
    [self.backImage addSubview:backVisual];
    //返回按钮
    self.backButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.backButton.frame = CGRectMake(5, 30, 30, 40);
    [self.backButton setImage:[UIImage imageNamed:@"arrowdown"] forState:(UIControlStateNormal)];
    [self.backButton setTintColor:[UIColor whiteColor]];
    [self.backImage addSubview:self.backButton];

    //音乐名字
    self.audioName = [[UILabel alloc] initWithFrame:CGRectMake(self.backButton.right + 5, 40, kScreenWidth - 50, 20)];
    self.audioName.textColor = [UIColor whiteColor];
    self.audioName.font = [UIFont systemFontOfSize:18];
    self.audioName.textAlignment = NSTextAlignmentCenter;
    [self.backImage addSubview:self.audioName];
    //专辑名
    self.albumName = [[UILabel alloc] initWithFrame:CGRectMake(self.backButton.right + 5, 60, kScreenWidth - 50, 20)];
    self.albumName.textColor = [UIColor whiteColor];
    self.albumName.font = [UIFont systemFontOfSize:13];
    self.albumName.textAlignment = NSTextAlignmentCenter;
    [self.backImage addSubview:self.albumName];
    
    
    
    //底部控件,从下到上
    
    //0.1  0.28   0.5  0.72 0.9
    //播放模式
    self.playPageButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.playPageButton.center = CGPointMake(kScreenWidth * 0.1, kScreenHeight - kHeightToBotton);
    self.playPageButton.bounds = CGRectMake(0, 0, kLengthPlayModeButtonAndDownloadButton, kLengthPlayModeButtonAndDownloadButton);
    [self.playPageButton setImage:[UIImage imageNamed:@"bt_playpagen_control_order_normal@3x"] forState:UIControlStateNormal];
    [self.backImage addSubview:self.playPageButton];
    
    //列表
    self.listButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.listButton.center = CGPointMake(kScreenWidth * 0.9, kScreenHeight - kHeightToBotton);
    self.listButton.bounds = CGRectMake(0, 0, kLengthPlayModeButtonAndDownloadButton, kLengthPlayModeButtonAndDownloadButton);
    [self.listButton setImage:[UIImage imageNamed:@"btn_menu_normal@2x"] forState:UIControlStateNormal];
    [self.backImage addSubview:self.listButton];
    
    //上一首
    self.prevPlayerButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.prevPlayerButton.center = CGPointMake(kScreenWidth * 0.28, kScreenHeight - kHeightToBotton);
    self.prevPlayerButton.bounds = CGRectMake(0, 0, kLengthPrevButtonAndNextButonn, kLengthPrevButtonAndNextButonn);
    [self.prevPlayerButton setImage:[UIImage imageNamed:@"player_prev@2x.png"] forState:UIControlStateNormal];
    [self.backImage addSubview:self.prevPlayerButton];
    
    //下一首
    self.nextPlayButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.nextPlayButton.center = CGPointMake(kScreenWidth * 0.72, kScreenHeight - kHeightToBotton);
    self.nextPlayButton.bounds = CGRectMake(0, 0, kLengthPrevButtonAndNextButonn, kLengthPrevButtonAndNextButonn);
    [self.nextPlayButton setImage:[UIImage imageNamed:@"player_next@2x"] forState:UIControlStateNormal];
    [self.backImage addSubview:self.nextPlayButton];
    
    //播放
    self.playButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.playButton.center = CGPointMake(kScreenWidth * 0.5, kScreenHeight - kHeightToBotton);
    self.playButton.bounds = CGRectMake(0, 0, kLengthPlayButton, kLengthPlayButton);
    [self.playButton setImage:[UIImage imageNamed:@"player_pause@2x"] forState:UIControlStateNormal];
    [self.backImage addSubview:self.playButton];
    
    
    //左边时间
    self.time_begin = [[UILabel alloc] initWithFrame:CGRectMake(0, kScreenHeight - 130, 60, 20)];
    self.time_begin.textAlignment = NSTextAlignmentCenter;
    self.time_begin.textColor = [UIColor whiteColor];
//    self.time_begin.backgroundColor = [UIColor greenColor];
    self.time_begin.text = @"加载中..";
    self.time_begin.font = [UIFont systemFontOfSize:14];
    [self.backImage addSubview:self.time_begin];
    
    //进度条
    self.slider = [[UISlider alloc] initWithFrame:CGRectMake(self.time_begin.right, kScreenHeight - 130, kScreenWidth - 60 * 2, 20)];
    [self.slider setThumbImage:[UIImage imageNamed:@"movie_voucher_chooseoff@3x"] forState:(UIControlStateNormal)];
//    self.slider.backgroundColor = [UIColor greenColor];
    [self.backImage addSubview:self.slider];
    
    //右边时间
    self.time_end = [[UILabel alloc] initWithFrame:CGRectMake(self.slider.right, kScreenHeight - 130, 60, 20)];
    self.time_end.textAlignment = NSTextAlignmentCenter;
    self.time_end.font = [UIFont systemFontOfSize:14];
    self.time_end.textColor = [UIColor whiteColor];
//        self.time_end.backgroundColor = [UIColor greenColor];
    self.time_end.text = @"加载中..";
    [self.backImage addSubview:self.time_end];
    
    
    //动画图标
    self.playingView = [[PlayingImageView alloc] initWithFrame:CGRectMake(30, kScreenHeight - 160, 30, 30) Target:nil Action:nil];
//    self.playingView.backgroundColor = [UIColor greenColor];
//    [self.playingView startAnimating];
    [self.backImage addSubview:self.playingView];
    
    //收藏
    self.collectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.collectionButton.frame = CGRectMake((kScreenWidth - 30) / 2, kScreenHeight - 160, 30, 30);
    [self.collectionButton setImage:[UIImage imageNamed:@"unCollectedIcon_32.png"] forState:UIControlStateNormal];
    [self.backImage addSubview:self.collectionButton];
    
    //分享
    self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shareButton.frame = CGRectMake(kScreenWidth - 60, kScreenHeight - 160, 30, 30);
    [self.shareButton setImage:[UIImage imageNamed:@"shareIcon_32"] forState:UIControlStateNormal];
    [self.backImage addSubview:self.shareButton];
    

    //大图片
    self.picImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.albumName.bottom, kScreenWidth, self.playingView.top - self.albumName.bottom)];
    [self.backImage addSubview:self.picImage];
   
}


//添加视图
//- (void)addView {
//    
//    self.backImage = [[UIImageView alloc] initWithFrame:self.bounds];
//    self.backImage.userInteractionEnabled = YES;
//    [self addSubview:self.backImage];
//    
//    UIVisualEffectView *backVisual = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:(UIBlurEffectStyleDark)]];
//    backVisual.frame = self.bounds;
//    backVisual.alpha = 0.9;
//    [self.backImage addSubview:backVisual];
//    
//    UIButton *backButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    backButton.frame = CGRectMake(5, 15, 35, 35);
//    backButton.tag = 1000;
//    [backButton setImage:[UIImage imageNamed:@"arrowdown"] forState:(UIControlStateNormal)];
//    [backButton setTintColor:[UIColor whiteColor]];
//    [self.backImage addSubview:backButton];
//    
//    self.audioName = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, kScreenWidth - 40, 20)];
//    self.audioName.textColor = [UIColor whiteColor];
//    self.audioName.font = [UIFont systemFontOfSize:18];
//    self.audioName.textAlignment = NSTextAlignmentCenter;
//    [self.backImage addSubview:self.audioName];
//    
//    self.albumName = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, kScreenWidth - 40, 20)];
//    self.albumName.textColor = [UIColor whiteColor];
//    self.albumName.font = [UIFont systemFontOfSize:13];
//    self.albumName.textAlignment = NSTextAlignmentCenter;
//    [self.backImage addSubview:self.albumName];
//    
//    self.picImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 90, kScreenWidth, kScreenHeight / 2 )];
//    [self.backImage addSubview:self.picImage];
//    
//    UIButton *listButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    listButton.frame = CGRectMake(10, self.picImage.frame.origin.y + self.picImage.bounds.size.height + 10, 40, 40);
//    listButton.tag = 1001;
//    [listButton setImage:[UIImage imageNamed:@"btn_menu_normal@2x"] forState:(UIControlStateNormal)];
//    //    listButton.backgroundColor = [UIColor redColor];
//    [self.backImage addSubview:listButton];
//    
//    UIButton *collectionButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    collectionButton.frame = CGRectMake((kScreenWidth - 20) / 2 - 15, listButton.frame.origin.y, 40, 40);
//    collectionButton.tag = 1002;
//    [collectionButton setImage:[UIImage imageNamed:@"ppq_like@3x"] forState:(UIControlStateNormal)];
//    //    collectionButton.backgroundColor = [UIColor blueColor];
//    [self.backImage addSubview:collectionButton];
//    //
//    UIButton *shareButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    shareButton.frame = CGRectMake((kScreenWidth - 20) - 40, listButton.frame.origin.y, 50, 40);
//    shareButton.tag = 1003;
//    [shareButton setImage:[UIImage imageNamed:@"pla_share_n@3x"] forState:(UIControlStateNormal)];
//    //    shareButton.backgroundColor = [UIColor blueColor];
//    [self.backImage addSubview:shareButton];
//    
//    
//    
//    //左边时间
//    self.time_begin = [[UILabel alloc] initWithFrame:CGRectMake(2, self.slider.frame.origin.y, 60, 20)];
//    self.time_begin.textColor = [UIColor whiteColor];
//    //    self.time_begin.backgroundColor = [UIColor blueColor];
//    self.time_begin.text = @"00:00";
//    self.time_begin.font = [UIFont systemFontOfSize:14];
//    [self.backImage addSubview:self.time_begin];
//    
//    //进度条
//    self.slider = [[UISlider alloc] initWithFrame:CGRectMake(self.time_begin.right, shareButton.frame.origin.y + 30, kScreenWidth - 4 - 60 * 2, 30)];
//    [self.slider setThumbImage:[UIImage imageNamed:@"movie_voucher_chooseoff@3x"] forState:(UIControlStateNormal)];
//    [self.backImage addSubview:self.slider];
//    
//    //右边时间
//    self.time_end = [[UILabel alloc] initWithFrame:CGRectMake(1, self.slider.frame.origin.y + 20, 60, 20)];
//    self.time_end.font = [UIFont systemFontOfSize:14];
//    self.time_end.textColor = [UIColor whiteColor];
//    //    self.time_end.backgroundColor = [UIColor blueColor];
//    self.time_end.textAlignment = NSTextAlignmentRight;
//    self.time_end.text = @"00:00";
//    [self.backImage addSubview:self.time_end];
//    
//    //播放模式
//    self.playPageButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    [self setUpAllButton:self.playPageButton frame:CGRectMake(10, (kScreenHeight - self.time_begin.frame.origin.y) / 2 + self.time_begin.frame.origin.y - 20, 40, 40) imageName:@"bt_playpagen_control_order_normal@3x"];
//    
//    //上一首
//    self.prevPlayerButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    [self setUpAllButton:self.prevPlayerButton frame:CGRectMake((kScreenWidth - 20) / 2 - (kScreenWidth - 20) / 4 - 10, (kScreenHeight - self.time_begin.frame.origin.y) / 2 + self.time_begin.frame.origin.y - 20, 40, 40) imageName:@"player_prev@2x"];
//    
//    //播放
//    self.playButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    [self setUpAllButton:self.playButton frame:CGRectMake((kScreenWidth - 20) / 2 - 22, (kScreenHeight - self.time_begin.frame.origin.y) / 2 + self.time_begin.frame.origin.y - 20  - 10, 60, 60) imageName:@"player_pause@2x"];
//    //下一首
//    self.nextPlayButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    [self setUpAllButton:self.nextPlayButton frame:CGRectMake((kScreenWidth - 20) / 2 + (kScreenWidth - 20) / 4 - 18, (kScreenHeight - self.time_begin.frame.origin.y) / 2 + self.time_begin.frame.origin.y - 20, 40, 40) imageName:@"player_next@2x"];
//    //下载
//    self.playDownloadButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    [self setUpAllButton:self.playDownloadButton frame:CGRectMake(kScreenWidth - 20 - 30, (kScreenHeight - self.time_begin.frame.origin.y) / 2 + self.time_begin.frame.origin.y - 20, 40, 40) imageName:@"player_download@2x"];
//    
//    
//}
//
//- (void)setUpAllButton:(UIButton *)button frame:(CGRect)frame imageName:(NSString *)imageName {
//    button.frame = frame;
//    [button setImage:[UIImage imageNamed:imageName] forState:(UIControlStateNormal)];
//    [self.backImage addSubview:button];
//    
//}

@end
