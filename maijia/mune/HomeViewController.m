//
//  HomeViewController.m
//  mune
//
//  Created by 王杨杨杨 on 15/9/22.
//  Copyright (c) 2015年 就不给你上. All rights reserved.
//

#import "HomeViewController.h"
#import "FoodDetilViewController.h"
@interface HomeViewController ()
- (IBAction)SliAc:(UIBarButtonItem *)sender;


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.tableFooterView = [[UIView alloc] init]; // 去掉tableView多余的横线
    [self requestData];
    
    UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home.jpg"]];
    imageView.image=[UIImage imageNamed:@"home1.jpg"];
    [self.tableView setBackgroundView:imageView];
    
    [self uiConfiguration];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"refreshMine" object:nil];
    
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Item"])
    { // 把本页的数据传给下一页
        PFObject *object = [_sortArray objectAtIndex:[_tableView indexPathForSelectedRow].row]; // 获取tableView 选中当前行的数据
        FoodDetilViewController *miVC = segue.destinationViewController; // 去到那个控制器
        miVC.item = object[@"yonghu"];
        miVC.hidesBottomBarWhenPushed = YES; // 隐藏切换按钮
    }
    
}

- (void)requestData {
    PFQuery *query = [PFQuery queryWithClassName:@"list"];
    [query includeKey:@"yonghu"];
    [query orderByAscending:@"Time"];
    UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
    [query findObjectsInBackgroundWithBlock:^(NSArray *returnedObjects, NSError *error) {
        [aiv stopAnimating];
        if (!error) {
            _sortArray = returnedObjects;
            NSLog(@"_sortArray = %@", _sortArray);
            [_tableView reloadData];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sortArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath]; // 复用Cell
    
    PFObject *object = [_sortArray objectAtIndex:indexPath.row]; // 当前获取的数据
    PFObject *item = object[@"yonghu"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@的订单", item[@"username"]];
    cell.textLabel.textColor = [UIColor blackColor];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *strDate = [dateFormatter stringFromDate:object.createdAt];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"下单时间：%@",strDate];
    cell.detailTextLabel.textColor = [UIColor blackColor];
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; // 让选中的cell变为不选中
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    // cell的背景图
    cell.backgroundColor = [UIColor clearColor];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//下拉刷新
-(void)uiConfiguration
{
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    NSString *title = [NSString stringWithFormat:@"混蛋，放开我!"];
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSTextAlignmentCenter];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    
    NSDictionary *attrsDictionary = @{NSUnderlineStyleAttributeName:
                                          @(NSUnderlineStyleNone),
                                      NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleBody],
                                      NSParagraphStyleAttributeName:style,
                                      // 字的颜色
                                      NSForegroundColorAttributeName:[UIColor blackColor]};
    
    
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
    refreshControl.attributedTitle = attributedTitle;
    // tintColor旋转的小花的颜色
    refreshControl.tintColor = [UIColor blackColor];
    // 背景色
    refreshControl.backgroundColor = [UIColor clearColor];
    // 执行的动作
    [refreshControl addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventValueChanged];
    [_tableView addSubview:refreshControl];
}
- (void)refreshData:(UIRefreshControl *)rc
{
    [self requestData];
    [_tableView reloadData];
    // 怎么样让方法延迟执行的 [self performSelector:@selector(endRefreshing:) withObject:rc afterDelay:1.f];
    [self performSelector:@selector(endRefreshing:) withObject:rc afterDelay:1.f];
    
}
// 闭合
- (void)endRefreshing:(UIRefreshControl *)rc {
    [rc endRefreshing]; // 闭合
}

- (IBAction)SliAc:(UIBarButtonItem *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSwitch" object:self];
}
@end
