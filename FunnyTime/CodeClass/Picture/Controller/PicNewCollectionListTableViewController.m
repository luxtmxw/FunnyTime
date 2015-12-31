//
//  PicNewCollectionListTableViewController.m
//  FunnyTime
//
//  Created by luxt on 15/10/23.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import "PicNewCollectionListTableViewController.h"
#import "PictureModel.h"
#import "PicNewCollectionDetailTableViewController.h"
@interface PicNewCollectionListTableViewController ()
@property (nonatomic, strong) NSMutableArray *picCollectionDataArray;
@end

@implementation PicNewCollectionListTableViewController

- (NSMutableArray *)picCollectionDataArray
{
    if (!_picCollectionDataArray) {
        _picCollectionDataArray = [[NSMutableArray alloc] init];
    }
    return _picCollectionDataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (PictureModel *model  in [NSMutableArray arrayWithArray:[[FunnyTimeDataBase shareFunnyTimeDataBase] selectedAllPictureCollection]])
    {
        [self.picCollectionDataArray addObject:model];
    }
    
    self.tableView.separatorStyle = 0;
    
    self.tableView.backgroundView = kBlurView;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonAction)];
    
    //空白表尾
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    
}

- (void)backButtonAction
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
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

    if (self.picCollectionDataArray.count) {
        return self.picCollectionDataArray.count;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = 0;
    //    cell.contentView.height = 40;
    if (self.picCollectionDataArray.count == 0) {
        cell.textLabel.text = @"列表为空";
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;
        
    }else{
        PictureModel *model = self.picCollectionDataArray[indexPath.row];
        cell.textLabel.text = model.title;
        return cell;
    }
    //return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.picCollectionDataArray.count == 0) {
        
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        PicNewCollectionDetailTableViewController *CPCTVC = [[PicNewCollectionDetailTableViewController alloc] init];
        CPCTVC.selectedIndex = indexPath.row;
        //                [self presentViewController:CPCTVC animated:YES completion:nil];
        [self pushToDetailViewController:CPCTVC];
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

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //在数据库中删除
        PictureModel *model = self.picCollectionDataArray[indexPath.row];
        [[FunnyTimeDataBase shareFunnyTimeDataBase] deletePictureModel:model];
        //在表中删除
        [self.picCollectionDataArray removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
    }   
}


@end
