//
//  LeftSettingViewController.m
//  FunnyTime
//
//  Created by luxt on 15/9/23.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import "LeftSettingViewController.h"

//#import "PicCollectionListTableViewController.h"
#import "JokesCollectionDetailViewController.h"

#import "VoiceCollectionListTableViewController.h"
#import "AppDelegate.h"

#import "VideoCollcetionTableViewController.h"

#import "SettingBackgroundBlurViewController.h"
#import "FeedBackViewController.h"

#import "UINavigationController+InterfaceOrientation.h"

#import "PicNewCollectionListTableViewController.h"

@interface LeftSettingViewController ()<UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate>

@end

@implementation LeftSettingViewController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation

{
    
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
    
}

- (NSUInteger)supportedInterfaceOrientations {
    
    return 0;
}
- (BOOL)shouldAutorotate {
    return NO;
}

- (void)viewWillAppear:(BOOL)animated
{
//    NSLog(@"viewWillAppear");
//    [self.tableView reloadData];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.tableView = [[UITableView alloc] init];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    self.tableView.bounces = NO;
    
    //背景图
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    imageView.image = [UIImage imageNamed:@"leftbackiamge"];
//    self.tableView.backgroundView = imageView;
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    //表头是一个透明视图
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 70)];
    headerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = headerView;
    
    [self.view addSubview:self.tableView];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self.tableView selector:@selector(reloadData) name:@"openLeftView" object:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (0 == section) {
        return 4;
    }else{
        return 3;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *Identifier = @"Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //附件属性
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    if (0 == indexPath.section) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"段子";
                break;
            case 1:
                cell.textLabel.text = @"图片";
                break;
                
            case 2:
                cell.textLabel.text = @"视频";
                break;
                
            case 3:
                cell.textLabel.text = @"声音";
                break;
                
            default:
                break;
        }
    }else if(1 == indexPath.section){
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"一键换肤";
                break;
            case 1:
                cell.textLabel.text = @"意见反馈";
                break;
            case 2:{
                
                cell.textLabel.text = [NSString stringWithFormat:@"清除缓存"];
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
                break;
                
            default:
                break;
        }

    }
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 50)];
    view.backgroundColor = [UIColor clearColor];
    
    //标题
    UILabel *sectionView = [[UILabel alloc] initWithFrame:CGRectMake(15,  25, 100, 25)];
    if (0 == section) {
        sectionView.text = @"我的收藏";
    }else{
        sectionView.text = @"设置";
    }
    
    sectionView.font = [UIFont systemFontOfSize:18];
    sectionView.textColor = [UIColor whiteColor];
//    sectionView.backgroundColor = [UIColor redColor];
    [view addSubview:sectionView];
    
    //白线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, sectionView.bottom, self.tableView.bounds.size.width - 40, 0.5)];
    lineView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.650];
    [view addSubview:lineView];
    
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
        switch (indexPath.row) {
            case 0:
            {
                JokesCollectionDetailViewController *jokesCDVC = [[JokesCollectionDetailViewController alloc] init];
                jokesCDVC.title = @"段子收藏列表";
               
                //jokesCDVC.modalPresentationStyle = UIModalPresentationCurrentContext;
                [delegate.window.rootViewController presentViewController:[[UINavigationController alloc] initWithRootViewController:jokesCDVC] animated:YES completion:nil];
                
            }
                break;
            case 1:{
                
                PicNewCollectionListTableViewController *picColletVC = [[PicNewCollectionListTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
                picColletVC.title = @"图片收藏列表";
                [delegate.window.rootViewController presentViewController:[[UINavigationController alloc] initWithRootViewController:picColletVC] animated:YES completion:nil];
            }
                break;
                
            case 2:{
                VideoCollcetionTableViewController *videoCollectionVC = [[VideoCollcetionTableViewController alloc ] init];
                videoCollectionVC.title = @"视频收藏列表";
                UINavigationController *videoCollectionNaVC = [[UINavigationController alloc] initWithRootViewController:videoCollectionVC];
                
                [delegate.window.rootViewController presentViewController:videoCollectionNaVC animated:YES completion:nil];
            }
                break;
                
            case 3:{
                
                VoiceCollectionListTableViewController *voiceCollectionVC = [[VoiceCollectionListTableViewController alloc] init];
                voiceCollectionVC.title = @"声音收藏列表";
                [delegate.window.rootViewController presentViewController:[[UINavigationController alloc] initWithRootViewController:voiceCollectionVC] animated:YES completion:nil];
            }
                break;
            default:
                break;
        }

    }
    
    if (1 == indexPath.section) {
        
        switch (indexPath.row) {
            case 0:
            {
                SettingBackgroundBlurViewController *settingBackVC = [[SettingBackgroundBlurViewController alloc] init];
                settingBackVC.title = @"一键换肤";
                [delegate.window.rootViewController presentViewController:[[UINavigationController alloc] initWithRootViewController:settingBackVC]  animated:YES completion:nil];
            }
                break;
                
            case 1:
            {
                FeedBackViewController *feedBackVC = [[FeedBackViewController alloc] init];
                feedBackVC.title = @"意见反馈";
                UINavigationController *feedBackNVC = [[UINavigationController alloc] initWithRootViewController:feedBackVC];
//                feedBackNVC.navigationBar.height = 64;
                [delegate.window.rootViewController presentViewController:feedBackNVC animated:YES completion:nil];
                
            }
                break;
                
                case 2:
            {

                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定清除缓存吗？" message:[NSString stringWithFormat:@"当前缓存 %.2fM",((float)[[SDImageCache sharedImageCache] getSize] / 1000000)] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                
                [alert show];
                
            }
                break;
                
            default:
                break;
        }
        
    }
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        [[SDImageCache sharedImageCache] cleanDisk];
        [[SDImageCache sharedImageCache] clearMemory];
        [SVProgressHUD showSuccessWithStatus:@"已经清除缓存"];
        
        //取得文件路径 com.hackemist.SDWebImageCache.default
        NSString *cacheP = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, 1, 1) lastObject];
        NSString *imagesPath = [cacheP stringByAppendingPathComponent:@"com.hackemist.SDWebImageCache.default"];
        //删除
        [[NSFileManager defaultManager] removeItemAtPath:imagesPath error:nil];
        
        [self performSelector:@selector(dismissHUD) withObject:self afterDelay:1.0];
        [self.tableView reloadData];
        
    }
}


- (void)dismissHUD
{
    [SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
