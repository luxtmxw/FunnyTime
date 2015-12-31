//
//  PictureViewController.m
//  FunnyTime
//
//  Created by luxt on 15/9/19.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import "PictureViewController.h"
#import "PictureTableViewCell.h"
#import "PictureModel.h"
#import "MJRefresh.h"
#import "AppDelegate.h"

#import "PicDetailViewController.h"

@interface PictureViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,UMSocialUIDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISegmentedControl *segmentControl;
@property (nonatomic, strong) NSMutableArray *classicPicDataArray;
@property (nonatomic, strong) NSMutableArray *recommentPicDataArray;
@property (nonatomic, strong) NSMutableArray *wonderfulPicDataArray;

@property (nonatomic, strong) NSMutableArray *picNameArray;
@property (nonatomic, strong) UIButton *backToTop;

@end

@implementation PictureViewController

- (NSMutableArray *)classicPicDataArray
{
    if (!_classicPicDataArray) {
        _classicPicDataArray = [[NSMutableArray alloc] init];
    }
    return _classicPicDataArray;
}

- (NSMutableArray *)recommentPicDataArray
{
    if (!_recommentPicDataArray)
    {
        _recommentPicDataArray = [[NSMutableArray alloc] init];
    }
    return _recommentPicDataArray;
}

- (NSMutableArray *)wonderfulPicDataArray
{
    if (!_wonderfulPicDataArray) {
        _wonderfulPicDataArray = [[NSMutableArray alloc] init];
    }
    return _wonderfulPicDataArray;
}

- (NSMutableArray *)picNameArray
{
    if (!_picNameArray) {
        _picNameArray = [[NSMutableArray alloc] init];
    }
    return _picNameArray;
}

#pragma mark -点击segment

- (void)segmentControlAction:(UISegmentedControl *)segment
{
    [SVProgressHUD dismiss];
    [self.tableView footerEndRefreshing];
    [self.tableView headerEndRefreshing];
    switch (segment.selectedSegmentIndex) {
        case 0:
        {
            if (self.classicPicDataArray.count < 2) {
                [self reloadDataClassocAndJson];
            }
        }
            break;
            
        case 1:
        {
            if (self.recommentPicDataArray.count < 2) {
                [self reloadRecommentDataAndJson];
            }
        }
            break;
            
        case 2:
        {
            if (self.wonderfulPicDataArray.count < 2) {
                [self reloadWonderfulDataAndJson];
            }
        }
            break;
            
        default:
            break;
    }
    
    [self.tableView reloadData];
}





#pragma mark - 页面设置

- (void)setUpNavigationBar
{
    self.segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"经典",@"推荐",@"精彩"]];
    self.segmentControl.frame = CGRectMake(0, 0, 180, 30);
    self.segmentControl.selectedSegmentIndex = 0;
    [self.segmentControl addTarget:self action:@selector(segmentControlAction:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = self.segmentControl;
}

- (void)setUpTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundView = kBlurView;
    
    [self.tableView registerClass:[PictureTableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    //上拉加载更多
    [self.tableView addFooterWithTarget:self action:@selector(footerRefreshingMoreData)];
    //下拉刷新数据
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefreshingNewData)];
    
    [self.view addSubview:self.tableView];
}


//添加手势
- (void)setUpSwipeGestureRecognizer
{
    //左扫
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeAction:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.leftSlideVC.pan requireGestureRecognizerToFail:leftSwipe]; //解决手势冲突
    
    [self.view addGestureRecognizer:leftSwipe];
    
    //右扫
    UISwipeGestureRecognizer * rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeAction:)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    
    
    [tempAppDelegate.leftSlideVC.pan requireGestureRecognizerToFail:rightSwipe];   //解决手势冲突
    
    [self.view addGestureRecognizer:rightSwipe];
}

//左扫事件
- (void)leftSwipeAction:(UISwipeGestureRecognizer *)leftSwipe
{
  
    NSInteger temp = (NSInteger)self.segmentControl.selectedSegmentIndex;
    
    temp += 1;
    
    if (2 < temp) {
        self.segmentControl.selectedSegmentIndex = 0;
    }
    self.segmentControl.selectedSegmentIndex = temp;
    [self segmentControlAction:self.segmentControl];
}

