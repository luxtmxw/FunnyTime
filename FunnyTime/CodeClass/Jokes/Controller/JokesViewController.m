//
//  JokesViewController.m
//  FunnyTime
//
//  Created by luxt on 15/9/19.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import "JokesViewController.h"
#import "AppDelegate.h"
#import "JokesTableViewCell.h"
#import "JokesModel.h"
#import "MJRefresh.h"

@interface JokesViewController ()<UITableViewDataSource, UITableViewDelegate,UMSocialUIDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISegmentedControl *segmentControl;
@property (nonatomic, strong) NSMutableArray *funnyJockesDataArray;
@property (nonatomic, strong) NSMutableArray *meaningJockDataArray;
@property (nonatomic, strong) JokesModel *model;
@property (nonatomic, strong) NSMutableArray *jokesTitleArray;
@property (nonatomic, strong) UIButton *backToTop;
@end

@implementation JokesViewController



- (NSMutableArray *)funnyJockesDataArray{
    if (!_funnyJockesDataArray) {
        _funnyJockesDataArray = [[NSMutableArray alloc] init];
    }
    return _funnyJockesDataArray;
}

- (NSMutableArray *)meaningJockDataArray{
    if (!_meaningJockDataArray) {
        _meaningJockDataArray = [[NSMutableArray alloc] init];
    }
    return _meaningJockDataArray;
}

- (NSMutableArray *)jokesTitleArray
{
    if (!_jokesTitleArray) {
        _jokesTitleArray = [[NSMutableArray alloc] init];
    }
    return _jokesTitleArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self reloadDataFunnyJockesAndJson];
    [self setUpNavigationBar];
    [self setUpTableView];
    
    
    [self setupBackToTopButton];
    
}

