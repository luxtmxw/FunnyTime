//
//  JokesCollectionDetailViewController.m
//  FunnyTime
//
//  Created by luxt on 15/9/24.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import "JokesCollectionDetailViewController.h"
#import "JokesModel.h"

#import "JokesTableViewCell.h"

#import "CollectionHeaderView.h"

@interface JokesCollectionDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

//@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) NSMutableArray *funnyJokesCollectionDetailArray;
@property (nonatomic, strong) NSMutableArray *meaningJokesCollectionDetailArray;


@end

@implementation JokesCollectionDetailViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
}

- (NSMutableArray *)funnyJokesCollectionDetailArray{
    if (!_funnyJokesCollectionDetailArray) {
        _funnyJokesCollectionDetailArray = [[NSMutableArray alloc] init];
    }
    return _funnyJokesCollectionDetailArray;
}

- (NSMutableArray *)meaningJokesCollectionDetailArray{
    if (!_meaningJokesCollectionDetailArray) {
        _meaningJokesCollectionDetailArray = [[NSMutableArray alloc] init];
    }
    return _meaningJokesCollectionDetailArray;
}

- (void)setUpTableView{
    self.view.backgroundColor = [UIColor redColor];
    
    //加载数据
    for (JokesModel *model in [NSMutableArray arrayWithArray:[[FunnyTimeDataBase shareFunnyTimeDataBase] selectedAllJokesCollection]]) {
        if ([model.collectionType intValue] == 0) {
            [self.funnyJokesCollectionDetailArray addObject:model];
        }else if ([model.collectionType intValue] == 1){
            [self.meaningJokesCollectionDetailArray addObject:model];
        }
    }
    
    //tableView
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    //表头
//    CollectionHeaderView *headerView = [[CollectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
//    [headerView.backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    self.tableView.tableHeaderView = headerView;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonAction:)];
    
   //空白表尾
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    
    
    //模糊视图
    self.tableView.backgroundView = kBlurView;
    
    
    //注册
    [self.tableView registerClass:[JokesTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.view addSubview:self.tableView];
   
}

-(void)viewWillAppear:(BOOL)animated
{
    self.tableView.backgroundView = kBlurView;
    [super viewWillAppear:animated];
}


- (void)backButtonAction:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
        {
            if (self.funnyJokesCollectionDetailArray) {
                
                if (self.funnyJokesCollectionDetailArray.count == 0) {
                    return 1;
                }else{
                    return self.funnyJokesCollectionDetailArray.count;
                }
                
            }else{
                return 1;
            }
        }
            
            
            break;
        case 1:
        {
            if (self.meaningJokesCollectionDetailArray.count == 0) {
                return 1;
            }else{
                return  self.meaningJokesCollectionDetailArray.count;
                
            }
        }
            
            break;
            
            
        default:return 1;
            break;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JokesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    switch (indexPath.section) {
            
        case 0:
        {
            if (self.funnyJokesCollectionDetailArray.count == 0) {
               
                return [self setUpJockesWhenEmptyTableViewCell:cell];
            }else{
                
                JokesModel *model = self.funnyJokesCollectionDetailArray[indexPath.row];
                return [self setUpJockesTableViewCell:cell jockesModel:model indexPath:indexPath];
                
            }

        }
            
            break;
        case 1:
        {
            if (self.meaningJokesCollectionDetailArray.count == 0) {
                
                return [self setUpJockesWhenEmptyTableViewCell:cell];
 
            }else{
                JokesModel *model = self.meaningJokesCollectionDetailArray[indexPath.row];
                return [self setUpJockesTableViewCell:cell jockesModel:model indexPath:indexPath];
                
            }
        }
            
            break;
            
        default: return nil;
            break;
    }
    return cell;
}

