//
//  FoodDetilViewController.m
//  mune
//
//  Created by 王杨杨杨 on 15/9/22.
//  Copyright (c) 2015年 就不给你上. All rights reserved.
//

#import "FoodDetilViewController.h"
#import "HomeViewController.h"
@interface FoodDetilViewController ()
{
    CGFloat total;
}

@end

@implementation FoodDetilViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self uiConfiguration];
    
    [self requestData];
    
    [self Data];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@的订单", _item[@"username"]];
    
    _tableView.tableFooterView = [[UIView alloc] init]; // 去掉tableView多余的横线

    UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xiangqing.jpg"]];
    imageView.image=[UIImage imageNamed:@"xiangqing3.jpg"];
    [self.tableView setBackgroundView:imageView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData {
    PFQuery *query = [PFQuery queryWithClassName:@"shopping"];
    
    [query whereKey:@"owner" equalTo:_item]; // _item接收来自HomeViewController的Cell的点击信息
    [query includeKey:@"cai"];

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

- (void)Data{
    
    PFQuery *query = [PFQuery queryWithClassName:@"list"];
    [query whereKey:@"yonghu" equalTo:_item];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *obj in objects) {
                PFRelation *incomingRelation = [obj relationForKey:@"cai"];
                [[incomingRelation query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if (!error) {
                        CGFloat sum = 0;
                        for (PFObject *food in objects) {
                            NSLog(@"%@", food[@"price"]);
                            sum += [food[@"price"] floatValue];
                        }
                        total += sum;
                        NSString *totalPrice = [Utilities notRounding:total afterPoint:2];
                        NSLog(@"TotalPrice = %@", totalPrice);
                        _priceLB.text = [NSString stringWithFormat:@"总价格：%@元 ",totalPrice];
                        total = 0; // 清零
                    }
                    else {
                        NSLog(@"Error: %@ %@", error, [error userInfo]);
                    }
                }];
            }
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sortArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    PFObject *object = [_sortArray objectAtIndex:indexPath.row];
    
    PFObject *item = object[@"cai"];
    

    // 如何计算
    CGFloat price = [item[@"price"] floatValue];
//    NSInteger amount = [object[@"number"] integerValue];
//    CGFloat totalPrice = price * (CGFloat)amount;
    NSString *rangeStr = [Utilities notRounding:price afterPoint:0];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"价格：%@ ",rangeStr];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.textColor = [UIColor blackColor];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ * 1", item[@"Name"]];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; // 让选中的cell变为不选中
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cell.backgroundColor = [UIColor clearColor];
}


-(void)uiConfiguration
{
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    NSString *title = [NSString stringWithFormat:@"你再扯我就报警啦！"];
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
    [self Data];
    [_tableView reloadData];
    // 怎么样让方法延迟执行的 [self performSelector:@selector(endRefreshing:) withObject:rc afterDelay:1.f];
    [self performSelector:@selector(endRefreshing:) withObject:rc afterDelay:1.f];
    
}
 // 闭合
- (void)endRefreshing:(UIRefreshControl *)rc {
    [rc endRefreshing]; // 闭合
}

@end
