//
//  VoiceCollectionListTableViewController.m
//  FunnyTime
//
//  Created by luxt on 15/10/4.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import "VoiceCollectionListTableViewController.h"
#import "VoicePlayViewController.h"
#import "VoicePlayListModel.h"
#import "CollectionHeaderView.h"
@interface VoiceCollectionListTableViewController ()

@property (nonatomic, strong) NSMutableArray *voiceColletinArray;

@end

@implementation VoiceCollectionListTableViewController

- (NSUInteger)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
}
- (BOOL)shouldAutorotate {
    return NO;
}

- (NSMutableArray *)voiceColletinArray
{
    if (!_voiceColletinArray) {
        _voiceColletinArray = [[NSMutableArray alloc] initWithArray:[[FunnyTimeDataBase shareFunnyTimeDataBase] selectedAllVoicesCollection]];
    }
    return _voiceColletinArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //表头
//    CollectionHeaderView *headerView = [[CollectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
//    
//    [headerView.backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
//    self.tableView.tableHeaderView = headerView;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonAction)];
    
    //背景模糊视图
    self.tableView.backgroundView = kBlurView;
    
    self.tableView.separatorStyle = 0;
    
//    [self setNavigationBar];
    

}

-(void)viewWillAppear:(BOOL)animated
{
    self.voiceColletinArray = [[NSMutableArray alloc] initWithArray:[[FunnyTimeDataBase shareFunnyTimeDataBase] selectedAllVoicesCollection]];
    [self.tableView reloadData];
    self.tableView.backgroundView = kBlurView;
    [super viewWillAppear:animated];
}

//- (void)setNavigationBar
//{
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonAction:)];
//    self.navigationItem.leftBarButtonItem = backButton;
//    
//}

- (void)backButtonAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
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

    if (self.voiceColletinArray.count == 0) {
        return 1;
    }else{
       return self.voiceColletinArray.count;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"collectionCell";
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = 0;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (self.voiceColletinArray.count == 0) {
        cell.textLabel.text = @"列表为空";
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.detailTextLabel.text = nil;
    }else{
        VoicePlayListModel *model = self.voiceColletinArray[indexPath.row];
        
        cell.textLabel.text = [NSString stringWithFormat:@"第%@期 %@",model.orderNum,model.audioName];
        cell.detailTextLabel.text = model.audioDes;
    }
    
    
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.voiceColletinArray.count == 0) {
        return NO;
    }else{
        return YES;
    }
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        VoicePlayListModel *model = self.voiceColletinArray[indexPath.row];
        [[FunnyTimeDataBase shareFunnyTimeDataBase] deleteVoiceModel:model];
        
        [self.voiceColletinArray removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.voiceColletinArray.count != 0) {
        
        VoicePlayListModel *model = self.voiceColletinArray[indexPath.row];

        //同一首歌,跳转
        if ([[VoicePlayer shareVoicePlayer].voicePlayListModel.mp3PlayUrl isEqualToString:model.mp3PlayUrl]) {
            //用单例存数据
            [VoicePlayer shareVoicePlayer].voicePlayListModel = model;
            [VoicePlayer shareVoicePlayer].modelArray = self.voiceColletinArray;
            [VoicePlayer shareVoicePlayer].currentSongIndex = indexPath.row;
            [self presentViewController:[VoicePlayer shareVoicePlayer].playViewController animated:YES completion:nil];
        }else{  //不同的歌
            VoicePlayViewController *voicePlayVC = [[VoicePlayViewController alloc] init];
            //用单例存数据
            [VoicePlayer shareVoicePlayer].voicePlayListModel = model;
            [VoicePlayer shareVoicePlayer].modelArray = self.voiceColletinArray;
            [VoicePlayer shareVoicePlayer].currentSongIndex = indexPath.row;
            [self presentViewController:voicePlayVC animated:YES completion:nil];
            
        }
    }
    
    

}


@end
