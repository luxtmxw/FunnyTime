//
//  SettingBackgroundBlurViewController.m
//  FunnyTime
//
//  Created by luxt on 15/10/6.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import "SettingBackgroundBlurViewController.h"
#import "SettingBackgroundBlurCollectionViewCell.h"

@interface SettingBackgroundBlurViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *imageNameArray;
@property (nonatomic, strong) UICollectionView *collection;

@end

@implementation SettingBackgroundBlurViewController

- (NSUInteger)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
}
- (BOOL)shouldAutorotate {
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigation];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 20;
    layout.itemSize = CGSizeMake(kScreenWidth / 4, 100);
    
    self.collection = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
    self.collection.height = kScreenHeight - 44;
    self.collection.dataSource = self;
    self.collection.delegate = self;
    
    [self.collection registerClass:[SettingBackgroundBlurCollectionViewCell class] forCellWithReuseIdentifier:@"collectionCell"];
    
    self.collection.backgroundView = kBlurView;
    
    self.imageNameArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 21; i++) {
        NSString *name = [NSString stringWithFormat:@"BackGroundBlurImageView0%0.2d.png",i];
        [self.imageNameArray addObject:name];
    }
    
    [self.view addSubview:self.collection];
    
    
}

- (void)setNavigation
{
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = left;
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageNameArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SettingBackgroundBlurCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    NSString *currentImageName = [[NSUserDefaults standardUserDefaults] objectForKey:@"changeBackground"];
    if ([currentImageName isEqualToString:self.imageNameArray[indexPath.item]]) {
        cell.forePicView.hidden = NO;
    }else{
        cell.forePicView.hidden = YES;
    }
    
    NSArray *nameArray = @[@"天空蓝", @"静静听", @"羽毛浴",
                           @"大红袍", @"橘子橙", @"小猪猪",
                           @"坚持吧", @"梦幻球", @"杉树纹",
                           @"七彩虹", @"钻石吧", @"牡丹花",
                           @"蝴蝶结", @"青草绿", @"海水蓝",
                           @"小红星", @"浅蓝色", @"大气球",
                           @"小猴子", @"小菊花", @"小狐狸"];
    cell.nameLabel.text = nameArray[indexPath.item];
    
    cell.picView.image = [UIImage imageNamed:self.imageNameArray[indexPath.item]];
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets edge = {40,20,20,20};
    return edge;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSUserDefaults standardUserDefaults] setObject:self.imageNameArray[indexPath.item] forKey:@"changeBackground"];
    self.collection.backgroundView = kBlurView;
    [self.collection reloadData];
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"huanfu" object:nil];
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
