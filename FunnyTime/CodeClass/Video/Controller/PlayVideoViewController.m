//
//  PlayVideoViewController.m
//  FunnyTime
//
//  Created by luxt on 15/9/24.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import "PlayVideoViewController.h"
#import "PlayVideoView.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
#import "BaseTabBarController.h"
#import "LeftSlideViewController.h"

#import "VideoPlayingTableViewCell.h"

//#import <MediaPlayer/MediaPlayer.h>
@interface PlayVideoViewController ()<UITableViewDelegate,UITableViewDataSource,UMSocialUIDelegate>

@property (nonatomic, strong) PlayVideoView *playVideoView;
@property (nonatomic, strong) CollectionView *collectionAlert;
@property (nonatomic, assign) BOOL isCollection;
@property (nonatomic, strong) BaseTabBarController *baseTabBar;

@end

@implementation PlayVideoViewController


- (NSUInteger)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
}
- (BOOL)shouldAutorotate {
    return NO;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return 1;
}
- (void)loadView {
    self.view = kBlurView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(progress) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    //    [self.playVideoView.moviePlayer addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew) context:nil];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setUpRootController) name:MPMoviePlayerWillEnterFullscreenNotification object:nil];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(regainRootController) name:MPMoviePlayerDidExitFullscreenNotification object:nil];
    //    [[NSNotificationCenter defaultCenter] postNotificationName:MPMoviePlayerDidExitFullscreenNotification object:nil];
}
//- (void)progress {
//    [SVProgressHUD dismiss];
//}
//- (void)setUpRootController {
//    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
////    self.baseTabBar = [[BaseTabBarController alloc] init];
//    delegate.window.rootViewController = self;
//}
//- (void)regainRootController {
////    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerWillEnterFullscreenNotification object:nil];
//    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    LeftSlideViewController *leftVC = [[LeftSlideViewController alloc] init];
//    delegate.window.rootViewController = leftVC;
//
//}


//tableView上拉加载
- (void)footerRefreshingMoreVideoData {
    VideoModel *lastModel = [self.listArray lastObject];
    NSString *newUrlStr = [NSString stringWithFormat:@"%@%@",kVideoForMoreUrl,lastModel.cTime];
    [self reloadMoreVideoWithUrlStr:newUrlStr];
}

