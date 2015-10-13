//
//  menu.m
//  mune
//
//  Created by XZH on 15/9/22.
//  Copyright (c) 2015年 就不给你上. All rights reserved.
//
#import "left.h"
#import "menu.h"
#import "Utilities.h"

@interface menu ()

@end

@implementation menu

- (void)viewDidLoad {
  //获取数据
    [self requestData];
  
       _tableview.tableFooterView = [[UIView alloc] init];
    UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"123.png"]];
    imageView.image=[UIImage imageNamed:@"123.png"];
    [self.tableview setBackgroundView:imageView];
 
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //cell的背景图
    cell.backgroundColor = [UIColor clearColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"enablePanGes" object:self];
}
//首页进入下一个页面是侧滑手势关闭
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"disablePanGes" object:self];
}
//自动监听StoryboardSegue连这根线
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"menu"]) {
        //拿到数据对象获得当前tableView选中行的数据
        PFObject *object = [_objectsForShow objectAtIndex:[_tableview indexPathForSelectedRow].row];
        //获得实例
        menu *itemVC = segue.destinationViewController;
        //Booking设为传过去的数据
        itemVC.menu= object;
        //切换隐藏按钮
        itemVC.hidesBottomBarWhenPushed = YES;
    }
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
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell" forIndexPath:indexPath];
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
    cell.delegate = self;
    cell.indexPath = indexPath;
//    string直接显示
    cell.name.text = object[@"Name"];
    cell.price.text = [NSString stringWithFormat:@"价格：%@", object[@"price"]];
    cell.number.text = [NSString stringWithFormat:@"数量：%@", object[@"number"]];
//    数字类型字符串
    
    
    
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

- (void)applyPressed:(NSIndexPath *)indexPath {
    PFObject *shopping = [PFObject objectWithClassName:@"shopping"];
    
    PFUser *currentUser = [PFUser currentUser];
    //owner设为currentUser
    shopping[@"owner"] = currentUser;
    PFObject *cai = [_objectsForShow objectAtIndex:indexPath.row];
    shopping[@"cai"] = cai;
    
    //设置菊花
    UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
    
    //保存
    [shopping saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [aiv stopAnimating];
        if (succeeded) {//成功
             [Utilities popUpAlertViewWithMsg:@"加入成功" andTitle:nil];
           
        } else {
            [Utilities popUpAlertViewWithMsg:nil andTitle:nil];
        }
    }];
}




@end
