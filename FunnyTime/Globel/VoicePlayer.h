//
//  VoicePlayer.h
//  FunnyTime
//
//  Created by luxt on 15/9/25.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "VoicePlayListModel.h"

@class VoicePlayViewController;

@protocol VoicePlayerDelegate <NSObject>

- (void)voiceManagerSongProgress:(float)songProgress;

@end


@interface VoicePlayer : NSObject

@property (nonatomic, strong) id<VoicePlayerDelegate> delegate;

@property (nonatomic, strong) VoicePlayViewController *playViewController; //记录播放VC,仅用于跳转

//创建avplayer
@property (nonatomic, strong) AVPlayer *voiceAVPlayer;
@property (nonatomic, strong) AVPlayerItem *voiceAVPlayerItem;

@property (nonatomic, assign) BOOL readyToPlay;//准备播放
@property (nonatomic, assign) BOOL isPlaying;//是否在播放

//歌曲信息

@property (nonatomic, strong) VoicePlayListModel *voicePlayListModel;//Model对象
@property (nonatomic, strong) NSMutableArray *modelArray;   //存放Model的数组
@property (nonatomic) NSInteger currentSongIndex;   //创建一个modelArray的下标
//@property (nonatomic, strong) NSString *songID;


//创建循环模式四种状态
@property (nonatomic, assign) NSInteger playOrder;



//滑块进度
@property (nonatomic, assign) float songProgress;

//创建滑块定时器
@property (nonatomic, assign) NSTimer *timer;

+ (VoicePlayer *)shareVoicePlayer;

/**
 *  解析歌曲URL
 */
- (void)playSongWithUrl:(NSString *)url;


/**
 *  开始播放
 */
- (void)starPlayVoice;

/**
 *  停止播放
 */
- (void)stopPlayVoice;

/**
 *  下一首
 */
- (void)next;

/**
 *  上一首
 */
- (void)prev;

//换歌
- (void)changeSongWithPlayMode:(NSInteger)playMode IsNext:(BOOL)isNext IsChangeManual:(BOOL)isChangeManual;

/**
 *  到指定时间播放
 */
- (void)seekPlayerToTime:(CGFloat)time;

@end
