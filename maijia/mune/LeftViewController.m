//
//  LeftViewController.m
//  mune
//
//  Created by 王杨杨杨 on 15/9/23.
//  Copyright (c) 2015年 就不给你上. All rights reserved.
//

#import "LeftViewController.h"
#import "kucunViewController.h"
@interface LeftViewController ()

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   _tableView.tableFooterView = [[UIView alloc] init]; // 去掉tableView多余的横线
    [self requestData];
    
    UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"kucun1.jpg"]];
    imageView.image=[UIImage imageNamed:@"kucun2.jpg"];
    [self.tableView setBackgroundView:imageView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Turn"])
    { // 把本页的数据传给下一页
        PFObject *object = [_sortArray objectAtIndex:[_tableView indexPathForSelectedRow].row]; // 获取tableView 选中当前行的数据
        kucunViewController *miVC = segue.destinationViewController;//去到那个控制器
        miVC.item = object;
        miVC.hidesBottomBarWhenPushed = YES;//隐藏切换按钮
    }
    
}

// 通知
// 在一级页面开启滑动
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"enablePanGes" object:self];
}
// 一级页面消失后（进入二级页面后）关闭滑动
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"disablePanGes" object:self];
}


- (void)requestData {
    PFQuery *query = [PFQuery queryWithClassName:@"category"];
//    PFQuery *query1 = [PFQuery queryWithClassName:@"AllFood"];
    
    
    UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
    [query findObjectsInBackgroundWithBlock:^(NSArray *returnedObjects, NSError *error) {
        [aiv stopAnimating];
        if (!error) {
            _sortArray = returnedObjects;
            NSLog(@"%@", _sortArray);
            [_tableView reloadData];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    
//    [query1 findObjectsInBackgroundWithBlock:^(NSArray *returnedObjects, NSError *error) {
//        [aiv stopAnimating];
//        if (!error) {
//            _sortArray1 = returnedObjects;
//            NSLog(@"%@", _sortArray1);
//            [_tableView reloadData];
//        } else {
//            NSLog(@"Error: %@ %@", error, [error userInfo]);
//        }
//    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sortArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];//复用Cell
    
    PFObject *object = [_sortArray objectAtIndex:indexPath.row]; // 当前获取的数据
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", object[@"Name"]];
    cell.textLabel.textColor = [UIColor blackColor];
    
//    PFObject *object1 = [_sortArray1 objectAtIndex:indexPath.row]; // 当前获取的数据
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"库存：%@份", object1[@"Left"]];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; // 让选中的cell变为不选中
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //cell的背景图
    cell.backgroundColor = [UIColor clearColor];
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([segue.identifier isEqualToString:@"Turn"])
//    { // 把本页的数据传给下一页
//        PFObject *object = [_sortArray objectAtIndex:[_tableView indexPathForSelectedRow].row]; // 获取tableView 选中当前行的数据
//        kucunViewController *miVC = segue.destinationViewController;//去到那个控制器
//        miVC.item = object;
//        miVC.hidesBottomBarWhenPushed = YES;//隐藏切换按钮
//    }
//    
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
