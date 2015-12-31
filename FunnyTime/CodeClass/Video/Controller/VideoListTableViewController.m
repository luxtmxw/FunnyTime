//
//  VideoListTableViewController.m
//  FunnyTime
//
//  Created by luxt on 15/9/24.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import "VideoListTableViewController.h"
#import "VideoModel.h"
#import "VideoListTableViewCell.h"
#import "VideoHeaderView.h"
#import "MJRefresh.h"
#import "PlayVideoViewController.h"
#import "AppDelegate.h"
#import "VideoCollectionViewCell.h"
#import "VideoHeaderCollectionView.h"
#import "TLCollectionViewLineLayout.h"
@interface VideoListTableViewController ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *videoListArray;
@property (nonatomic, strong) VideoHeaderView *headView;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) TLCollectionViewLineLayout *layout;

@property (nonatomic, strong) NSMutableArray *videoIDArray;
@property (nonatomic, strong) UIButton *backToTop;
@end

@implementation VideoListTableViewController

//懒加载初始化
- (NSMutableArray *)videoListArray {
    if (!_videoListArray) {
        _videoListArray = [[NSMutableArray alloc] init];
    }
    return _videoListArray;
}

- (NSMutableArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [[NSMutableArray alloc] init];
    }
    return _titleArray;
}

- (NSMutableArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

- (NSMutableArray *)videoIDArray
{
    if (!_videoIDArray) {
        _videoIDArray = [[NSMutableArray alloc] init];
    }
    return _videoIDArray;
}

//设置轮播图
//- (void)setUpTableHeadView {
//    self.imageArray = [[NSMutableArray alloc] init];
//    if (self.videoListArray.count == 0) {
//        return;
//    }
//    for (int i = 0; i < 5; i++) {
//        VideoModel *videoModel = self.videoListArray[i];
//        [self.imageArray addObject:videoModel.pic];
//        [self.titleArray addObject:videoModel.title];
//    }
//    
//    self.timer = [[NSTimer alloc] init];
//    self.headView = [[VideoHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,kScreenHeight * (200 / 667.0)) imageArray:self.imageArray delegate:self action:@selector(touchImage) timer:3 selector:@selector(circularly) titleArray:self.titleArray];
//    self.headView.delegate = self;
//    self.tableView.tableHeaderView = self.headView;
//    [self.timer fire];
//}

- (void)touchImage {
    
}

//定时器设置循环滚动
//- (void)circularly
//{
//    [self scrollViewDidCircularly];
//    //创建一个newPoint每次被赋予当前scrollview的contentOffset
//    CGPoint newPoint = self.headView.contentOffset;
//    newPoint.x += kScreenWidth;
//    [self.headView setContentOffset:newPoint animated:YES];
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    [self scrollViewDidCircularly];
//}

//封装循环滚动方法在手动滑动与定时器方法内调用
//- (void)scrollViewDidCircularly
//{
//    if (self.headView.contentOffset.x == 0) {
//        [self.headView setContentOffset:CGPointMake(self.headView.contentSize.width - 2 * self.headView.bounds.size.width, 0) animated:NO];
//    }
//    else if (self.headView.contentOffset.x == self.headView.contentSize.width - self.headView.bounds.size.width) {
//        [self.headView setContentOffset:CGPointMake(self.headView.bounds.size.width, 0) animated:NO];
//    }
//}

//设置头视图
- (void)setUpCollectionView {
    if (self.videoListArray.count == 0) {
        return;
    }
    for (int i = 0; i < 5; i++) {
        VideoModel *videoModel = self.videoListArray[i];
        [self.imageArray addObject:videoModel.pic];
        [self.titleArray addObject:videoModel.title];
    }
    
    _layout = [[TLCollectionViewLineLayout alloc] init];
    VideoHeaderCollectionView *collcetionView = [[VideoHeaderCollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight * 0.25) collectionViewLayout:_layout delegate:self dataSource:self];
    [self.view addSubview:collcetionView];
    [collcetionView registerClass:[VideoCollectionViewCell class] forCellWithReuseIdentifier:@"videoHeaderCell"];
    [collcetionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    self.tableView.tableHeaderView = collcetionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"videoHeaderCell" forIndexPath:indexPath];
    
    [cell setUpCollectionCellWithImage:self.imageArray[indexPath.item] title:self.titleArray[indexPath.item]];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    PlayVideoViewController *playViewVC = [[PlayVideoViewController alloc] init];
    [self enterPlayVideoConyrollerWithPlayViewVC:playViewVC index:indexPath.item];
    [delegate.window.rootViewController presentViewController:playViewVC animated:YES completion:nil];
}

//进入播放页面
- (void)enterPlayVideoConyrollerWithPlayViewVC:(PlayVideoViewController *)playViewVC index:(NSInteger)index{
    playViewVC.videoModel = self.videoListArray[index];
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.videoListArray];
    
    [tempArray removeObjectsInRange:NSMakeRange(0, index+ 1)];
    
    playViewVC.listArray = tempArray;
}

