//
//  menu.m
//  mune
//
//  Created by XZH on 15/9/22.
//  Copyright (c) 2015年 就不给你上. All rights reserved.
//
#import "TableViewCell.h"
#import "menu.h"
#import "Utilities.h"

@interface menu ()

- (IBAction)DD:(UIButton *)sender forEvent:(UIEvent *)event;
@end

@implementation menu

- (void)viewDidLoad {
  //获取数据
    [self requestData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)requestData {
    //得到当前用户
    PFUser *currentUser = [PFUser currentUser];
    //查询表
    PFQuery *query = [PFQuery queryWithClassName:@"menu"];
    //价格降序排列
    [query orderByDescending:@"price"];
    
    UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
    [query findObjectsInBackgroundWithBlock:^(NSArray *returnedObjects, NSError *error) {
        [aiv stopAnimating];
        if (!error) {
            _objectsForShow = returnedObjects;
            NSLog(@"%@", _objectsForShow);
            [_tableview reloadData];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _objectsForShow.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TabViewCell" forIndexPath:indexPath];
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    //加载图片
    PFObject *object = [_objectsForShow objectAtIndex:indexPath.row];
//    获得数据库中file，图片
    PFFile *pf = object[@"photo"];
    [pf getDataInBackgroundWithBlock:^(NSData *photoData, NSError *error) {
        if (!error) {//没有错误数据流转换成图片
            UIImage *image = [UIImage imageWithData:photoData];
            //抛回主线程  回到主线程把图片显示出来
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.photo.image = image;
            });
        }
    }];
    
    cell.indexPath = indexPath;
//    string直接显示
    cell.name.text = object[@"Name"];
//    数字类型字符串
    cell.price.text = [NSString stringWithFormat:@"价格：%@", object[@"price"]];
    cell.number.text = [NSString stringWithFormat:@"数量：%@", object[@"number"]];
    
    return cell;
}


//回到页面后就不会选中之前选中的哪行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (IBAction)DD:(UIButton *)sender forEvent:(UIEvent *)event {
}
@end
