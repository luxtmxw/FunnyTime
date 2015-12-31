//
//  PicCollectionListTableViewController.m
//  FunnyTime
//
//  Created by luxt on 15/9/23.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import "PicCollectionListTableViewController.h"
#import "PictureModel.h"

//考虑如何共用???
//#import "PicCollectionDetailedTableViewController.h"
#import "ClassPicCollectionTableViewController.h"
#import "RecommentPicCollectionTableViewController.h"
#import "WonderfulPicCollectionTableViewController.h"

#import "CollectionHeaderView.h"

@interface PicCollectionListTableViewController ()

@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) NSMutableArray *picCollectionDataArray;

@property (nonatomic, strong) NSMutableArray *classicPicCollectionDataArray;
@property (nonatomic, strong) NSMutableArray *recommentPicCollectionDataArray;
@property (nonatomic, strong) NSMutableArray *wonderfulPicCollectionDataArray;



@end

@implementation PicCollectionListTableViewController

- (NSUInteger)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
}
- (BOOL)shouldAutorotate {
    return NO;
}

#pragma mark - 懒加载

- (NSMutableArray *)classicPicCollectionDataArray{
    if (!_classicPicCollectionDataArray) {
        _classicPicCollectionDataArray = [[NSMutableArray alloc] init];
    }
    return _classicPicCollectionDataArray;
}
- (NSMutableArray *)recommentPicCollectionDataArray{
    if (!_recommentPicCollectionDataArray) {
        _recommentPicCollectionDataArray = [[NSMutableArray alloc] init];
    }
    return _recommentPicCollectionDataArray;
}
- (NSMutableArray *)wonderfulPicCollectionDataArray{
    if (!_wonderfulPicCollectionDataArray) {
        return _wonderfulPicCollectionDataArray = [[NSMutableArray alloc] init];
    }
    return _wonderfulPicCollectionDataArray;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (PictureModel *model  in [NSMutableArray arrayWithArray:[[FunnyTimeDataBase shareFunnyTimeDataBase] selectedAllPictureCollection]]) {
        if ([model.collectionType intValue] == 0) {
            [self.classicPicCollectionDataArray addObject:model];
        }else if ([model.collectionType intValue] == 1){
            [self.recommentPicCollectionDataArray addObject:model];
        }else if ([model.collectionType intValue] == 2){
            [self.wonderfulPicCollectionDataArray addObject:model];
        }
    }
    
    self.tableView.separatorStyle = 0;
    
    self.tableView.backgroundView = kBlurView;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
//    CollectionHeaderView *headerView = [[CollectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
//    [headerView.backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
//    self.tableView.tableHeaderView = headerView;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonAction)];
    
    //空白表尾
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    
}