- (void)setupBackToTopButton
{
    self.backToTop = [UIButton buttonWithType:UIButtonTypeSystem];
    self.backToTop.frame = CGRectMake(kScreenWidth - 55, kScreenHeight - 160, 40, 40);

    [self.backToTop setBackgroundImage:[UIImage imageNamed:@"backToTop_001.png"] forState:UIControlStateNormal];
    self.backToTop.alpha = 0.5;
    [self.backToTop addTarget:self action:@selector(backToTop:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backToTop];
}

- (void)backToTop:(UIButton *)button
{
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
}

#pragma mark - 页面设置

- (void)setUpNavigationBar{
    self.segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"搞笑段子", @"内涵段子"]];
    self.segmentControl.frame = CGRectMake(0, 0, 100, 30);
    self.segmentControl.selectedSegmentIndex = 0;
    [self.segmentControl addTarget:self action:@selector(segmentControlAction:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = self.segmentControl;
}


#pragma mark -segment的点击事件

- (void)segmentControlAction:(UISegmentedControl *)segment{
    [SVProgressHUD dismiss];
    [self.tableView headerEndRefreshing];
    [self.tableView footerEndRefreshing];
    switch (segment.selectedSegmentIndex) {
        case 0:
            if (self.funnyJockesDataArray.count < 1) {
                [self reloadDataFunnyJockesAndJson];
            }
            break;
        case 1:
            //添加一个判断  避免再次点击时需要刷新  节省时间
            if (self.meaningJockDataArray.count < 1) {
                [self reloadDataMeaningJockesAndJson];
            }
            break;
        default:
            break;
    }
    [self.tableView reloadData];
}


- (void)setUpTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    
    kADC
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//
    
    self.tableView.backgroundView = kBlurView;
    
    [self.tableView registerClass:[JokesTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    //下拉加载
    [self.tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    
    //上拉刷新
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    
    [self.view addSubview:self.tableView];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
    [self.tableView headerEndRefreshing];
    [self.tableView footerEndRefreshing];
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
//    self.rippleImageName = [[NSUserDefaults standardUserDefaults] objectForKey:@"changeBackground"];
    self.tableView.backgroundView = kBlurView;
    [self segmentControlAction:self.segmentControl];
    
    [super viewWillAppear:animated];
}


#pragma mark -行数

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (self.segmentControl.selectedSegmentIndex) {
        case 0:
            return self.funnyJockesDataArray.count;
            
            break;
        case 1:
            return self.meaningJockDataArray.count;
            break;
        default: return 20;
            break;
    }
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


#pragma mark -cell设置

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (self.segmentControl.selectedSegmentIndex) {
        case 0:
        {
            JokesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            JokesModel *model = self.funnyJockesDataArray[indexPath.row];
            
            return [self  setUpJockesTableViewCell:cell jockesModel:model indexPath:indexPath];
        }
            break;
        case 1:
        {
            JokesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            JokesModel *model = self.meaningJockDataArray[indexPath.row];
            
            return [self  setUpJockesTableViewCell:cell jockesModel:model indexPath:indexPath];
        }
            break;
            
        default: return nil;
            break;
    }
    
}

//添加每个cell出现时的3D动画
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    CATransform3D rotation;//3D旋转
//    rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
//    
//    //逆时针旋转
//    rotation.m34 = 1.0/ -600;
//    
//    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
//    cell.layer.shadowOffset = CGSizeMake(10, 10);
//    cell.alpha = 0;
//    
//    cell.layer.transform = rotation;
//    
//    [UIView beginAnimations:@"rotation" context:NULL];
//    //旋转时间
//    [UIView setAnimationDuration:0.8];
//    cell.layer.transform = CATransform3DIdentity;
//    cell.alpha = 1;
//    cell.layer.shadowOffset = CGSizeMake(0, 0);
//    [UIView commitAnimations];
}



- (JokesTableViewCell *)setUpJockesTableViewCell:(JokesTableViewCell *)cell jockesModel:(JokesModel *)model indexPath:(NSIndexPath *)index{
    
    cell.timeLabel.text = model.timeStr;
    cell.contentLabel.text = model.title;
    
    cell.contentLabel.height = [self getHeightWithString:model.title size:CGSizeMake(kScreenWidth - 3.4 * kDistanceOfEdge, 2000) font:[UIFont systemFontOfSize:16]];
    if (cell.contentLabel.height < kHeightOfWord) {
        cell.contentLabel.height = kHeightOfWord;
    }
    cell.contentLabel.top = cell.timeLabel.bottom;
    cell.collectionButton.top = cell.contentLabel.bottom;
    cell.collectionLabel.top = cell.contentLabel.bottom;
    cell.shareButton.top = cell.contentLabel.bottom;
    cell.shareLabel.top = cell.contentLabel.bottom;
    
    cell.shareBigButton.top = cell.contentLabel.bottom;
    cell.collectionBigButton.top = cell.contentLabel.bottom;
    
    cell.background.height = cell.contentLabel.height + 45;
    
    //收藏点击事件
    cell.collectionBigButton.tag = 2000 + index.row;
    [cell.collectionBigButton addTarget:self action:@selector(collectionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //分享点击事件
    cell.shareBigButton.tag = 3300 + index.row;
    [cell.shareBigButton addTarget:self action:@selector(showJokesShareActionSheet:) forControlEvents:UIControlEventTouchUpInside];
    
    //换图标
    if ([[FunnyTimeDataBase shareFunnyTimeDataBase] isExistJokeModel:model]) {
        [cell.collectionButton setImage:[UIImage imageNamed:@"isCollectedIcon_32.png"] forState:UIControlStateNormal];
    }else{
        [cell.collectionButton setImage:[UIImage imageNamed:@"unCollectedIcon_32.png"] forState:UIControlStateNormal];
    }
    
    return cell;
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



#pragma mark - 点击分享

- (void)showJokesShareActionSheet:(UIButton *)button
{
    
    NSInteger index = button.tag - 3300;
    
    switch (self.segmentControl.selectedSegmentIndex) {
        case 0:
        {
            self.model = self.funnyJockesDataArray[index];
            [self shareWithJokesModel:self.model view:button];
            
        }
            break;
            
        case 1:
        {
            self.model = self.meaningJockDataArray[index];
            [self shareWithJokesModel:self.model view:button];
        }
            break;
            
        default:
            break;
    }
 
 }

- (void)shareWithJokesModel:(JokesModel *)model view:(UIView *)view
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [UMSocialSnsService presentSnsController:delegate.window.rootViewController appKey:kUMAppkey shareText:model.title shareImage:nil shareToSnsNames:kShareToSnsNames delegate:self];
   
}
-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData {
    
    if (platformName == UMShareToWechatTimeline ) {
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:self.model.title image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
            }
        }];
        
    }
    
}


