//
//  PicNewCollectionDetailTableViewController.m
//  FunnyTime
//
//  Created by luxt on 15/10/24.
//  Copyright (c) 2015年 luxt. All rights reserved.
//

#import "PicNewCollectionDetailTableViewController.h"
#import "PictureTableViewCell.h"
@interface PicNewCollectionDetailTableViewController ()
@property (nonatomic, strong) NSMutableArray *classArray;
@end

@implementation PicNewCollectionDetailTableViewController

//懒加载
- (NSMutableArray *)classArray{
    if (!_classArray) {
        return _classArray = [[NSMutableArray alloc] init];
    }
    return _classArray;
}

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
        if ([model.collectionType intValue] == 0) {
            [self.classArray addObject:model];
        }
    }
    [self.tableView registerClass:[PictureTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    //表头
    //    CollectionHeaderView *headerView = [[CollectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    //    headerView.lineView.hidden = YES;
    //    headerView.titleLabel.text = @"经典图片收藏";
    //    [headerView.backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    //    self.tableView.tableHeaderView = headerView;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonAction)];
    self.navigationItem.title = @"经典图片收藏";
    
    //背景模糊视图
    self.tableView.backgroundView = kBlurView;
    
    //跳到被选中的那一行
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    
    self.tableView.separatorStyle = 0;
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.tableView.backgroundView = kBlurView;
    [super viewWillAppear:animated];
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
    if (self.classArray) {
        return self.classArray.count;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PictureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    PictureModel *model = self.classArray[indexPath.row];
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
            PictureModel *model = self.classArray[indexPath.row];
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


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

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