//去重方法
- (BOOL)isSameWithVideoModel:(VideoModel *)model
{
    BOOL isSame = NO;

    if (self.videoIDArray.count == 0) {
        [self.videoIDArray addObject:model.ID];
        return NO;
    }else{
        
        for (NSString *tempID in self.videoIDArray) {
            if ([tempID isEqualToString:model.ID]) {
                isSame = YES;
            }
        }
        
        if (isSame) {
            
            return YES;
        }else{
            [self.videoIDArray addObject:model.ID];
            return NO;
        }
        
    }
    
    return NO;
}

//解析videoUrl
- (void)reloadVideoUrl {
    
    //断网提醒
    [[NetMoniter sharedClient] checkNetWork];
    
    [SVProgressHUD showWithStatus:@"努力加载..."];
    [LORequestManger GET:kVideoForBeginUrl success:^(id response) {
        NSDictionary *Sourcedic = (NSDictionary *)response;
        for (NSDictionary *dic in Sourcedic[@"rows"]) {
            VideoModel *videoListModel = [VideoModel videoModelWithDic:dic];
            
            //去重
            if (![self isSameWithVideoModel:videoListModel]) {
                [self.videoListArray addObject:videoListModel];
            }
  
        }
        [self setUpCollectionView];
//        [self setUpTableHeadView];
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@++", error);
    }];
}

//上拉,加载更多
- (void)footerRefreshingMoreVideoData
{
    VideoModel *lastModel = [self.videoListArray lastObject];
    NSString *newUrlStr = [NSString stringWithFormat:@"%@%@",kVideoForMoreUrl,lastModel.cTime];
    [self reloadMoreVideoWithUrlStr:newUrlStr];
}

//上拉,加载更多
- (void)reloadMoreVideoWithUrlStr:(NSString *)urlStr
{
    if (0 < self.videoListArray.count) {
        
        [LORequestManger GET:urlStr success:^(id response) {
            NSArray *array = (NSArray *)response;
            for (NSDictionary *obj in array) {
                VideoModel *videoListModel = [VideoModel videoModelWithDic:obj];
                
                //去重
                if (![self isSameWithVideoModel:videoListModel]) {
                    
                    [self.videoListArray addObject:videoListModel];
                }
            }
            
            //刷新页面,关闭刷新效果
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.tableView reloadData];
                [self.tableView footerEndRefreshing];
                
            });
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
}

