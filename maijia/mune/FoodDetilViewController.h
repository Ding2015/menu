//
//  FoodDetilViewController.h
//  mune
//
//  Created by 王杨杨杨 on 15/9/22.
//  Copyright (c) 2015年 就不给你上. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodDetilViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *sortArray;
@property (weak, nonatomic) IBOutlet UILabel *priceLB;
@property (strong, nonatomic) PFObject *item;

@end
