//
//  VoicePlayListTableViewController.m
//  FunnyTime
//
//  Created by luxt on 15/9/25.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import "VoicePlayListTableViewController.h"
#import "VoicePlayListTableViewCell.h"
#import "VoicePlayListModel.h"
#import "VoicePlayViewController.h"
#import "MJRefresh.h"
#import "VoicePlayViewController.h"
#import "PlayingImageView.h"
#import "AppDelegate.h"
@interface VoicePlayListTableViewController ()

@property (nonatomic, strong) NSMutableArray *voicePlayListArray;

@end

@implementation VoicePlayListTableViewController

- (NSMutableArray *)voicePlayListArray {
    if (!_voicePlayListArray) {
        _voicePlayListArray = [[NSMutableArray alloc] init];
    }
    return _voicePlayListArray;
}

//解析播放列表
- (void)reloadVoicePlayListWithJson {
    [SVProgressHUD showWithStatus:@"正在加载"];
    NSString *url = [NSString stringWithFormat:kVoicePlayUrl, self.albumID];
    [LORequestManger GET:url success:^(id response) {
        NSDictionary *dic = (NSDictionary *)response;
        for (NSDictionary *obj in dic[@"result"][@"dataList"]) {
            VoicePlayListModel *voicePlayListModel = [VoicePlayListModel shareWithResultDic:dic[@"result"] dic:obj];
//            NSLog(@"%@",voicePlayListModel.mp3PlayUrl);
//            NSLog(@"%@",voicePlayListModel.audioDes);
            [self.voicePlayListArray addObject:voicePlayListModel];
            
        }
        
        [SVProgressHUD dismiss];
        [self.tableView reloadData];
  
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}


/**
 *  上拉加载更多
 */

- (void)footerRefreshingMoreAudioData
{
    if (self.voicePlayListArray.count > 0) {
        
        VoicePlayListModel *oneLastModel = [self.voicePlayListArray lastObject];
        if ([oneLastModel.haveNext isEqualToString:@"1"]) {
            self.tableView.footerPullToRefreshText = @"上拉可以加载更多数据";
            
            NSString *pageNum = [NSString stringWithFormat:@"%@",oneLastModel.nextPage];
            NSString *idStr = self.albumID;
            NSString *currentTimeStamp = [NSString stringWithFormat:@"%d",(int)[[NSDate date] timeIntervalSince1970]];
            NSString *newURL = [NSString stringWithFormat:kVoicePlayPull,idStr,pageNum,currentTimeStamp];
//            NSLog(@"newURL-----------%@",newURL);
//            NSLog(@"%@",newURL);
            
            [LORequestManger GET:newURL success:^(id response) {
                NSDictionary *Dict = (NSDictionary *)response;
                for (NSDictionary *dic in Dict[@"result"][@"dataList"]) {
                    VoicePlayListModel *model = [VoicePlayListModel shareWithResultDic:Dict[@"result"] dic:dic];
                    [self.voicePlayListArray addObject:model];
                    
                }
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    [self.tableView footerEndRefreshing];
                    [VoicePlayer shareVoicePlayer].modelArray = self.voicePlayListArray;    //注意更新列表
                });
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"%@",error);
            }];
  
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.tableView footerEndRefreshing];
                self.tableView.footerPullToRefreshText = @"没有数据了";
            });
        }
      }
}

/**
 *  下拉刷新
 */
- (void)headerRefreshingNewAudioData
{
    if (self.voicePlayListArray.count > 0) {
        
        VoicePlayListModel *firstModel = [self.voicePlayListArray firstObject];
        
        NSString *url = [NSString stringWithFormat:kVoicePlayUrl, self.albumID];
        [LORequestManger GET:url success:^(id response) {
            NSDictionary *dic = (NSDictionary *)response;
            
            NSArray *tempDataArray = dic[@"result"][@"dataList"];
            
            //如果新来的数据最后一个的创建时间大于当前最新的时间,移除所有旧数据,换成新的
            VoicePlayListModel *lastNewModelIntempDataArray = [VoicePlayListModel shareWithResultDic:dic[@"result"] dic:[tempDataArray lastObject]];
            
            if ([lastNewModelIntempDataArray.createTime floatValue] > [firstModel.createTime floatValue]) {
                [self.voicePlayListArray removeAllObjects];
                for (NSDictionary *obj in dic[@"result"][@"dataList"]) {
                    VoicePlayListModel *model = [VoicePlayListModel shareWithResultDic:dic[@"result"] dic:obj];
                    [self.voicePlayListArray addObject:model];
                    
                }
            }else{
                for (int i = (int)(tempDataArray.count - 1); i >= 0; i--) {
                    VoicePlayListModel *voicePlayListModel = [VoicePlayListModel shareWithResultDic:dic[@"result"] dic:tempDataArray[i]];
                    if ([voicePlayListModel.createTime floatValue] > [firstModel.createTime floatValue]) {
                        [self.voicePlayListArray insertObject:voicePlayListModel atIndex:0];
                    }
                    
                }
            }

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [self.tableView headerEndRefreshing];
                [VoicePlayer shareVoicePlayer].modelArray = self.voicePlayListArray;    //注意更新列表
            });
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];

        
    }

}