- (void)backButtonAction
{
    [self dismissViewControllerAnimated:YES completion:^{
       
    }];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    
    switch (section) {
        case 0:{
            if (self.classicPicCollectionDataArray.count) {
                return self.classicPicCollectionDataArray.count;
            }else{
                return 1;
            }
            
        }
            break;
        case 1:
        {
            if (self.recommentPicCollectionDataArray.count) {
                return self.recommentPicCollectionDataArray.count;
            }else{
                return 1;
            }
            
        }
            break;
        case 2:
        {
            if (self.wonderfulPicCollectionDataArray.count) {
                return self.wonderfulPicCollectionDataArray.count;
            }else{
                return 1;
            }
            
        }
            break;
            
        default:return 1;
            break;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = 0;
//    cell.contentView.height = 40;
    switch (indexPath.section) {
        case 0:{
            if (self.classicPicCollectionDataArray.count == 0) {
                cell.textLabel.text = @"列表为空";
                cell.accessoryType = UITableViewCellAccessoryNone;
                
            }else{
                PictureModel *model = self.classicPicCollectionDataArray[indexPath.row];
                cell.textLabel.text = model.title;
            }
            return cell;
        }
            break;
            
        case 1:
        {
            if (self.recommentPicCollectionDataArray.count == 0) {
                cell.textLabel.text = @"列表为空";
                cell.accessoryType = UITableViewCellAccessoryNone;
            }else{
                PictureModel *model = self.recommentPicCollectionDataArray[indexPath.row];
                cell.textLabel.text = model.title;
            }
            return cell;
        }
            break;
            
        case 2:
        {
            if (self.wonderfulPicCollectionDataArray.count == 0) {
                cell.textLabel.text = @"列表为空";
                cell.accessoryType = UITableViewCellAccessoryNone;
            }else{
                PictureModel *model = self.wonderfulPicCollectionDataArray[indexPath.row];
                cell.textLabel.text = model.title;
            }
            return cell;
        }
            break;
            
            
            
        default:return nil;
            break;
    }

}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 50)];
    view.backgroundColor = [UIColor clearColor];
    
    //
    UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 2 * kDistanceOfEdge, 150, 30)];
    //sectionLabel.backgroundColor = [UIColor yellowColor];
    if (section == 0) {
        sectionLabel.text = @"经典图片收藏";
    }else if (section == 1){
        sectionLabel.text = @"推荐图片收藏";
    }else if (section == 2){
        sectionLabel.text = @"精彩图片推荐";
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
        {
            if (self.classicPicCollectionDataArray.count == 0) {
                
            }else{
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
                ClassPicCollectionTableViewController *CPCTVC = [[ClassPicCollectionTableViewController alloc] init];
                CPCTVC.selectedIndex = indexPath.row;
//                [self presentViewController:CPCTVC animated:YES completion:nil];
                [self pushToDetailViewController:CPCTVC];
            }
        }
            break;
        case 1:
        {
            if (self.recommentPicCollectionDataArray.count == 0) {
                
            }else{
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
                RecommentPicCollectionTableViewController *RPCTVC = [[RecommentPicCollectionTableViewController alloc] init];
                RPCTVC.selectedIndex = indexPath.row;
//                [self presentViewController:RPCTVC animated:YES completion:nil];
                [self pushToDetailViewController:RPCTVC];
            }
        }
            break;
        case 2:
        {
            if (self.wonderfulPicCollectionDataArray.count == 0) {
               
            }else{
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
                WonderfulPicCollectionTableViewController *WPCTVC = [[WonderfulPicCollectionTableViewController alloc] init];
                WPCTVC.selectedIndex = indexPath.row;
//                [self presentViewController:WPCTVC animated:YES completion:nil];
                [self pushToDetailViewController:WPCTVC];
            }
        }
            break;
            
        default:
            break;
    }
    
}

- (void)pushToDetailViewController:(UIViewController *)VC
{
//    CATransition *animation = [CATransition animation];
//    animation.duration = 0.3;
//    animation.subtype = kCATransitionFromRight;
//    animation.type = @"cube";
//    [self.navigationController.view.layer addAnimation:animation forKey:nil];
    [self.navigationController pushViewController:VC animated:YES];
}


#pragma mark 编辑cell
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
        {
            if (self.classicPicCollectionDataArray.count == 0) {
                return NO;
            }else{
                return YES;
            }
            
        }
            break;
            
        case 1:
        {
            if (self.recommentPicCollectionDataArray.count == 0) {
                return NO;
            }else{
                return YES;
            }
            
        }
            break;
            
        case 2:
        {
            if (self.wonderfulPicCollectionDataArray.count == 0) {
                return NO;
            }else{
                return YES;
            }
            
        }
            break;
        default:
            break;
    }
    return YES;
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
                PictureModel *model = self.classicPicCollectionDataArray[indexPath.row];
                [[FunnyTimeDataBase shareFunnyTimeDataBase] deletePictureModel:model];
                //在表中删除
                [self.classicPicCollectionDataArray removeObjectAtIndex:indexPath.row];
                [self.tableView reloadData];
                
            }
                break;
            case 1:
            {
                //在数据库中删除
                PictureModel *model = self.recommentPicCollectionDataArray[indexPath.row];
                [[FunnyTimeDataBase shareFunnyTimeDataBase] deletePictureModel:model];
                //在表中删除
                [self.recommentPicCollectionDataArray removeObjectAtIndex:indexPath.row];
                
                
                [self.tableView reloadData];
            }
                break;
            case 2:
            {
                //在数据库中删除
                PictureModel *model = self.wonderfulPicCollectionDataArray[indexPath.row];
                [[FunnyTimeDataBase shareFunnyTimeDataBase] deletePictureModel:model];
                //在表中删除
                [self.wonderfulPicCollectionDataArray removeObjectAtIndex:indexPath.row];
                
                [self.tableView reloadData];
                
            }
                break;
                
            default:
                break;
        }
    }
    
}





@end
