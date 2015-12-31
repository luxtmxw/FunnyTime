//
//  VoicePlayer.m
//  FunnyTime
//
//  Created by luxt on 15/9/25.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import "VoicePlayer.h"


@implementation VoicePlayer

static VoicePlayer *voicePlayer;

+ (VoicePlayer *)shareVoicePlayer {
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        voicePlayer = [[VoicePlayer alloc] init];
    });
    return voicePlayer;
}

//avplayer懒加载
- (AVPlayer *)voiceAVPlayer {
    if (!_voiceAVPlayer) {
        _voiceAVPlayer = [[AVPlayer alloc] init];
    }
    return _voiceAVPlayer;
}

//解析歌曲url
- (void)playSongWithUrl:(NSString *)url {
    if (self.voiceAVPlayerItem) {
        //移除观察者
        [self.voiceAVPlayerItem removeObserver:self forKeyPath:@"status" context:nil];
    }
    
    self.voiceAVPlayerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:url]];
    
    [self.voiceAVPlayerItem addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew) context:nil];
    //将item中的所有资源替换成最新的
    [self.voiceAVPlayer replaceCurrentItemWithPlayerItem:self.voiceAVPlayerItem];
    
}

//实行观察者方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    switch ([change[@"new"] integerValue]) {
        case AVPlayerItemStatusFailed:
            NSLog(@"缓冲失败");
            break;
        case AVPlayerItemStatusReadyToPlay:
        {
            self.readyToPlay = YES;
            NSLog(@"缓冲成功");
            //发送通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"readyToPlay" object:nil];
            //缓冲成功,直接播放
            [self starPlayVoice];
            
            //锁屏信息
            [self setUpLockScreenNowPlayingInfo];
        }
            break;
        case AVPlayerItemStatusUnknown:
            NSLog(@"缓冲未知");
            break;
        default:
            break;
    }
}

//开始播放
- (void)starPlayVoice
{
    if (self.readyToPlay) {
        [self.voiceAVPlayer play];
        self.isPlaying = YES;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(runTimerAction) userInfo:nil repeats:YES];
    }
}

//计时器调用方法
- (void)runTimerAction
{
    if (self.isPlaying) {
        
        self.songProgress = self.voiceAVPlayer.currentTime.value / self.voiceAVPlayer.currentTime.timescale;
        [self.delegate voiceManagerSongProgress:self.songProgress];
        
        
        //锁屏信息
        [self setUpLockScreenNowPlayingInfo];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo];
        ;
        [dic setObject:[NSNumber numberWithFloat:self.songProgress] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
        [dic setObject:[NSNumber numberWithFloat:CMTimeGetSeconds(self.voiceAVPlayer.currentItem.duration)] forKey:MPMediaItemPropertyPlaybackDuration];
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dic];
    }
}

//停止播放
- (void)stopPlayVoice
{
    [self.voiceAVPlayer pause];
    self.isPlaying = NO;
    //停止定时器
    if (self.timer.valid) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
}

//到指定时间播放
- (void)seekPlayerToTime:(CGFloat)time
{
    if (self.isPlaying) {
        [self stopPlayVoice];
        [self.voiceAVPlayer seekToTime:CMTimeMakeWithSeconds(time, self.voiceAVPlayer.currentTime.timescale) completionHandler:^(BOOL finished) {
            [self starPlayVoice];
        }];
    }else{
        [self.voiceAVPlayer seekToTime:CMTimeMakeWithSeconds(time, self.voiceAVPlayer.currentTime.timescale) completionHandler:nil];
    }
}

//下一首
- (void)next
{
    [self changeSongWithPlayMode:self.playOrder IsNext:YES IsChangeManual:YES];
}

//上一首
- (void)prev
{
    [self changeSongWithPlayMode:self.playOrder IsNext:NO IsChangeManual:YES];
}

//换歌
- (void)changeSongWithPlayMode:(NSInteger)playMode IsNext:(BOOL)isNext IsChangeManual:(BOOL)isChangeManual
{
    [self stopPlayVoice];
    switch (playMode) {
        case 0: //顺序播放,若认为操控,为列表循环,若自动换歌,到最后一首就停
        {
            if (isChangeManual) {
                //判断是上一首还是下一首 换歌曲
                [self changeIndexOfSongWithIsNext:isNext];
            }else{
                self.currentSongIndex ++;
                if (self.currentSongIndex == self.modelArray.count - 1) {
                    [self stopPlayVoice];
                }else{
                    [self changeIndexOfSongWithIsNext:isNext];
                }
            }
  
        }break;
            
        case 1: //随机播放
        {
            self.currentSongIndex = arc4random() % (self.modelArray.count);
            self.voicePlayListModel = self.modelArray[self.currentSongIndex];
            [self playSongWithUrl:self.voicePlayListModel.mp3PlayUrl];
            
        }break;
            
        case 2: //列表循环
        {
            [self changeIndexOfSongWithIsNext:isNext];
            
        }break;
            
        case 3: //单曲循环
        {
            //人为换歌,直接换下一首  若自动换歌 歌曲信息不变
            if (isChangeManual) {
                
                [self changeIndexOfSongWithIsNext:isNext];
            }else{
                [self playSongWithUrl:self.voicePlayListModel.mp3PlayUrl];
            }
            
        }break;
            
        default:
            break;
    }
}

//判断是上一首还是下一首 换歌曲坐标 , 开始根据新的url播放
- (void)changeIndexOfSongWithIsNext:(BOOL)isNext
{
    //改变索引
    if (isNext) {
        self.currentSongIndex ++;
        if (self.currentSongIndex > self.modelArray.count - 1) {
            self.currentSongIndex = 0;
        }
    }else{
        self.currentSongIndex --;
        if (0 > self.currentSongIndex) {
            self.currentSongIndex = self.modelArray.count - 1;
        }
    }
    
    //改变歌曲信息
    self.voicePlayListModel = self.modelArray[self.currentSongIndex];
    
    //播放
    [self playSongWithUrl:self.voicePlayListModel.mp3PlayUrl];
    
    
}

//锁屏信息
- (void)setUpLockScreenNowPlayingInfo
{
    //MPNowPlayingInfoCenter
    if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
        
        NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
        
        [dic setObject:self.voicePlayListModel.audioName forKey:MPMediaItemPropertyTitle];
        [dic setObject:self.voicePlayListModel.audioName forKey:MPMediaItemPropertyArtist];
        
        [dic setObject:[NSNumber numberWithFloat:self.songProgress] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
        [dic setObject:[NSNumber numberWithFloat:CMTimeGetSeconds(self.voiceAVPlayer.currentItem.duration)] forKey:MPMediaItemPropertyPlaybackDuration];
        
        if (![self.voicePlayListModel.albumPic isEqualToString:@""]) {
            UIImageView *imageView = [[UIImageView alloc] init];
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:self.voicePlayListModel.albumPic] placeholderImage:[UIImage imageNamed:@"loadingPic00"]];
            MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:imageView.image];
            [dic setObject:artwork forKey:MPMediaItemPropertyArtwork];
            
        }
        
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dic];
        
    }
}

@end
