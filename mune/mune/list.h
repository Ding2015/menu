//
//  list.h
//  mune
//
//  Created by XZH on 15/9/22.
//  Copyright (c) 2015年 就不给你上. All rights reserved.
//

#import "ViewController.h"

@interface list : ViewController
@property (weak, nonatomic) IBOutlet UITableView *BD;
@property(strong,nonatomic)NSArray *objectsForShow;

@end