//下拉刷新
- (void)headerrefreshingNewVideoData
{
    if (0 < self.videoListArray.count) {
        
        [LORequestManger GET:kVideoForBeginUrl success:^(id response) {
            
            BOOL isInsertSuccessed = NO; //判断是否有数据更新
            
            NSDictionary *sourceDic = (NSDictionary *)response;
            
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:sourceDic[@"rows"]]; //存放原始数据的临时数组
            
            //如果新来的数据最后一个时间戳比原来的数据第一个时间戳还要大,就移除所有旧数据,重新加载
            
            VideoModel *lastModelForNewData = [VideoModel videoModelWithDic:[tempArray lastObject]];
            VideoModel *firstModelForOldData = [self.videoListArray firstObject];
            
            if ([lastModelForNewData.cTime floatValue] > [firstModelForOldData.cTime floatValue]) {
                
                [self.videoListArray removeAllObjects]; //就移除所有旧数据
                
                //重新加载
                for (NSDictionary *dic in sourceDic[@"rows"]) {
                    VideoModel *model = [VideoModel videoModelWithDic:dic];
                    
                    //去重
                    if (![self isSameWithVideoModel:model]) {
                        
                        [self.videoListArray addObject:model];
                    }
                }
                
            }else{
                //如果新来的数据最后一个时间戳小于原来的数据第一个时间戳
                //正常下拉刷新数据
                //即在最前面插入新数据
                //递减,插入新数据后,i 的初始值不变
                for (int i = (int)(tempArray.count - 1); i >= 0; i--) {
                    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:tempArray[i]];
                    VideoModel *newModel = [VideoModel videoModelWithDic:dic];
                    
                    float maxTimeStamp = 0.0;  //原来数组里最大的时间戳
                    for (VideoModel *model in self.videoListArray) {
                        maxTimeStamp = maxTimeStamp > [model.cTime floatValue] ? maxTimeStamp : [model.cTime floatValue];
                    }
                    
                    //新来的数据时间戳比原来的都大,在最前面插入新数据
                    if ([newModel.cTime floatValue] > maxTimeStamp) {
                        
                        //去重
                        if (![self isSameWithVideoModel:newModel]) {
                            
                            [self.videoListArray insertObject:newModel atIndex:0];
                        }

                        isInsertSuccessed = YES;
                    }
                    
                }
                
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [self.tableView headerEndRefreshing];
                
                if (isInsertSuccessed) {
                    NSLog(@"视频刷新成功");
                }else{
                    NSLog(@"没有新数据");
                }
            });
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        
        
    }else{
        [self reloadVideoUrl];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    kADC
    
    [self reloadVideoUrl];
    
    //隐藏分割线
    self.tableView.separatorStyle = NO;
    
    //注册cell
    [self.tableView registerClass:[VideoListTableViewCell class] forCellReuseIdentifier:@"videoListCell"];
    //创建模糊视图
//    BlurImageView *blurImageView = [[BlurImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.tableView.backgroundView = kBlurView;
    
//    [self setUpTableHeadView];
    [self.headView.scorllTimer fire];
    
    //上拉加载更多
    [self.tableView addFooterWithTarget:self action:@selector(footerRefreshingMoreVideoData)];
    //下拉刷新
    [self.tableView addHeaderWithTarget:self action:@selector(headerrefreshingNewVideoData)];
    
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


-(void)viewWillAppear:(BOOL)animated
{
    if (self.videoListArray.count < 1) {
        [self headerrefreshingNewVideoData];
    }
    
    self.tableView.backgroundView = kBlurView;
    [super viewWillAppear:animated];
}

//视图消失,停止所有刷新
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
    [self.tableView footerEndRefreshing];
    [self.tableView headerEndRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.videoListArray.count;
}

//设置cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 20 + kScreenHeight * 0.12;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"videoListCell" forIndexPath:indexPath];
    
    VideoModel *model = self.videoListArray[indexPath.row];
    
    [cell setUpVideoTableCellWithPic:model.pic titleLabel:model.title timeLabel:model.timeStr likeLabelL:model.uname];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    PlayVideoViewController *playViewVC = [[PlayVideoViewController alloc] init];
    playViewVC.videoModel = self.videoListArray[indexPath.row];
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.videoListArray];
    

    playViewVC.index = indexPath.row;
    playViewVC.listArray = tempArray;
//    CATransition *animation = [CATransition animation];
//    animation.duration = 0.5;
//    animation.subtype =  kCATransitionFromLeft;
//    animation.type = @"rippleEffect";
//    [self.navigationController.view.layer addAnimation:animation forKey:nil];
    
//    [self.navigationController pushViewController:playViewVC animated:YES];
    
    [delegate.window.rootViewController presentViewController:playViewVC animated:YES completion:nil];
    
}


@end
