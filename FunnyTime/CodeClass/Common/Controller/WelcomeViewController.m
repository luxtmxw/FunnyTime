//
//  WelcomeViewController.m
//  FunnyTime
//
//  Created by luxt on 15/10/7.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import "WelcomeViewController.h"
#import "WelcomeView.h"


@interface WelcomeViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) WelcomeView *welcomeView;
@property (nonatomic) BOOL isOut;

@end

@implementation WelcomeViewController

//仅仅支持竖屏
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

//不允许自动旋转屏幕
- (BOOL)shouldAutorotate
{
    return NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *nameArray = @[@"jock1.png",@"pic1.png",@"video1.png",@"voice1.png",@"star1.png"];
    self.welcomeView = [[WelcomeView alloc] initWithFrame:[UIScreen mainScreen].bounds target:self enterButtonAction:@selector(enterButtonAction) imageNameArray:nameArray];
    self.welcomeView.scrollView.delegate = self;
    [self.welcomeView.pageControl addTarget:self action:@selector(pageConctrolAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.welcomeView];
    
}

- (void)pageConctrolAction:(UIPageControl *)pageControl
{
    self.welcomeView.scrollView.contentOffset = CGPointMake(kScreenWidth * pageControl.currentPage, self.welcomeView.scrollView.contentOffset.y);
}

- (void)enterButtonAction
{
    [self goinMain];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.welcomeView.scrollView.contentOffset.x > (4 * kScreenWidth + 30)) {
        self.isOut = YES;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.welcomeView.pageControl.currentPage = (NSInteger)(self.welcomeView.scrollView.contentOffset.x / kScreenWidth);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.isOut) {
        [self goinMain];
    }
}

- (void)goinMain
{
    [UIView animateWithDuration:0.5 animations:^{
        self.welcomeView.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        //记录 第一次进入程序
        [[NSUserDefaults standardUserDefaults] setObject:@"First" forKey:@"firstLaunch"];
        //发通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"launchApp" object:nil];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