//右扫事件
- (void)rightSwipeAction:(UISwipeGestureRecognizer *)rightSwipe
{

    self.segmentControl.selectedSegmentIndex -= 1;
    if (0 > self.segmentControl.selectedSegmentIndex) {
        self.segmentControl.selectedSegmentIndex = 2;
    }
    [self segmentControlAction:self.segmentControl];
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



- (void)viewWillAppear:(BOOL)animated
{
    self.tableView.backgroundView = kBlurView;
    
    [self segmentControlAction:self.segmentControl];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self reloadDataClassocAndJson];
    
    [self setUpNavigationBar];
    
    [self setUpTableView];
    
    [self setUpSwipeGestureRecognizer];
    
    [self setupBackToTopButton];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
    [self.tableView footerEndRefreshing];
    [self.tableView headerEndRefreshing];
    [super viewWillDisappear:animated];
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

#pragma mark -number of rows

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (self.segmentControl.selectedSegmentIndex) {
        case 0:
        {
            return self.classicPicDataArray.count;
        }
            break;
            
        case 1:
        {
            return self.recommentPicDataArray.count;
        }
            break;
            
        case 2:
        {
            return self.wonderfulPicDataArray.count;
        }
            break;
            
        default: return 20;
            break;
    }
    
    
}


#pragma mark -number of secton

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


#pragma mark -height of rows

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.segmentControl.selectedSegmentIndex) {
        case 0:
        {
            PictureModel *model = self.classicPicDataArray[indexPath.row];
            return [self cellHeightForTitle:model.title WidthStr:model.pic_w HeightStr:model.pic_h];
        }
            break;
            
        case 1:
        {
            PictureModel *model = self.recommentPicDataArray[indexPath.row];
            return [self cellHeightForTitle:model.title WidthStr:model.pic_w HeightStr:model.pic_h];
        }
            break;

        case 2:
        {
            PictureModel *model = self.wonderfulPicDataArray[indexPath.row];
            return [self cellHeightForTitle:model.title WidthStr:model.pic_w HeightStr:model.pic_h];
            
        }
            break;
            
        default: return 50;
            break;
    }
}

- (CGFloat)cellHeightForTitle:(NSString *)title WidthStr:(NSString *)widthStr HeightStr:(NSString *)heightStr
{
    float heightOfPic = [heightStr floatValue] * kLengthOfMainPicture / [widthStr floatValue];
    float heightOftitle = [self getHeightWithString:title Width:kLengthOfTitle Font:kFontOfTitle];
    if (heightOftitle < 35) {
        heightOftitle = 35;
    }
    return heightOftitle + heightOfPic + kHeightOfCollectButton + kHeightOfTimeLabel + 30;
}


#pragma mark -height For section

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}


#pragma mark -设置cell

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.segmentControl.selectedSegmentIndex) {
        case 0:
        {
            PictureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
            PictureModel *model = self.classicPicDataArray[indexPath.row];
            
            return [self setUpPictureTableViewCell:cell PicModel:model IndexPath:indexPath];
        }
            break;
            
        case 1:
        {
            PictureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
            PictureModel *model = self.recommentPicDataArray[indexPath.row];
            
            return [self setUpPictureTableViewCell:cell PicModel:model IndexPath:indexPath];
        }
            break;
            
        case 2:
        {
            PictureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
            PictureModel *model = self.wonderfulPicDataArray[indexPath.row];
            
            return [self setUpPictureTableViewCell:cell PicModel:model IndexPath:indexPath];
        }
            break;
            
        default: return nil;
            break;
    }
    
    
}