#pragma mark - 点击收藏

- (void)collectionButtonAction:(UIButton *)button
{
    NSInteger index = button.tag - 2000;
    
    switch (self.segmentControl.selectedSegmentIndex) {
        case 0:
        {
            JokesModel *model = self.funnyJockesDataArray[index];
            [self collectOrDeleteJokeFromDataBaseWithJokeModel:model];
        }
            break;
            
        case 1:
        {
            JokesModel *model = self.meaningJockDataArray[index];
            [self collectOrDeleteJokeFromDataBaseWithJokeModel:model];
        }
            break;
            
        default:
            break;
    }
    
    [self.tableView reloadData];
    
}

- (void)collectOrDeleteJokeFromDataBaseWithJokeModel:(JokesModel *)model
{
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"收藏" message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    
    CollectionView *collectiongAlert = [[CollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    if ([[FunnyTimeDataBase shareFunnyTimeDataBase] isExistJokeModel:model]) {
        [[FunnyTimeDataBase shareFunnyTimeDataBase] deleteJokeModel:model];
        
        [collectiongAlert setCollectionWithImageName:@"ppq_like@3x.png" title:@"取消收藏"];
        [self.view addSubview:collectiongAlert];
        
//        alertView.title = @"取消收藏";
        
    }else{
        [[FunnyTimeDataBase shareFunnyTimeDataBase] insertJokeCollectionWithJokeModel:model];
        [collectiongAlert setCollectionWithImageName:@"ppq_like_f@3x.png" title:@"收藏成功"];
        [self.view addSubview:collectiongAlert];
//        alertView.title = @"收藏成功";
    }
    
    [self performSelector:@selector(dismissCollectionAlert:) withObject:collectiongAlert afterDelay:0.5];
    
//    [self performSelector:@selector(dismissAlertView:) withObject:alertView afterDelay:0.5];
//    [alertView show];
    
}

- (void)dismissCollectionAlert:(CollectionView *)collectionView
{
    [collectionView removeFromSuperview];
}

#pragma mark -行高

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (self.segmentControl.selectedSegmentIndex) {
        case 0:{
            JokesModel *model = self.funnyJockesDataArray[indexPath.row];
            return [self setHeightByModel:model];
        }
            break;
            
        case 1:
        {
            JokesModel *model = self.meaningJockDataArray[indexPath.row];
            return [self setHeightByModel:model];
        }
            break;
        default: return 60;
            break;
    }
}

- (CGFloat)setHeightByModel:(JokesModel *)model{
    
    CGFloat fitHeightOfContentLabel = [self getHeightWithString:model.title size:CGSizeMake(kScreenWidth - 3.4 * kDistanceOfEdge, 2000) font:[UIFont systemFontOfSize:16]];
    
    if (fitHeightOfContentLabel < kHeightOfWord) {
        fitHeightOfContentLabel = kHeightOfWord;
    }
    
    return fitHeightOfContentLabel + 59;
    
}

//自适应高度
- (CGFloat)getHeightWithString:(NSString *)str size:(CGSize)size font:(UIFont *)font{
    CGRect rect = [str boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin) attributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName] context:nil];
    
    return rect.size.height;
}


