//
//  VoiceTableViewController.m
//  FunnyTime
//
//  Created by luxt on 15/9/24.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import "VoiceTableViewController.h"
#import "VoiceListModel.h"
#import "VoiceTableViewCell.h"
#import "MJRefresh.h"
#import "VoicePlayListTableViewController.h"
#import "PlayingImageView.h"

@interface VoiceTableViewController ()

@property (nonatomic, strong) NSMutableArray *voiceListArray;
//存放音阶图片名
@property (nonatomic, strong) NSMutableArray *iconArray;
//数组下标
@property (nonatomic, assign) NSInteger index;
//计时器
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIBarButtonItem *rightBarButton;

@property (nonatomic, strong) NSMutableArray *voiceIDArray;

@property (nonatomic, strong) UIButton *backToTop;

@end

@implementation VoiceTableViewController

//懒加载
- (NSMutableArray *)voiceListArray {
    if (!_voiceListArray) {
        _voiceListArray = [NSMutableArray array];
    }
    return _voiceListArray;
}

- (NSMutableArray *)voiceIDArray
{
    if (!_voiceIDArray) {
        _voiceIDArray = [[NSMutableArray alloc] init];
    }
    return _voiceIDArray;
}

//计算时间戳
- (NSString *)calculateTimestamp {
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *timestamp = [NSString stringWithFormat:@"%d", (int)time];
    return timestamp;
}

//去重方法
- (BOOL)isSameVoiceWithModel:(VoiceListModel *)model
{
    BOOL isSame = NO;
    NSArray *strArray = [model.albumName componentsSeparatedByString:@"微信"];
    if (strArray.count >= 2) {
        return YES;
    }
    
    if (self.voiceIDArray.count == 0) {
        [self.voiceIDArray addObject:model.ID];
        return NO;
    }else{

        for (NSString *tempID in self.voiceIDArray) {
            if ([tempID isEqualToString:model.ID]) {
                isSame = YES;
            }
        }
        
        if (isSame) {
            return YES;
        }else{
            [self.voiceIDArray addObject:model.ID];
            return NO;
        }
    }
    
    return NO;
}


/**
 *  解析URL
 */

- (void)reloadVoiceWithJsonWithUrl:(NSString *)url isPullToRefresh:(BOOL)isPull {
    if (!isPull) {
        [SVProgressHUD showWithStatus:@"正在加载"];
    }

    [LORequestManger GET:url success:^(id response) {
        NSDictionary *dic = (NSDictionary *)response;
//        NSLog(@"%@", url);
        for (NSDictionary *obj in dic[@"result"][@"dataList"]) {
            
            VoiceListModel *voiceListModel = [VoiceListModel shareWithResultDic:dic[@"result"] dic:obj];

            //去重
            if (![self isSameVoiceWithModel:voiceListModel]) {
                
                [self.voiceListArray addObject:voiceListModel];
            }
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [self.tableView reloadData];
            [self.tableView footerEndRefreshing];
            [self.tableView headerEndRefreshing];
            
        });
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

//下拉刷新
//- (void)headerRefreshingNewVoiceAlumData
//{
//    NSString *timestamp = [self calculateTimestamp];
//    NSString *urlStr = [NSString stringWithFormat:kVoiceListUrl, timestamp];
//    
//    
//    [self reloadVoiceWithJsonWithUrl:urlStr];
//    
//}

//上拉加载
- (void)footerRefreshingMoreVoiceAlumData
{
    if (self.voiceListArray.count == 0) {
        return ;
    }
    NSString *timestamp = [self calculateTimestamp];
    VoiceListModel *voiceListModel = [self.voiceListArray lastObject];
    if (voiceListModel.nextPage == voiceListModel.currentPage) {
        NSLog(@"没有了");
        return;
    }
    NSString *urlStr = [NSString stringWithFormat:kVoicePullUrl, voiceListModel.nextPage, timestamp];
    
    [self reloadVoiceWithJsonWithUrl:urlStr isPullToRefresh:YES];
}

//设置导航条
- (void)setMyNavigationBar
{
    PlayingImageView *playingView = [[PlayingImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 30) Target:self Action:@selector(presentPlayView)];
    if ([VoicePlayer shareVoicePlayer].isPlaying) {
        [playingView startAnimating];
        playingView.hidden = NO;
    }else{
        playingView.hidden = YES;
        [playingView stopAnimating];
        playingView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_upbar_icon_playing%d",(int)(arc4random() % 26 + 1)]];
    }

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:playingView] ;
}

- (void)presentPlayView
{
    if ([VoicePlayer shareVoicePlayer].playViewController) {
        [self presentViewController:(UIViewController *)[VoicePlayer shareVoicePlayer].playViewController animated:YES completion:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.voiceListArray.count == 0) {
        //解析
        NSString *timestamp = [self calculateTimestamp];
        NSString *url = [NSString stringWithFormat:kVoiceListUrl, timestamp];
        [self reloadVoiceWithJsonWithUrl:url isPullToRefresh:NO];
    }
    
    self.tableView.backgroundView = kBlurView;
    [self setMyNavigationBar];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    kADC
    
    //去掉分割线
    self.tableView.separatorStyle = NO;
    //创建模糊视图
    self.tableView.backgroundView = kBlurView;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    //注册cell
    [self.tableView registerClass:[VoiceTableViewCell class] forCellReuseIdentifier:@"voiceListCell"];
    //解析
    NSString *timestamp = [self calculateTimestamp];
    NSString *url = [NSString stringWithFormat:kVoiceListUrl, timestamp];
    [self reloadVoiceWithJsonWithUrl:url isPullToRefresh:NO];
    
    //下拉刷新
//    [self.tableView addHeaderWithTarget:self action:@selector(headerRefreshingNewVoiceAlumData)];
    //上拉加载
    [self.tableView addFooterWithTarget:self action:@selector(footerRefreshingMoreVoiceAlumData)];
    
    [self setupBackToTopButton];
}

- (void)setupBackToTopButton
{
    self.backToTop = [UIButton buttonWithType:UIButtonTypeSystem];
    self.backToTop.hidden = YES;
    self.backToTop.frame = CGRectMake(kScreenWidth - 55, kScreenHeight - 100, 40, 40);
    
    [self.backToTop setBackgroundImage:[UIImage imageNamed:@"backToTop_001.png"] forState:UIControlStateNormal];
    self.backToTop.alpha = 0.5;
    [self.backToTop addTarget:self action:@selector(backToTop:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.view addSubview:self.backToTop];
}

- (void)backToTop:(UIButton *)button
{
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
}


#pragma mark - scrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.backToTop.hidden = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    //下拉一定距离时才出现返回顶部按钮
    if (self.tableView.contentOffset.y < kScreenHeight / 2) {
        self.backToTop.hidden = YES;
    }else{
        self.backToTop.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.voiceListArray.count;
}

//row高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 76;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VoiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"voiceListCell" forIndexPath:indexPath];
    
    VoiceListModel *model = self.voiceListArray[indexPath.row];
    [cell setUpWithPicImage:model.pic albumname:model.albumName listenNum:model.listenNum];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VoiceListModel *model = self.voiceListArray[indexPath.row];
    VoicePlayListTableViewController *voicePlayListVC = [[VoicePlayListTableViewController alloc] init];
    voicePlayListVC.title = model.albumName;
    voicePlayListVC.albumID = model.ID;
    voicePlayListVC.albumDesc = model.desc;
    voicePlayListVC.albumPic = model.pic;
    [self.navigationController pushViewController:voicePlayListVC animated:YES];
}



@end