- (PictureTableViewCell *)setUpPictureTableViewCell:(PictureTableViewCell *)cell PicModel:(PictureModel *)model IndexPath:(NSIndexPath *)indexPath
{
    cell.timeLabel.text = model.timeStr;
    cell.titleLabel.text = model.title;
    [cell.mainImageView sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:[UIImage imageNamed:@"loadingPic00"]];
    
   
    //自适应 题目高度
    cell.titleLabel.height = [self getHeightWithString:model.title Width:kLengthOfTitle Font:cell.titleLabel.font];
    if (cell.titleLabel.height < 35) {
        cell.titleLabel.height = 35;
    }
    
    
    // 图片高度 根据给定的比例设置
    cell.mainImageView.top = cell.titleLabel.top + cell.titleLabel.height;
    float heightOfPic = [model.pic_h floatValue] * kLengthOfMainPicture / [model.pic_w floatValue];
    cell.mainImageView.height = heightOfPic;
    //背景 高度
    cell.backView.height = cell.titleLabel.height + cell.mainImageView.height + kHeightOfCollectButton + kHeightOfTimeLabel + 10;
    cell.bottomView.top = cell.mainImageView.bottom;
    
    //按钮图片
    if ([[FunnyTimeDataBase shareFunnyTimeDataBase] isExistPictureModel:model]) {
        [cell.collectButton setImage:[UIImage imageNamed:@"isCollectedIcon_32.png"] forState:UIControlStateNormal];
    }else{
        [cell.collectButton setImage:[UIImage imageNamed:@"unCollectedIcon_32.png"] forState:UIControlStateNormal];
    }
    
    //按钮 点击
    cell.collectBigButton.tag = 1000 + indexPath.row;
    [cell.collectBigButton addTarget:self action:@selector(collectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.shareBigButton.tag = 4400 + indexPath.row;
    [cell.shareBigButton addTarget:self action:@selector(showPicShareActionSheet:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}


- (CGFloat)getHeightWithString:(NSString *)str Width:(CGFloat)width Font:(UIFont *)font
{
    CGRect rect = [str boundingRectWithSize:CGSizeMake(width, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName] context:nil];
    return rect.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PictureModel *model = nil;
    
    switch (self.segmentControl.selectedSegmentIndex) {
        case 0:
        {
            model = self.classicPicDataArray[indexPath.row];
        }
            break;
            
        case 1:
        {
            model = self.recommentPicDataArray[indexPath.row];
        }
            break;
            
        case 2:
        {
            model = self.wonderfulPicDataArray[indexPath.row];
        }
            break;
            
        default:
            break;
    }
    
    [self showDetailPicWithPicModel:model indexPath:indexPath];

}

- (void)showDetailPicWithPicModel:(PictureModel *)model indexPath:(NSIndexPath *)indexPath
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    PicDetailViewController *detailVC = [[PicDetailViewController alloc] init];
    detailVC.picHeight = [model.pic_h floatValue];
    detailVC.picWidth = [model.pic_w floatValue];
    detailVC.picURLStr = model.pic;
    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    [imageView sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:[UIImage imageNamed:@"loadingPic00"]];
//    detailVC.detailImage = imageView.image;
    
    [delegate.window.rootViewController presentViewController:detailVC animated:YES completion:nil];
}


#pragma mark - 点击分享

- (void)showPicShareActionSheet:(UIButton *)button
{
    NSInteger index = button.tag - 4400;
    
    switch (self.segmentControl.selectedSegmentIndex) {
        case 0:
        {
           PictureModel *model = self.classicPicDataArray[index];
            [self shareWithPictureModel:model View:button];
        }
            break;
            
        case 1:
        {
            PictureModel *model = self.recommentPicDataArray[index];
            [self shareWithPictureModel:model View:button];
        }
            break;
            
        case 2:
        {
            PictureModel *model = self.wonderfulPicDataArray[index];
            [self shareWithPictureModel:model View:button];
        }
            break;
            
        default:
            break;
    }
}

- (void)shareWithPictureModel:(PictureModel *)model View:(UIView *)view
{
//    self.model = model;
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [UMSocialSnsService presentSnsController:delegate.window.rootViewController appKey:kUMAppkey shareText:model.title shareImage:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.pic]] shareToSnsNames:kShareToSnsNames delegate:self];
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = model.pic;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = model.title;
}


#pragma mark - 点击收藏

- (void)collectButtonAction:(UIButton *)button
{
    
    NSInteger index = button.tag - 1000;
    
    switch (self.segmentControl.selectedSegmentIndex) {
        case 0:
        {
            PictureModel *model = self.classicPicDataArray[index];
            [self collectOrDeletePictureModel:model];
        }
            break;
            
        case 1:
        {
            PictureModel *model = self.recommentPicDataArray[index];
            [self collectOrDeletePictureModel:model];
        }
            break;
            
        case 2:
        {
            PictureModel *model = self.wonderfulPicDataArray[index];
            [self collectOrDeletePictureModel:model];
        }
            break;
            
        default:
            break;
    }

    
    [self.tableView reloadData];
}

//每次点击,收藏或者删除
- (void)collectOrDeletePictureModel:(PictureModel *)model
{
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"收藏" message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    
    CollectionView *collectiongAlert = [[CollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    //每次点击时,图片已经收藏,删除收藏
    if ([[FunnyTimeDataBase shareFunnyTimeDataBase] isExistPictureModel:model]) {
        [[FunnyTimeDataBase shareFunnyTimeDataBase] deletePictureModel:model];
//        alertView.title = @"取消收藏";
        
        [collectiongAlert setCollectionWithImageName:@"ppq_like@3x.png" title:@"取消收藏"];
        [self.view addSubview:collectiongAlert];
        
    }else{  //每次点击时,图片没有收藏,收藏
        [[FunnyTimeDataBase shareFunnyTimeDataBase] insertPictureCollectionWithPictureModel:model];
//        alertView.title = @"收藏成功";
        
        [collectiongAlert setCollectionWithImageName:@"ppq_like_f@3x.png" title:@"收藏成功"];
        [self.view addSubview:collectiongAlert];
    }
    
//    [self performSelector:@selector(dismissAlertView:) withObject:alertView afterDelay:0.5];
//    [alertView show];
    
    [self performSelector:@selector(dismissCollectionAlert:) withObject:collectiongAlert afterDelay:0.5];
}

- (void)dismissCollectionAlert:(CollectionView *)collectionView
{
    [collectionView removeFromSuperview];
}

#pragma mark -解析数据

//去除重复图片的方法
- (BOOL)isHaveSamePicModel:(PictureModel *)model
{
    if (self.picNameArray.count == 0) {     //还没有数据，新增
        [self.picNameArray addObject:model.title];
        return NO;
    }else{
        BOOL isHaveSame = NO;
        //遍历，看是否有重复
        for (NSString *aTitle in self.picNameArray) {
            if ([aTitle isEqualToString:model.title]) {
                isHaveSame = YES;
            }
        }
        
        //有重复，返回Yes，否则，新增
        if (isHaveSame) {
            return YES;
        }else{
            [self.picNameArray addObject:model.title];
            return NO;
        }
    }
    
    
    return NO;
}

//加载 经典
- (void)reloadDataClassocAndJson
{
    //断网提醒
    [[NetMoniter sharedClient] checkNetWork];
    
    [SVProgressHUD showWithStatus:@"正在加载..."];
    [LORequestManger GET:kClassicFunnyPicForBeginURL success:^(id response) {
        NSDictionary *sourceDic = (NSDictionary *)response;
        
        for (NSDictionary *dic in sourceDic[@"rows"]) {
            PictureModel *model = [PictureModel pictureModelWithDictionary:dic];
            model.collectionType = [NSString stringWithFormat:@"%zi",self.segmentControl.selectedSegmentIndex];
            
            if (![self isHaveSamePicModel:model]) {
                [self.classicPicDataArray addObject:model];
            }
            
        }
        
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self networkErrorActionWithError:error];
    }];
    
    
}


//加载 推荐
- (void)reloadRecommentDataAndJson
{
    //断网提醒
    [[NetMoniter sharedClient] checkNetWork];
    
    [SVProgressHUD showWithStatus:@"正在加载..."];
    [LORequestManger GET:kRecommentPicForBeginURL success:^(id response) {
        
        NSDictionary *sourceDic = (NSDictionary *)response;
        
        for (NSDictionary *dic in sourceDic[@"rows"])
        {
            PictureModel *model = [PictureModel pictureModelWithDictionary:dic];
            model.collectionType = [NSString stringWithFormat:@"%zi",self.segmentControl.selectedSegmentIndex];
            //有一个nativeAD反复出现,舍弃
            if (![model.ID isEqualToString:@"native_ad"]) {
                
                if (![self isHaveSamePicModel:model]) {
                    [self.recommentPicDataArray addObject:model];
                }
                
            }
            
            

        }
        
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self networkErrorActionWithError:error];
    }];
}


//加载 精彩
- (void)reloadWonderfulDataAndJson
{
    //断网提醒
    [[NetMoniter sharedClient] checkNetWork];
    
    [SVProgressHUD showWithStatus:@"正在加载..."];
    [LORequestManger GET:kWonderfulPicForBeginRUL success:^(id response) {
        NSDictionary *sourceDic = (NSDictionary *)response;
        for (NSDictionary *dic in sourceDic[@"items"]) {
           
            PictureModel *model = [PictureModel pictureModelWithDictionary:dic];
            model.collectionType = [NSString stringWithFormat:@"%zi",self.segmentControl.selectedSegmentIndex];
            
            if (![self isHaveSamePicModel:model]) {
                [self.wonderfulPicDataArray addObject:model];
            }
            
            
        }
        
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self networkErrorActionWithError:error];
    }];
}


