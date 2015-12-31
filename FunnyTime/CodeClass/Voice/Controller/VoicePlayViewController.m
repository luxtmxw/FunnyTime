//
//  VoicePlayViewController.m
//  FunnyTime
//
//  Created by luxt on 15/9/25.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import "VoicePlayViewController.h"
#import "VoicePlayView.h"
#import "VoicePlayListModel.h"
#import "VoiceListTableViewCell.h"
@interface VoicePlayViewController ()<VoicePlayerDelegate,UITableViewDataSource,UITableViewDelegate,UMSocialUIDelegate>

@property (nonatomic, strong) VoicePlayView *playView;  //播放主页面
@property (nonatomic, strong) UITableView *tableView;   //播放列表
@property (nonatomic) BOOL isShowingList;   //是否正在显示播放列表

@end

@implementation VoicePlayViewController

- (NSUInteger)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
}
- (BOOL)shouldAutorotate {
    return NO;
}

#pragma mark - 实现单例代理方法

- (void)voiceManagerSongProgress:(float)songProgress
{
    //进度条变化
    self.playView.slider.value = songProgress;
    //左边时间
    self.playView.time_begin.text = [self transformToStringWithFloat:songProgress];
    //右边剩余时间
    self.playView.time_end.text = [self transformToStringWithFloat:(self.playView.slider.maximumValue - songProgress)];
}

- (NSString *)transformToStringWithFloat:(float)value
{
    return [NSString stringWithFormat:@"%0.2d:%0.2d",(int)(value / 60),((int)value % 60)];
}


#pragma mark - 加载初始页面

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置音频会话支持后台播放
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    //虽然代理和播放VC在本工程中是一样的,还是分开写比较好
    [VoicePlayer shareVoicePlayer].delegate = self;
    [VoicePlayer shareVoicePlayer].playViewController = self;
    
    //页面一出现就放歌
    [[VoicePlayer shareVoicePlayer] playSongWithUrl:[VoicePlayer shareVoicePlayer].voicePlayListModel.mp3PlayUrl];
    
    self.playView = [[VoicePlayView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    //页面布置
    [self setupViewWithPlayListModelInHandle];

    //设置按钮
    [self setUpAllButton];
    
    [self.view addSubview:self.playView];
    
    //接收缓冲成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(play) name:@"readyToPlay" object:nil];
    //接收歌曲结束通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(songEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    //添加一个播放列表
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth, self.playView.albumName.bottom, kScreenWidth * 0.5, self.playView.playingView.top - self.playView.albumName.bottom) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithRed:0.000 green:0.502 blue:0.502 alpha:1.000];
    [self.view addSubview:self.tableView];
    
    //添加手势
    self.playView.picImage.userInteractionEnabled = YES;
    //左扫
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeAction:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.playView.picImage addGestureRecognizer:leftSwipe];
    //右扫
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeAction:)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.playView.picImage addGestureRecognizer:rightSwipe];
    
}