#pragma mark - 数据分析

//去除重复段子的方法
- (BOOL)isHaveSameJokeModel:(JokesModel *)model
{
    if (self.jokesTitleArray.count == 0) {
        [self.jokesTitleArray addObject:model.title];
        return NO;
    }else{
        BOOL isHaveSame = NO;
        
        for (NSString *title in self.jokesTitleArray) {
            if ([title isEqualToString:model.title]) {
                isHaveSame = YES;
            }
        }
        
        if (isHaveSame) {
            return YES;
        }else{
            [self.jokesTitleArray addObject:model.title];
            return NO;
        }
        
    }
    
    return NO;
}


#pragma mark -上拉加载更多

- (void)footerRefreshing{
    switch (self.segmentControl.selectedSegmentIndex) {
        case 0:
        {
            [self reloadDataMoreFunnyJockesAndJson];
        }
            break;
        case 1:
        {
            [self reloadMoreDataMeaningJockesAndJson];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark -下拉刷新数据

- (void)headerRefreshing{
    switch (self.segmentControl.selectedSegmentIndex) {
        case 0:
            [self headerReloadDataWithArray:self.funnyJockesDataArray URLString:kFunnyJockesForBeginUrl];
            break;
        case 1:
            [self headerReloadDataWithArray:self.meaningJockDataArray URLString:kMeaningJockesForBeginUrl];
            break;
        default:
            break;
    }
}

//下拉刷新数据
- (void)headerReloadDataWithArray:(NSMutableArray *)dataArray URLString:(NSString *)urlStr
{
    if (dataArray.count > 0) {
        
        [LORequestManger GET:urlStr success:^(id response) {
            NSDictionary *sourceDic = (NSDictionary *)response;
            
            BOOL isInsertSuccessed = NO; //判断是否有数据更新
            
            NSString *dataKey;
            if (0 == self.segmentControl.selectedSegmentIndex) {
                dataKey = @"rows";
            }else if (1 == self.segmentControl.selectedSegmentIndex) {
                dataKey = @"items";
            }

            for (NSDictionary *dic in sourceDic[dataKey]) {
                JokesModel *newModel = [JokesModel JockesModelWithDictionary:dic];
                newModel.collectionType = [NSString stringWithFormat:@"%zi",self.segmentControl.selectedSegmentIndex];
                
                float maxTimeStamp = 0.0;  //数组里最大的时间戳
                for (JokesModel *tempModel in dataArray) {
                    maxTimeStamp = [tempModel.cTime floatValue] > maxTimeStamp ? [tempModel.cTime floatValue] : maxTimeStamp;
                }

                //插入数据
                if ([newModel.cTime floatValue] > maxTimeStamp) {
                    if (![self isHaveSameJokeModel:newModel]) {
                       
                        [dataArray insertObject:newModel atIndex:0];
                        isInsertSuccessed = YES;
                    }
                    
                }
                
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                //如果没有更新,给个提示
                if (isInsertSuccessed) {
                    NSLog(@"已经刷新");
                }else{
                    NSLog(@"已经最新了");
                }
                
                [self.tableView reloadData];
                [self.tableView headerEndRefreshing];
            });
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self networkErrorActionWithError:error];
        }];
    }
}


//搞笑段子
- (void)reloadDataFunnyJockesAndJson{
    //断网提醒
    [[NetMoniter sharedClient] checkNetWork];
    
    //风火轮
    [SVProgressHUD showWithStatus:@"努力加载..."];
    [LORequestManger GET:kFunnyJockesForBeginUrl success:^(id response) {
        NSDictionary *resourceDic = (NSDictionary *)response;
        
        for (NSDictionary *dic in resourceDic[@"rows"]) {
            JokesModel *model = [JokesModel JockesModelWithDictionary:dic];
            model.collectionType = [NSString stringWithFormat:@"%zi",self.segmentControl.selectedSegmentIndex];
            //去重
            if (![self isHaveSameJokeModel:model]) {
                
                [self.funnyJockesDataArray addObject:model];
            }
 
        }
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self networkErrorActionWithError:error];
    }];
}