#pragma mark - 上拉加载更多

- (void)footerRefreshingMoreData
{
    switch (self.segmentControl.selectedSegmentIndex) {
        case 0:
        {
            [self reloadMoreClassicPicData];
        }
            break;
            
        case 1:
        {
            [self reloadMoreRecommentData];
        }
            break;
            
        case 2:
        {
            [self reloadMoreWonderfulData];
        }
            break;
            
        default:
            break;
    }

}

//更多 经典
- (void)reloadMoreClassicPicData
{
    
    PictureModel *classicModel = [self.classicPicDataArray lastObject];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kClassicFunnyPicForMoreURL,classicModel.cTime];
    
    [LORequestManger GET:urlStr success:^(id response) {
        NSArray *sourceArray = (NSArray *)response;
        
        for (NSDictionary *dic in sourceArray) {
            PictureModel *model = [PictureModel pictureModelWithDictionary:dic];
            model.collectionType = [NSString stringWithFormat:@"%zi",self.segmentControl.selectedSegmentIndex];
            //去重
            if (![self isHaveSamePicModel:model]) {
                [self.classicPicDataArray addObject:model];
            }
            
        }
        
        //重新加载数据,结束上拉加载更多
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.tableView footerEndRefreshing];
            
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self networkErrorActionWithError:error];
    }];
    
    
}