//设置导航条
- (void)setMyNavigationBar
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:(UIBarButtonItemStylePlain) target:self action:@selector(popBack)];
    PlayingImageView *playingView = [[PlayingImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 30) Target:self Action:@selector(presentPlayView)];
    if ([VoicePlayer shareVoicePlayer].isPlaying) {
        playingView.hidden = NO;
        [playingView startAnimating];
    }else{
        playingView.hidden = YES;
        [playingView stopAnimating];
        playingView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_upbar_icon_playing%d",(int)(arc4random() % 26 + 1)]];
    }
    self.navigationItem.leftBarButtonItem = backButton;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:playingView];
}

- (void)presentPlayView
{
     AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([VoicePlayer shareVoicePlayer].playViewController) {
        [delegate.window.rootViewController presentViewController:(UIViewController *)[VoicePlayer shareVoicePlayer].playViewController animated:YES completion:nil];
    }
}


- (void)popBack
{
    //动画
//    CATransition *animation = [CATransition animation];
//    animation.duration = 0.5;
//    animation.type = @"suckEffect";
//    animation.subtype = kCATransitionFromRight;
//    animation.timingFunction = UIViewAnimationCurveEaseInOut;
//    [self.navigationController.view.layer addAnimation:animation forKey:nil];
    
    [self.navigationController popViewControllerAnimated:YES];

}

//设置表头
- (UIView *)setUpheaderViewWithImageURLStr:(NSString *)imageURLStr AlbumDesc:(NSString *)albumDesc
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    //图片
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.35 * kScreenHeight)];
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:imageURLStr] placeholderImage:[UIImage imageNamed:@"loadingPic00.png"]];
    float descLabelHeight = [albumDesc boundingRectWithSize:CGSizeMake(kScreenWidth - 30, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName] context:nil].size.height;
    //介绍
    UILabel *albumDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, headerImageView.bottom, kScreenWidth - 30, descLabelHeight)];
    albumDescLabel.font = [UIFont systemFontOfSize:14];
    albumDescLabel.numberOfLines = 0;
    albumDescLabel.text = albumDesc;
    
    //白线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, albumDescLabel.bottom, kScreenWidth, 1)];
    lineView.backgroundColor = [UIColor whiteColor];
    
    headerView.height = headerImageView.height + albumDescLabel.height + lineView.height;
    
    [headerView addSubview:lineView];
    [headerView addSubview:albumDescLabel];
    [headerView addSubview:headerImageView];
    
    return headerView;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
    [self setMyNavigationBar];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置表头
    self.tableView.tableHeaderView = [self setUpheaderViewWithImageURLStr:self.albumPic AlbumDesc:self.albumDesc];
    
    //分割线
    self.tableView.separatorStyle = 0;
    
    self.tableView.backgroundView = kBlurView;
    //注册
    [self.tableView registerClass:[VoicePlayListTableViewCell class] forCellReuseIdentifier:@"voicePlayListCell"];
    [self reloadVoicePlayListWithJson];
    
    //上拉加载
    [self.tableView addFooterWithTarget:self action:@selector(footerRefreshingMoreAudioData)];
    //下拉刷新
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefreshingNewAudioData)];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.voicePlayListArray.count;
}

//设置高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 95;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VoicePlayListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"voicePlayListCell" forIndexPath:indexPath];
    VoicePlayListModel *model = self.voicePlayListArray[indexPath.row];
//    [cell setUpCellViewWithAudioName:model.audioName listenNum:model.listenNum likeNum:model.likedNum updateTime:model.updateTime orderNum:model.orderNum];
    
    cell.updateTimeLabel.text = model.updateTime;
    cell.titleLabel.text = [NSString stringWithFormat:@"第%@期 %@",model.orderNum,model.audioName]
    ;
    cell.descLabel.text = model.audioDes;
    cell.listenNumLabel.text = model.listenNum;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VoicePlayListModel *model = self.voicePlayListArray[indexPath.row];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    
    
    //同一首歌,跳转
    if ([[VoicePlayer shareVoicePlayer].voicePlayListModel.mp3PlayUrl isEqualToString:model.mp3PlayUrl]) {
        //用单例存数据
        [VoicePlayer shareVoicePlayer].voicePlayListModel = model;
        [VoicePlayer shareVoicePlayer].modelArray = self.voicePlayListArray;
        [VoicePlayer shareVoicePlayer].currentSongIndex = indexPath.row;
        [delegate.window.rootViewController presentViewController:[VoicePlayer shareVoicePlayer].playViewController animated:YES completion:nil];
    }else{  //不同的歌
         VoicePlayViewController *voicePlayVC = [[VoicePlayViewController alloc] init];
        //用单例存数据
        [VoicePlayer shareVoicePlayer].voicePlayListModel = model;
        [VoicePlayer shareVoicePlayer].modelArray = self.voicePlayListArray;
        [VoicePlayer shareVoicePlayer].currentSongIndex = indexPath.row;
        [delegate.window.rootViewController presentViewController:voicePlayVC animated:YES completion:nil];

    }
   
}

@end
