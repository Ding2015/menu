//
//  kucunViewController.m
//  mune
//
//  Created by 王杨杨杨 on 15/9/24.
//  Copyright (c) 2015年 就不给你上. All rights reserved.
//

#import "kucunViewController.h"

@interface kucunViewController ()

@end

@implementation kucunViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [NSString stringWithFormat:@"%@", _item[@"Name"]];
    _tableView.tableFooterView = [[UIView alloc] init]; // 去掉tableView多余的横线
    [self requestData];
    UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"kucun1.jpg"]];
    imageView.image=[UIImage imageNamed:@"kucun1.jpg"];
    [self.tableView setBackgroundView:imageView];
    
    [self uiConfiguration];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData {
    PFQuery *query = [PFQuery queryWithClassName:@"menu"];
    
    [query whereKey:@"Cate" equalTo:_item];
    [query orderByAscending:@"Left"];
    
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
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sortArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];//复用Cell
    
    PFObject *object = [_sortArray objectAtIndex:indexPath.row];//当前获取的数据
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", object[@"Name"]];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"剩余%@份", object[@"Left"]];
    cell.detailTextLabel.textColor = [UIColor blackColor];
    //    PFObject *object1 = [_sortArray1 objectAtIndex:indexPath.row];//当前获取的数据
    //    cell.detailTextLabel.text = [NSString stringWithFormat:@"库存：%@份", object1[@"Left"]];
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


// 下拉刷新
-(void)uiConfiguration
{
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    NSString *title = [NSString stringWithFormat:@"放开我！混蛋！"];
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSTextAlignmentCenter];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    
    NSDictionary *attrsDictionary = @{NSUnderlineStyleAttributeName:
                                          @(NSUnderlineStyleNone),
                                      NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleBody],
                                      NSParagraphStyleAttributeName:style,
                                      //     字的颜色
                                      NSForegroundColorAttributeName:[UIColor blackColor]};
    
    
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
    refreshControl.attributedTitle = attributedTitle;
    //tintColor旋转的小花的颜色
    refreshControl.tintColor = [UIColor blackColor];
    //背景色
    refreshControl.backgroundColor = [UIColor clearColor];
    //执行的动作
    [refreshControl addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventValueChanged];
    [_tableView addSubview:refreshControl];
}
- (void)refreshData:(UIRefreshControl *)rc
{
    [self requestData];
    [_tableView reloadData];
    //怎么样让方法延迟执行的 [self performSelector:@selector(endRefreshing:) withObject:rc afterDelay:1.f];
    [self performSelector:@selector(endRefreshing:) withObject:rc afterDelay:1.f];
    
}
//闭合
- (void)endRefreshing:(UIRefreshControl *)rc {
    [rc endRefreshing];//闭合
}


@end