//更多 推荐
- (void)reloadMoreRecommentData
{
    PictureModel *recommentModel = [self.recommentPicDataArray lastObject];
    NSString *urlStr = [kRecommentPicForMoreURL stringByAppendingString:recommentModel.cTime];
    
    [LORequestManger GET:urlStr success:^(id response) {
        NSArray *sourceArray = (NSArray *)response;
        
        for (NSDictionary *dic in sourceArray) {
            PictureModel *model = [PictureModel pictureModelWithDictionary:dic];
            model.collectionType = [NSString stringWithFormat:@"%ld",(long)self.segmentControl.selectedSegmentIndex];
            //有一个nativeAD反复出现,舍弃
            if (![model.ID isEqualToString:@"native_ad"]) {
                
                //去重
                if (![self isHaveSamePicModel:model]) {
                    [self.recommentPicDataArray addObject:model];
                }
                
            }
            
           
            
        }
        
        //重新加载数据,结束上拉加载更多
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.tableView footerEndRefreshing];
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self networkErrorActionWithError:error];
    }];
}

//更多 精彩
- (void)reloadMoreWonderfulData
{
    PictureModel *wonderfulModel = [self.wonderfulPicDataArray lastObject];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@%@",kWonderfulPicForMorePartOneURL,wonderfulModel.cTime,kWonderfulPicForMorePartTwoURL];
    
    [LORequestManger GET:urlStr success:^(id response) {
        NSDictionary *soureDic = (NSDictionary *)response;
        
        for (NSDictionary *dic in soureDic[@"items"]) {
            PictureModel *model = [PictureModel pictureModelWithDictionary:dic];
            model.collectionType = [NSString stringWithFormat:@"%ld",(long)self.segmentControl.selectedSegmentIndex];
            
            //去重
            if (![self isHaveSamePicModel:model]) {
                
                [self.wonderfulPicDataArray addObject:model];
            }
            
        }
        
        //重新加载数据,结束上拉加载更多
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.tableView footerEndRefreshing];
            
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self networkErrorActionWithError:error];
    }];
    
}


