//
//  LeftViewController.h
//  mune
//
//  Created by 王杨杨杨 on 15/9/23.
//  Copyright (c) 2015年 就不给你上. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *sortArray;

@end
