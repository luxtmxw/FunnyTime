//
//  PicDetailViewController.m
//  FunnyTime
//
//  Created by luxt on 15/10/12.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import "PicDetailViewController.h"

#import "PicDetailView.h"
@interface PicDetailViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) PicDetailView *detailView;
@end

@implementation PicDetailViewController

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
//{
//    NSLog(@"%f",kScreenWidth);
//    
//    return YES;
//}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    
    return 0;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.detailView = [[PicDetailView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    float imageViewHeight = (self.picHeight * kScreenWidth) / self.picWidth;
    
    float contentHeight = kScreenHeight;
    
    if (imageViewHeight > contentHeight) {
        contentHeight = imageViewHeight + 40;
    }

    self.detailView.scrollView.contentSize = CGSizeMake(kScreenWidth, contentHeight);
    self.detailView.scrollView.delegate = self;
    
    [self.detailView.backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    self.detailView.imageV.height = imageViewHeight;
    [self.detailView.imageV sd_setImageWithURL:[NSURL URLWithString:self.picURLStr] placeholderImage:[UIImage imageNamed:@"loadingPic00.png"]];
//    self.detailView.imageV.image = self.detailImage;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    [self.detailView addGestureRecognizer:tap];
    
    [self.view addSubview:self.detailView];
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    if (self.detailView.imageV.width < kScreenWidth) {
        scrollView.zoomScale = 1;
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.detailView.imageV;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