#pragma mark - 下拉刷新数据

- (void)headerRefreshingNewData
{
    switch (self.segmentControl.selectedSegmentIndex) {
        case 0:
        {
            [self headerReloadDataWithArray:self.classicPicDataArray URLString:kClassicFunnyPicForBeginURL];
        }
            break;
            
        case 1:
        {
            [self headerReloadDataWithArray:self.recommentPicDataArray URLString:kRecommentPicForBeginURL];
        }
            break;
            
        case 2:
        {
            
            [self headerReloadDataWithArray:self.wonderfulPicDataArray URLString:kWonderfulPicForBeginRUL];
        }
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

            NSMutableArray *tempArray;
            
            if (self.segmentControl.selectedSegmentIndex == 2) {
                tempArray = [NSMutableArray arrayWithArray:sourceDic[@"items"]];
            }else{
                tempArray = [NSMutableArray arrayWithArray:sourceDic[@"rows"]];
            }
            
            BOOL isInsertSuccessed = NO; //判断是否有数据更新
            
            //如果新来的数据最后一个时间戳比原来的数据第一个时间戳还要大,就移除所有旧数据,重新加载
            
            PictureModel *lastModelOfNewData = [PictureModel pictureModelWithDictionary:[tempArray lastObject]];
            PictureModel *firstModelOfOldData = [dataArray firstObject];
            
            if ([lastModelOfNewData.cTime floatValue] > [firstModelOfOldData.cTime floatValue]) {
                
                [dataArray removeAllObjects];
                for (NSDictionary *dic in tempArray) {
                    PictureModel *model = [PictureModel pictureModelWithDictionary:dic];
                    model.collectionType = [NSString stringWithFormat:@"%zi",self.segmentControl.selectedSegmentIndex];
                    
                    //去重
                    if (![self isHaveSamePicModel:model]) {
                        
                        [dataArray addObject:model];
                    }
                }
                
                isInsertSuccessed = YES;
                
            }else{
                //如果新来的数据最后一个时间戳小于原来的数据第一个时间戳
                //正常下拉刷新数据
                
                for (int i = (int)(tempArray.count - 1); i >= 0; i--)
                {
                    NSDictionary *dic = tempArray[i];
                    
                    PictureModel *newModel = [PictureModel pictureModelWithDictionary:dic];
                    newModel.collectionType = [NSString stringWithFormat:@"%zi",self.segmentControl.selectedSegmentIndex];
                    
                    float maxTimeStamp = 0.0;  //数组里最大的时间戳
                    
                    for (PictureModel *tempModel in dataArray)
                    {
                        maxTimeStamp = [tempModel.cTime floatValue] > maxTimeStamp ? [tempModel.cTime floatValue] : maxTimeStamp;
                    }
                    
                    //新的数据时间戳比数组里的都大,插入数据 到最前面
                    if ([newModel.cTime floatValue] > maxTimeStamp && !([newModel.ID isEqualToString:@"native_ad"]))
                    {
                        
                        //去重
                        if (![self isHaveSamePicModel:newModel]) {
                            
                            [dataArray insertObject:newModel atIndex:0];
                            isInsertSuccessed = YES;
                            NSLog(@"刷新成功============");
                        }
                    }
                }
            }

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                //如果没有更新,给个提示
                if (isInsertSuccessed) {
                    NSLog(@"刷新成功");
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


#pragma mark - 网络错误执行的方法

- (void)networkErrorActionWithError:(NSError *)error
{
    NSLog(@"%@",error);
    
    //刷新提示消失
    [SVProgressHUD dismiss];
    [self.tableView headerEndRefreshing];
    [self.tableView footerEndRefreshing];
    
//    //提示
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
}



@end
