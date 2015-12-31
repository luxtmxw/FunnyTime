//
//  RecommentPicCollectionTableViewController.m
//  FunnyTime
//
//  Created by luxt on 15/10/4.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import "RecommentPicCollectionTableViewController.h"
#import "PictureTableViewCell.h"
#import "CollectionHeaderView.h"
@interface RecommentPicCollectionTableViewController ()

@property (nonatomic, strong) NSMutableArray *recommentArray;

@end

@implementation RecommentPicCollectionTableViewController
//懒加载
- (NSMutableArray *)recommentArray{
    if (!_recommentArray) {
        _recommentArray = [[NSMutableArray alloc] init];
    }
    return _recommentArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setUpNavigation];
    [self setUpTableView];
}

//- (void)setUpNavigation{
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
//    self.navigationController.navigationBar.translucent = YES;
//    self.navigationItem.title = @"推荐图片收藏详情";
//}

- (void)backButtonAction{
//    CATransition *animation = [CATransition animation];
//    animation.duration = 0.3;
//    animation.subtype = kCATransitionFromTop;
//    animation.type = @"suckEffect";
//    [self.navigationController.view.layer addAnimation:animation forKey:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setUpTableView{
    for (PictureModel *model  in [NSMutableArray arrayWithArray:[[FunnyTimeDataBase shareFunnyTimeDataBase] selectedAllPictureCollection]]) {
        if ([model.collectionType integerValue] == 1) {
            [self.recommentArray addObject:model];
        }
    }
    [self.tableView registerClass:[PictureTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    //表头
//    CollectionHeaderView *headerView = [[CollectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
//    headerView.lineView.hidden = YES;
//    headerView.titleLabel.text = @"推荐图片收藏";
//    [headerView.backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
//    self.tableView.tableHeaderView = headerView;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonAction)];
    self.navigationItem.title = @"推荐图片收藏";
    
    
    //背景模糊视图
    self.tableView.backgroundView = kBlurView;
    
    //跳到被选中的那一行
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    
    self.tableView.separatorStyle = 0;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.tableView.backgroundView = kBlurView;
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.recommentArray) {
        return self.recommentArray.count;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PictureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    PictureModel *model = self.recommentArray[indexPath.row];
    return [self setUpPictureTableViewCell:cell pictureModel:model indexPath:indexPath];
}

- (PictureTableViewCell *)setUpPictureTableViewCell:(PictureTableViewCell *)cell  pictureModel:(PictureModel *)model indexPath:(NSIndexPath *)index{
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
    cell.backView.height = cell.titleLabel.height + cell.mainImageView.height + kHeightOfTimeLabel + 10;
    cell.bottomView.top = cell.mainImageView.bottom;
    
    //按钮图片
    if ([[FunnyTimeDataBase shareFunnyTimeDataBase] isExistPictureModel:model]) {
        [cell.collectButton setImage:[UIImage imageNamed:@"isCollectedIcon_32.png"] forState:UIControlStateNormal];
    }else{
        [cell.collectButton setImage:[UIImage imageNamed:@"unCollectedIcon_32.png"] forState:UIControlStateNormal];
    }
    
    cell.bottomView.height = 0;
    cell.bottomView.hidden = YES;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            PictureModel *model = self.recommentArray[indexPath.row];
            return  [self cellHeightForTitle:model.title WidthStr:model.pic_w HeightStr:model.pic_h];
        }
            break;
            
        default: return 20;
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
    return heightOftitle + heightOfPic + kHeightOfTimeLabel + 30;
}
- (CGFloat)getHeightWithString:(NSString *)str Width:(CGFloat)width Font:(UIFont *)font
{
    CGRect rect = [str boundingRectWithSize:CGSizeMake(width, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName] context:nil];
    return rect.size.height;
}




//// 表头设置
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 80;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 50)];
//    view.backgroundColor = [UIColor clearColor];
//    
//    
//    UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 200) / 2, 2 * kDistanceOfEdge, 200, 30)];
//    sectionLabel.backgroundColor = [UIColor yellowColor];
//    sectionLabel.text = @"推荐图片收藏";
//    
//    sectionLabel.textAlignment = NSTextAlignmentCenter;
//    sectionLabel.font = [UIFont systemFontOfSize:20];
//    sectionLabel.textColor = [UIColor blackColor];
//    
//    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(kDistanceOfEdge, 4 * kDistanceOfEdge + 2, kScreenWidth - 2 * kDistanceOfEdge, 1)];
//    lineView.backgroundColor = [UIColor whiteColor];
//    [view addSubview:lineView];
//    [view addSubview:sectionLabel];
//    return view;
//}

@end