#pragma mark - 解析
//解析
- (void)reloadMoreVideoWithUrlStr:(NSString *)urlStr {
    if (0 < self.listArray.count) {
        [LORequestManger GET:urlStr success:^(id response) {
            NSArray *array = (NSArray *)response;
            for (NSDictionary *obj in array) {
                VideoModel *VideoListModel = [VideoModel videoModelWithDic:obj];
                [self.listArray addObject:VideoListModel];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
                [self.playVideoView.listTableView reloadData];
                [self.playVideoView.listTableView footerEndRefreshing];
                
            });
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
}

#pragma matk - 初始化View
//初始化View
- (void)setUpView {
    self.playVideoView = [[PlayVideoView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    
    
    //播放大按钮
    [self.playVideoView.playerButton addTarget:self action:@selector(playVideo) forControlEvents:(UIControlEventTouchUpInside)];
    
    //返回
    self.playVideoView.backButton.userInteractionEnabled = YES;
    [self.playVideoView.backButton addTarget:self action:@selector(actionButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    //播放小按钮
    [self.playVideoView.playSmallButton addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
    
    //上拉加载
    [self.playVideoView.listTableView addFooterWithTarget:self action:@selector(footerRefreshingMoreVideoData)];
    
    //收藏按钮
    [self.playVideoView.collectionButton addTarget:self action:@selector(actionCollectionButtion) forControlEvents:(UIControlEventTouchUpInside)];
    
    //分享按钮
    [self.playVideoView.shareButton addTarget:self action:@selector(actionShareButtion) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    //列表
    self.playVideoView.listTableView.delegate = self;
    self.playVideoView.listTableView.dataSource = self;
    [self.playVideoView.listTableView registerClass:[VideoPlayingTableViewCell class] forCellReuseIdentifier:@"playVideoCell"];
    [self.playVideoView.listTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    //更新页面
    [self refreshView];
    
    //点击进入全屏通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopPlay) name:MPMoviePlayerWillEnterFullscreenNotification object:nil];
    //点击退出全屏通知
//    [[NSNotificationCenter defaultCenter] addObserver:[VoicePlayer shareVoicePlayer] selector:@selector(starPlayVoice) name:MPMoviePlayerDidExitFullscreenNotification object:nil];
    
    //播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishMovie) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
}


- (void)didFinishMovie
{
    if (![VoicePlayer shareVoicePlayer].isPlaying) {
        [[VoicePlayer shareVoicePlayer] starPlayVoice];
    }
}

//更新页面
- (void)refreshView
{
    //换收藏图标
    if ([[FunnyTimeDataBase shareFunnyTimeDataBase] isExistVideoModel:self.videoModel]) {
        [self.playVideoView.collectionButton setImage:[UIImage imageNamed:@"isCollectedIcon_32.png"] forState:(UIControlStateNormal)];
        self.isCollection = YES;
    }
    else {
        [self.playVideoView.collectionButton setImage:[UIImage imageNamed:@"unCollectedIcon_32.png"] forState:(UIControlStateNormal)];
        self.isCollection = NO;
    }
    
    //刷新列表
    [self.playVideoView.listTableView reloadData];
    
    //换大图片
    [self.playVideoView setUpPlayVideoViewWithTitle:self.videoModel.title timeLabel:self.videoModel.cTime pic:self.videoModel.pic];
    [self.view addSubview:self.playVideoView];
}


#pragma mark - 播放

- (void)playVideo{
    
    //关闭音乐播放
    if ([VoicePlayer shareVoicePlayer].isPlaying) {
        [[VoicePlayer shareVoicePlayer] stopPlayVoice];
    }
    
    //播放
    MPMoviePlayerViewController *playerViewController =[[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:self.videoModel.mp4_url]];
    [self presentMoviePlayerViewControllerAnimated:playerViewController];
}


#pragma mark - 返回

- (void)actionButton {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissVideoPlayVC" object:nil];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


#pragma mark - 收藏

- (void)actionCollectionButtion {

    self.collectionAlert = [[CollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    if ([[FunnyTimeDataBase shareFunnyTimeDataBase] isExistVideoModel:self.videoModel]) {
        [[FunnyTimeDataBase shareFunnyTimeDataBase] deleteVideoModel:self.videoModel];
        
        [self.collectionAlert setCollectionWithImageName:@"ppq_like@3x.png" title:@"取消收藏"];
        
        
        [self.view addSubview:self.collectionAlert];
        
    }
    else {
        [[FunnyTimeDataBase shareFunnyTimeDataBase] insertVideoCollectionWithVideoModel:self.videoModel];
        
        [self.collectionAlert setCollectionWithImageName:@"ppq_like_f@3x.png" title:@"收藏成功"];
        
        
        [self.view addSubview:self.collectionAlert];
        
    }
    
    
    if (self.isCollection == YES) {
        [self.playVideoView.collectionButton setImage:[UIImage imageNamed:@"unCollectedIcon_32.png"] forState:(UIControlStateNormal)];
        self.isCollection = NO;
    }
    else {
        [self.playVideoView.collectionButton setImage:[UIImage imageNamed:@"isCollectedIcon_32.png"] forState:(UIControlStateNormal)];
        self.isCollection = YES;
    }
    [self performSelector:@selector(dismissCollectionAlert:) withObject:self.collectionAlert afterDelay:0.5];
}
- (void)dismissCollectionAlert:(CollectionView *)collectionAlert {
    [collectionAlert removeFromSuperview];
}


#pragma mark - 分享

- (void)actionShareButtion {
    
    [UMSocialSnsService presentSnsController:self appKey:kUMAppkey shareText:self.videoModel.mp4_url shareImage:nil shareToSnsNames:kShareToSnsNames delegate:self];
}
-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData {
    UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeVideo url:self.videoModel.mp4_url];
    if (platformName == UMShareToWechatTimeline ) {
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:self.videoModel.title image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
            }
        }];
        
    }
    
}
//横屏全屏 竖屏返回
- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection
              withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
{
    [super willTransitionToTraitCollection:newCollection
                 withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id <UIViewControllerTransitionCoordinatorContext> context) {
        if (newCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact) {
            [self.playVideoView.moviePlayer setFullscreen:YES animated:YES];
        } else {
            self.playVideoView.moviePlayer.fullscreen = NO;
        }
        [self.view setNeedsLayout];
    } completion:nil];
}
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//
//    return UIInterfaceOrientationMaskPortrait;
//}


#pragma mark - tabbleView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoPlayingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"playVideoCell"];
    if (!cell) {
        cell = [[VideoPlayingTableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"playVideoCell"];
    }
    //    [self.listArray removeObject:self.listArray.firstObject];
    
    //    NSInteger index = indexPath.row;
    
    VideoModel *videoModel = self.listArray[indexPath.row];
    [cell.picImageView sd_setImageWithURL:[NSURL URLWithString:videoModel.pic] placeholderImage:[UIImage imageNamed:@"loadingPic00.png"]];
    cell.titleLabel.text = videoModel.title;
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = NO;
    
    self.playVideoView.listTableView.contentSize = CGSizeMake(kScreenWidth, 40 * self.listArray.count + 10);
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.videoModel = self.listArray[indexPath.row];
    
    [self.playVideoView removeFromSuperview];
    [self refreshView];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
