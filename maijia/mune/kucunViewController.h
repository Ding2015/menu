//
//  kucunViewController.h
//  mune
//
//  Created by 王杨杨杨 on 15/9/24.
//  Copyright (c) 2015年 就不给你上. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface kucunViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) PFObject *item; // 接收来自上级页面的数据
@property (strong, nonatomic) NSArray *sortArray;
@end