//加载更多搞笑段子
- (void)reloadDataMoreFunnyJockesAndJson{
    JokesModel *lastModel = [self.funnyJockesDataArray lastObject];
    NSString *newUrl = [NSString stringWithFormat:@"%@%@",kFunnyJockesForMoreUrl, lastModel.cTime];
    [LORequestManger GET:newUrl success:^(id response) {
        
        NSArray *resourceArray = (NSArray *)response;
        for (NSDictionary *dic in resourceArray) {
            JokesModel *model = [JokesModel JockesModelWithDictionary:dic];
            model.collectionType = [NSString stringWithFormat:@"%zi",self.segmentControl.selectedSegmentIndex];
            
            //去重
            if (![self isHaveSameJokeModel:model]) {
                [self.funnyJockesDataArray addObject:model];
            }
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.tableView footerEndRefreshing];
        });

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self networkErrorActionWithError:error];
    }];
}

//内涵段子
- (void)reloadDataMeaningJockesAndJson{
    //断网提醒
    [[NetMoniter sharedClient] checkNetWork];
    
    //风火轮的设置!!
    [SVProgressHUD showWithStatus:@"努力加载..."];
    
    [LORequestManger GET:kMeaningJockesForBeginUrl success:^(id response) {
        NSDictionary *resourceDic = (NSDictionary *)response;
        
        for (NSDictionary *dic  in resourceDic[@"items"]) {
            JokesModel *model = [JokesModel JockesModelWithDictionary:dic];
            model.collectionType = [NSString stringWithFormat:@"%zi",self.segmentControl.selectedSegmentIndex];
            //去重
            if (![self isHaveSameJokeModel:model]) {
                [self.meaningJockDataArray addObject:model];
            }
        }
        [self.tableView  reloadData];
        [SVProgressHUD dismiss];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self networkErrorActionWithError:error];
    }];
}

//加载更多内涵段子
- (void)reloadMoreDataMeaningJockesAndJson{
    
    JokesModel *model = [self.meaningJockDataArray lastObject];
    NSString *str = model.cTime;
    NSString *newUrl = [[kMeaningJockesForMoreOneUrl stringByAppendingString:str]stringByAppendingString:kMeaningJockesForMoreTwoUrl];
    
    [LORequestManger GET:newUrl success:^(id response) {
        NSDictionary *resourceDic = (NSDictionary *)response;
        
        for (NSDictionary *dic  in resourceDic[@"items"]) {
            JokesModel *model = [JokesModel JockesModelWithDictionary:dic];
            model.collectionType = [NSString stringWithFormat:@"%zi",self.segmentControl.selectedSegmentIndex];
            //去重
            if (![self isHaveSameJokeModel:model]) {
                
                [self.meaningJockDataArray addObject:model];
            }

        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView  reloadData];
            [self.tableView footerEndRefreshing];
        });

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self networkErrorActionWithError:error];
    }];
}

- (void)networkErrorActionWithError:(NSError *)error
{
    NSLog(@"%@",error);
    
    //刷新提示消失
    [SVProgressHUD dismiss];
    [self.tableView headerEndRefreshing];
    [self.tableView footerEndRefreshing];
    
    //提示
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"抱歉,网络错误,请检查网络" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
//    [alertView show];
//    [self performSelector:@selector(dismissAlertView:) withObject:alertView afterDelay:0.5];
    
}

- (void)dismissAlertView:(UIAlertView *)alertView
{
    [alertView dismissWithClickedButtonIndex:[alertView cancelButtonIndex] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
