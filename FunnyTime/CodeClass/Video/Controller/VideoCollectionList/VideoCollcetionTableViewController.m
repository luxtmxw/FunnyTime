//
//  VideoCollcetionTableViewController.m
//  FunnyTime
//
//  Created by luxt on 15/10/4.
//  Copyright © 2015年 luxt. All rights reserved.
//

#import "VideoCollcetionTableViewController.h"
#import "PlayVideoViewController.h"
#import "AppDelegate.h"
#import "LeftSettingViewController.h"
@interface VideoCollcetionTableViewController ()
@property (nonatomic, strong) NSMutableArray *videoCollectionListArray;
@end

@implementation VideoCollcetionTableViewController

- (NSUInteger)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
}
- (BOOL)shouldAutorotate {
    return NO;
}

- (NSMutableArray *)videoCollectionListArray {
    if (!_videoCollectionListArray) {
        _videoCollectionListArray = [NSMutableArray array];
       _videoCollectionListArray = [[FunnyTimeDataBase shareFunnyTimeDataBase] selectedAllVideoCollection];
    }
    return _videoCollectionListArray;
}


- (void)viewWillAppear:(BOOL)animated
{
    self.tableView.backgroundView = kBlurView;
    [self.tableView reloadData];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView) name:@"dismissVideoPlayVC" object:nil];
}

- (void)refreshView
{
    self.videoCollectionListArray = [[FunnyTimeDataBase shareFunnyTimeDataBase] selectedAllVideoCollection];
    [self.tableView reloadData];
}

- (void)setUpView {
    self.tableView.backgroundView = kBlurView;
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc ] initWithTitle:@"返回" style:(UIBarButtonItemStylePlain) target:self action:@selector(actionLeftBarButton)];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    self.tableView.separatorStyle = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"videoCollecionCell"];
}



- (void)actionLeftBarButton {
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
    if (self.videoCollectionListArray.count == 0) {
        return 1;
    }else{
        return self.videoCollectionListArray.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"videoCollecionCell" forIndexPath:indexPath];
    cell.selectionStyle = 0;
    cell.backgroundColor = [UIColor clearColor];
    if (self.videoCollectionListArray.count == 0) {
        cell.textLabel.text = @"列表为空";
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else{
        VideoModel *videoModel = self.videoCollectionListArray[indexPath.row];
        cell.textLabel.text = videoModel.title;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.videoCollectionListArray.count == 0) {
        
    }else{
        
        //    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        PlayVideoViewController *playerVC = [[PlayVideoViewController alloc] init];
        playerVC.videoModel = self.videoCollectionListArray[indexPath.row];
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.videoCollectionListArray];
        playerVC.index = indexPath.row;
        playerVC.listArray = tempArray;
        
        [self presentViewController:playerVC animated:YES completion:nil];
        //    [delegate.window.rootViewController presentViewController:playerVC animated:NO completion:nil];
    }
    
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoModel *videoModel = self.videoCollectionListArray[indexPath.row];
    [[FunnyTimeDataBase shareFunnyTimeDataBase] deleteVideoModel:videoModel];
    [self.videoCollectionListArray removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除!";
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.videoCollectionListArray.count == 0) {
        return NO;
    }else{
        return YES;
        
    }
}


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
