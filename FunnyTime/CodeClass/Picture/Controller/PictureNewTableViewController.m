//
//  PictureNewTableViewController.m
//  FunnyTime
//
//  Created by luxt on 15/10/23.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import "PictureNewTableViewController.h"
#import "PictureModel.h"
#import "MJRefresh.h"
#import "PictureTableViewCell.h"
#import "AppDelegate.h"
#import "PicDetailViewController.h"

@interface PictureNewTableViewController ()<UMSocialUIDelegate>

@property (nonatomic, strong) NSMutableArray *dataNewPicArray;
@property (nonatomic, strong) UIButton *backToTop;
@end

@implementation PictureNewTableViewController

- (NSMutableArray *)dataNewPicArray
{
    if (!_dataNewPicArray) {
        _dataNewPicArray = [[NSMutableArray alloc] init];
    }
    return _dataNewPicArray;
}

#pragma mark - 加载数据

- (void)firstReloadNewPicAndJson
{
    [SVProgressHUD showWithStatus:@"正在加载..."];
    [self reloadNewPicAndJson];
}

//加载数据
- (void)reloadNewPicAndJson
{
    
    [[NetMoniter sharedClient] checkNetWork];//断网提醒
    
    NSString *urlStr = [NSString stringWithFormat:kNewPicURL,[self calculateTimestamp]];
    
    [LORequestManger GET:urlStr success:^(id response) {
        NSArray *sourceArray = (NSArray *)response;
        
        for (NSDictionary *dic in sourceArray) {
            PictureModel *model = [PictureModel NewPictureModelWithMainDictionary:dic ImageDic:dic[@"Pic"]];
            
            if ([model.title isEqualToString:@"从前的味道！"] || dic[@"Pic"] == nil || [model.title isEqualToString:@"这广告不错！"] || [model.title isEqualToString:@"大婶你笑啥呢"] || [model.title isEqualToString:@"好吧我邪恶了"]) {
                
            }else{
                [self.dataNewPicArray addObject:model];
            }
   
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView headerEndRefreshing];
            [self.tableView reloadData];
            [SVProgressHUD dismiss];
        });
  
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self networkErrorActionWithError:error];
    }];
  
}

//计算时间戳
- (NSString *)calculateTimestamp {
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *timestamp = [NSString stringWithFormat:@"%d", (int)time];
    return timestamp;
}

- (void)networkErrorActionWithError:(NSError *)error
{
    NSLog(@"%@",error);
    
    [SVProgressHUD dismiss];//刷新提示消失
    
    [self.tableView headerEndRefreshing];
    [self.tableView footerEndRefreshing];
    
}

#pragma mark - 加载页面

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self firstReloadNewPicAndJson];
    
    [self.tableView registerClass:[PictureTableViewCell class] forCellReuseIdentifier:@"newPIcCell"];
    
    self.tableView.backgroundView = kBlurView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self setupBackToTopButton];
    
    //上拉刷新
    [self.tableView addHeaderWithTarget:self action:@selector(reloadNewPicAndJson)];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.tableView.backgroundView = kBlurView;
    
    [super viewWillAppear:animated];
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
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataNewPicArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PictureModel *model = self.dataNewPicArray[indexPath.row];
    return [self cellHeightForTitle:model.title WidthStr:model.pic_w HeightStr:model.pic_h];
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

#pragma mark - 设置cell

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PictureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newPIcCell" forIndexPath:indexPath];
    
    PictureModel *model = self.dataNewPicArray[indexPath.row];
    
    return [self setUpPictureTableViewCell:cell PicModel:model IndexPath:indexPath];
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

#pragma mark - 点击分享

- (void)showPicShareActionSheet:(UIButton *)button
{
    NSInteger index = button.tag - 4400;
    PictureModel *model = self.dataNewPicArray[index];
    [self shareWithPictureModel:model View:button];
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
    PictureModel *model = self.dataNewPicArray[index];
    [self collectOrDeletePictureModel:model];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PictureModel *model = self.dataNewPicArray[indexPath.row];
    
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


@end