//设置按钮
- (void)setUpAllButton {
    //循环按钮
    [self.playView.playPageButton addTarget:self action:@selector(playPageButton) forControlEvents:(UIControlEventTouchUpInside)];
    //下一首
    [self.playView.nextPlayButton addTarget:self action:@selector(nextVoice) forControlEvents:(UIControlEventTouchUpInside)];
    //播放暂停键
    [self.playView.playButton addTarget:self action:@selector(playSongButton) forControlEvents:(UIControlEventTouchUpInside)];
    //上一首
    [self.playView.prevPlayerButton addTarget:self action:@selector(preVoice) forControlEvents:(UIControlEventTouchUpInside)];
    //滑块
    [self.playView.slider addTarget:self action:@selector(sliderRun:) forControlEvents:(UIControlEventValueChanged)];
    //页面消失
    [self.playView.backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //列表
    [self.playView.listButton addTarget:self action:@selector(showPlayList:) forControlEvents:UIControlEventTouchUpInside];
    
    //收藏
    [self.playView.collectionButton addTarget:self action:@selector(collectionVoice:) forControlEvents:UIControlEventTouchUpInside];
    
    //分享
    [self.playView.shareButton addTarget:self action:@selector(shareVoice:) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - 根据单例中的model布置页面

- (void)setupViewWithPlayListModelInHandle
{
    [self.playView setUpVoiceViewWithAudioName:[VoicePlayer shareVoicePlayer].voicePlayListModel.audioName
                                     albumName:[VoicePlayer shareVoicePlayer].voicePlayListModel.albumName
                                       backPic:[VoicePlayer shareVoicePlayer].voicePlayListModel.albumPic
                                      orderNum:[VoicePlayer shareVoicePlayer].voicePlayListModel.orderNum];
    
    if ([[FunnyTimeDataBase shareFunnyTimeDataBase] isExistVoiceModel:[VoicePlayer shareVoicePlayer].voicePlayListModel]){
        [self.playView.collectionButton setImage:[UIImage imageNamed:@"isCollectedIcon_32.png"] forState:UIControlStateNormal];
    }else{
        [self.playView.collectionButton setImage:[UIImage imageNamed:@"unCollectedIcon_32.png"] forState:UIControlStateNormal];
    }
    
}

#pragma mark - 开始播放,接收缓冲成功通知执行的方法

- (void)play
{
    self.playView.slider.maximumValue = [VoicePlayer shareVoicePlayer].voiceAVPlayerItem.duration.value / [VoicePlayer shareVoicePlayer].voiceAVPlayerItem.duration.timescale;
    [self.playView.playingView startAnimating];
    [self setupViewWithPlayListModelInHandle];
    [[VoicePlayer shareVoicePlayer] starPlayVoice];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:[VoicePlayer shareVoicePlayer].currentSongIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    [self.tableView reloadData];
    
    
}


#pragma mark - 点击播放模式

- (void)playPageButton {
    [VoicePlayer shareVoicePlayer].playOrder += 1;
    if ([VoicePlayer shareVoicePlayer].playOrder == 4) {
        [VoicePlayer shareVoicePlayer].playOrder = 0;
    }
    [self playPageButtonStatus];
}

//设置循环模式button的状态
- (void)playPageButtonStatus {
    switch ([VoicePlayer shareVoicePlayer].playOrder) {
        case 0:
            [self.playView.playPageButton setImage:[UIImage imageNamed:@"bt_playpagen_control_order_normal@3x"] forState:(UIControlStateNormal)];
            break;
        case 1:
            [self.playView.playPageButton setImage:[UIImage imageNamed:@"bt_playpagen_control_round-all_normal@3x"] forState:(UIControlStateNormal)];
            break;
        case 2:
            [self.playView.playPageButton setImage:[UIImage imageNamed:@"bt_playpagen_control_random_normal@3x"] forState:(UIControlStateNormal)];
            break;
        case 3:
            [self.playView.playPageButton setImage:[UIImage imageNamed:@"bt_playpagen_control_round-one_normal@3x"] forState:(UIControlStateNormal)];
            break;
        default:
            break;
    }
}


#pragma mark - 点击退出页面

- (void)backButtonAction:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


//都是单例的方法,或许可以优化

#pragma mark - 点下一首

- (void)nextVoice
{
    [[VoicePlayer shareVoicePlayer] next];
}


#pragma mark - 点上一首

- (void)preVoice
{
    [[VoicePlayer shareVoicePlayer] prev];
    
}


#pragma mark - 拖动滑块

- (void)sliderRun:(UISlider *)slider
{
    [[VoicePlayer shareVoicePlayer] seekPlayerToTime:slider.value];
}


#pragma mark - 点播放暂停键

- (void)playSongButton
{
    if ([VoicePlayer shareVoicePlayer].isPlaying) {
        [[VoicePlayer shareVoicePlayer] stopPlayVoice];
        [self.playView.playingView stopAnimating];
        [self.playView.playButton setImage:[UIImage imageNamed:@"player_play@2x"] forState:UIControlStateNormal];
        self.playView.playingView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_upbar_icon_playing%d",(int)(arc4random() % 26 + 1)]];
    }else{
        [[VoicePlayer shareVoicePlayer] starPlayVoice];
        [self.playView.playingView startAnimating];
        [self.playView.playButton setImage:[UIImage imageNamed:@"player_pause@2x"] forState:UIControlStateNormal];
    }
    
}


#pragma mark - 歌曲播完执行的方法,自动换歌

- (void)songEnd
{
//    NSLog(@"自动换歌");
    [[VoicePlayer shareVoicePlayer] changeSongWithPlayMode:[VoicePlayer shareVoicePlayer].playOrder IsNext:YES IsChangeManual:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


#pragma mark - 播放列表点击事件

- (void)showPlayList:(UIButton *)button
{
    if (self.isShowingList) {
        [UIView animateWithDuration:0.5 animations:^{
            self.tableView.left = self.tableView.left + kScreenWidth * 0.5;
            
        } completion:^(BOOL finished) {
            self.isShowingList = NO;
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self.tableView.left = self.tableView.left - kScreenWidth * 0.5;
            
        } completion:^(BOOL finished) {
            self.isShowingList = YES;
        }];
    }
}


#pragma mark - 手势动作

- (void)leftSwipeAction:(UISwipeGestureRecognizer *)leftSwipe
{
    if (!self.isShowingList) {
        [self showPlayList:nil];
    }
    
}
- (void)rightSwipeAction:(UISwipeGestureRecognizer *)rightSwipe
{
    if (self.isShowingList) {
        [self showPlayList:nil];
    }
}


#pragma mark - 点击收藏

- (void)collectionVoice:(UIButton *)button
{
    CollectionView *collectiongAlert = [[CollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    if ([[FunnyTimeDataBase shareFunnyTimeDataBase] isExistVoiceModel:[VoicePlayer shareVoicePlayer].voicePlayListModel]) {
        [[FunnyTimeDataBase shareFunnyTimeDataBase] deleteVoiceModel:[VoicePlayer shareVoicePlayer].voicePlayListModel];
        [self.playView.collectionButton setImage:[UIImage imageNamed:@"unCollectedIcon_32.png"] forState:UIControlStateNormal];
        
        [collectiongAlert setCollectionWithImageName:@"ppq_like@3x.png" title:@"取消收藏"];
        [self.view addSubview:collectiongAlert];

    }else{
        [[FunnyTimeDataBase shareFunnyTimeDataBase] insertVoiceCollectionWithJokeModel:[VoicePlayer shareVoicePlayer].voicePlayListModel];
        [self.playView.collectionButton setImage:[UIImage imageNamed:@"isCollectedIcon_32.png"] forState:UIControlStateNormal];
        [collectiongAlert setCollectionWithImageName:@"ppq_like_f@3x.png" title:@"收藏成功"];
        [self.view addSubview:collectiongAlert];
    }
    
    [self performSelector:@selector(dismissCollectionAlert:) withObject:collectiongAlert afterDelay:0.5];
}

- (void)dismissCollectionAlert:(CollectionView *)collectionView
{
    [collectionView removeFromSuperview];
}


#pragma mark - 点击分享

- (void)shareVoice:(UIButton *)button
{
    VoicePlayListModel *model = [VoicePlayer shareVoicePlayer].voicePlayListModel;
    [UMSocialSnsService presentSnsController:self appKey:kUMAppkey shareText:[NSString stringWithFormat:@"%@: %@  %@",model.albumName,model.audioName,model.mp3PlayUrl] shareImage:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.albumPic]] shareToSnsNames:kShareToSnsNames delegate:self];
    
    
}
-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData {
    VoicePlayListModel *model = [VoicePlayer shareVoicePlayer].voicePlayListModel;
    UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeMusic url:model.mp3PlayUrl];
    if (platformName == UMShareToWechatTimeline ) {
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:[NSString stringWithFormat:@"%@: %@",model.albumName,model.audioName] image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
            }
        }];
        
    }
    
}
//- (BOOL)isDirectShareInIconActionSheet
//{
//    return YES;
//}


#pragma mark - tableView代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [VoicePlayer shareVoicePlayer].modelArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    VoiceListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[VoiceListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    VoicePlayListModel *model = [VoicePlayer shareVoicePlayer].modelArray[indexPath.row];
    
    cell.titleLabel.text = [NSString stringWithFormat:@"第%@期 %@",model.orderNum,model.audioName];

    if ([VoicePlayer shareVoicePlayer].currentSongIndex == indexPath.row) {
        cell.PlayingImageView.hidden = NO;
        [cell.PlayingImageView startAnimating];
    }else{
        cell.PlayingImageView.hidden = YES;
        [cell.PlayingImageView stopAnimating];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [VoicePlayer shareVoicePlayer].currentSongIndex = indexPath.row;
    [VoicePlayer shareVoicePlayer].voicePlayListModel = [VoicePlayer shareVoicePlayer].modelArray[indexPath.row];
    [[VoicePlayer shareVoicePlayer] playSongWithUrl:[VoicePlayer shareVoicePlayer].voicePlayListModel.mp3PlayUrl];
}


#pragma mark - 视图将要出现

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
    [super viewWillAppear:animated];
}

@end
