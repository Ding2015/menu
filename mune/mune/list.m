//
//  list.m
//  mune
//
//  Created by XZH on 15/9/22.
//  Copyright (c) 2015年 就不给你上. All rights reserved.
//
#import "menu.h"
#import "TableViewCell.h"
#import "list.h"

@interface list ()
@property (weak, nonatomic) IBOutlet UITableView *tableview;
- (IBAction)XD:(UIBarButtonItem *)sender;

@end

@implementation list

- (void)viewDidLoad {
    [super viewDidLoad];
     [self uiConfiguration];
    UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"123.png"]];
    imageView.image=[UIImage imageNamed:@"123.png"];
    [self.tableview setBackgroundView:imageView];

     [self requestData];
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //cell的背景图
    cell.backgroundColor = [UIColor clearColor];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData {
    
    PFUser* currentUser = [PFUser currentUser];
    
    PFQuery *incomingRelation = [PFQuery queryWithClassName:@"shopping"];
    [incomingRelation whereKey:@"owner" equalTo:currentUser];
    [incomingRelation includeKey:@"cai"];
    
    [incomingRelation findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        UIRefreshControl *rc = (UIRefreshControl *)[_tableview viewWithTag:8001];
        [rc endRefreshing];
        if (!error) {
            _objectsForShow = [NSMutableArray arrayWithArray:objects];
            NSLog(@"%@", _objectsForShow);
            [_tableview reloadData];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _objectsForShow.count;
}

//左划删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView setEditing:YES animated:YES];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        PFObject *obj = [_objectsForShow objectAtIndex:indexPath.row];
        [obj deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [_objectsForShow removeObjectAtIndex:indexPath.row];
                //[tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [tableView reloadData];			
            }
        }];
    }
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"取消";
}

//使Cell显示移动按钮
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListCell"];
    
    PFObject *obj = [_objectsForShow objectAtIndex:indexPath.row];
    PFObject *cai = obj[@"cai"];
    
    //关联表activity，拿到User表中Name
    
    cell.textLabel.text = cai[@"Name"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@,%@", cai[@"number"],cai[@"price"]];
    cell.showsReorderControl =YES;

    return cell;
}


-(void)uiConfiguration
{
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    NSString *title = [NSString stringWithFormat:@"下拉即可刷新"];
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSTextAlignmentCenter];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    
    NSDictionary *attrsDictionary = @{NSUnderlineStyleAttributeName:
                                          @(NSUnderlineStyleNone),
                                      NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleBody],
                                      NSParagraphStyleAttributeName:style,
                                      NSForegroundColorAttributeName:[UIColor brownColor]};
    
    
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
    refreshControl.attributedTitle = attributedTitle;
    //tintColor旋转的小花的颜色
    refreshControl.tintColor = [UIColor brownColor];
    //背景色 浅灰色
    refreshControl.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //执行的动作
    refreshControl.tag = 8001;
    [refreshControl addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventValueChanged];
    [self.tableview addSubview:refreshControl];
}
- (void)refreshData:(UIRefreshControl *)rc
{
    [self requestData];
    //[self.tableview reloadData];
    //怎么样让方法延迟执行的
    //[self performSelector:@selector(endRefreshing:) withObject:rc afterDelay:1.f];
}
- (void)endRefreshing:(UIRefreshControl *)rc {
    [rc endRefreshing];//闭合
}



- (IBAction)XD:(UIBarButtonItem *)sender{
    PFUser *user = [PFUser currentUser];
    
    PFObject *item = [PFObject objectWithClassName:@"list"];
    item[@"yonghu"] = user;
    
    PFRelation *relation = [item relationForKey:@"cai"];
    for (PFObject *obj in _objectsForShow) {
        PFObject *food = obj[@"cai"];
        [relation addObject:food];
    }
    
    UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
    [item saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [aiv stopAnimating];
        if (succeeded) {
                                 [self performSegueWithIdentifier:@"order" sender:self];
        }
    }];
    
}
@end