- (JokesTableViewCell *)setUpJockesTableViewCell:(JokesTableViewCell *)cell jockesModel:(JokesModel *)model indexPath:(NSIndexPath *)index{
    cell.timeLabel.text = model.timeStr;
    cell.contentLabel.text = model.title;
    
    cell.contentLabel.height = [self getHeightWithString:model.title size:CGSizeMake(kScreenWidth - 2 * kDistanceOfEdge, 2000) font:[UIFont systemFontOfSize:16]];
    if (cell.contentLabel.height < kHeightOfWord) {
        cell.contentLabel.height = kHeightOfWord;
    }
    cell.contentLabel.top = cell.timeLabel.bottom;
    cell.collectionButton.top = cell.contentLabel.bottom;
    cell.collectionLabel.top = cell.contentLabel.bottom;
    cell.shareButton.top = cell.contentLabel.bottom;
    cell.shareLabel.top = cell.contentLabel.bottom;
    
    cell.collectionButton.hidden =YES;
    cell.collectionLabel.hidden = YES;
    cell.shareButton.hidden = YES;
    cell.shareLabel.hidden = YES;
    
    cell.background.height = cell.contentLabel.height + 16;
    
    cell.background.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

- (JokesTableViewCell *)setUpJockesWhenEmptyTableViewCell:(JokesTableViewCell *)cell
{
    cell.timeLabel.text = nil;
    cell.contentLabel.text = nil;
    cell.textLabel.text = @"列表为空";
    cell.collectionButton.hidden =YES;
    cell.collectionLabel.hidden = YES;
    cell.shareButton.hidden = YES;
    cell.shareLabel.hidden = YES;
    cell.background.height = 30;
    
    cell.background.backgroundColor = [UIColor clearColor];
    return cell;
}

//设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            if (!self.funnyJokesCollectionDetailArray || self.funnyJokesCollectionDetailArray.count == 0 ) {
                return 44;
            }else{
                JokesModel *model = self.funnyJokesCollectionDetailArray[indexPath.row];
                if (model) {
                    return [self setHeightByModel:model];
                }else{
                    return 44;
                }
            }
        }
            break;
        case 1:{
            if (!self.meaningJokesCollectionDetailArray || self.meaningJokesCollectionDetailArray.count == 0) {
                return 44;
            }else{
                JokesModel *model = self.meaningJokesCollectionDetailArray[indexPath.row];
                return [self setHeightByModel:model];
  
            }
        }
            
            break;
        default: return 10;
            break;
    }
}

- (CGFloat)setHeightByModel:(JokesModel *)model{
    CGFloat fitHeightOfContentLabel = [self getHeightWithString:model.title size:CGSizeMake(kScreenWidth - 2 * kDistanceOfEdge, 2000) font:[UIFont systemFontOfSize:16]];
    if (fitHeightOfContentLabel < kHeightOfWord) {
        fitHeightOfContentLabel = kHeightOfWord;
    }
    return fitHeightOfContentLabel + 30;
}
//自适应高度
- (CGFloat)getHeightWithString:(NSString *)str size:(CGSize)size font:(UIFont *)font{
    
    CGRect rect = [str boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin) attributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName] context:nil];
    return rect.size.height;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 50)];
    view.backgroundColor = [UIColor clearColor];
    
    //搞笑段子收藏 内涵段子收藏
    UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDistanceOfEdge, 2 * kDistanceOfEdge, 150, 30)];
    //sectionLabel.backgroundColor = [UIColor yellowColor];
    if (section == 0) {
        sectionLabel.text = @"搞笑段子收藏";
    }else if (section == 1){
        sectionLabel.text = @"内涵段子收藏";
    }
    
    sectionLabel.textAlignment = NSTextAlignmentLeft;
    sectionLabel.font = [UIFont systemFontOfSize:20];
    sectionLabel.textColor = [UIColor blackColor];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(kDistanceOfEdge, 4 * kDistanceOfEdge + 2, kScreenWidth - 2 * kDistanceOfEdge, 0.4)];
    lineView.backgroundColor = [UIColor whiteColor];
    [view addSubview:lineView];
    
    [view addSubview:sectionLabel];
    return view;
}

#pragma mark   编辑cell
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
        {
            if (self.funnyJokesCollectionDetailArray.count == 0) {
                return NO;
            }else{
                return YES;
            }
        }
            break;
            
        case 1:
        {
            if (self.meaningJokesCollectionDetailArray.count == 0) {
                return NO;
            }else{
                return YES;
            }
        }
            break;
            
        default:return YES;
            break;
    }
    
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        switch (indexPath.section) {
            case 0:
            {
                //在数据库中删除
                JokesModel *model = self.funnyJokesCollectionDetailArray[indexPath.row];
                [[FunnyTimeDataBase shareFunnyTimeDataBase] deleteJokeModel:model];
                //在表中删除
                [self.funnyJokesCollectionDetailArray removeObjectAtIndex:indexPath.row];
                [self.tableView reloadData];
            }
                break;
            case 1:
            {
                JokesModel *model = self.meaningJokesCollectionDetailArray[indexPath.row];
                [[FunnyTimeDataBase shareFunnyTimeDataBase] deleteJokeModel:model];
                [self.meaningJokesCollectionDetailArray removeObjectAtIndex:indexPath.row];
                [self.tableView reloadData];
            }
                break;
                
            default:
                break;
        }
        
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
