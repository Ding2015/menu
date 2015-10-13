//
//  list.h
//  mune
//
//  Created by XZH on 15/9/22.
//  Copyright (c) 2015年 就不给你上. All rights reserved.
//
#import "TableViewCell.h"
#import "menu.h"
#import "ViewController.h"

@protocol ActivityTableViewCellDelegate;

@interface list : ViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) id<ActivityTableViewCellDelegate> delegate;
@property(strong,nonatomic) NSMutableArray *objectsForShow;
@property (strong, nonatomic) PFObject *menu;
@property (strong, nonatomic) PFObject *shopping;
@property (strong, nonatomic) PFObject *list;
@property (strong, nonatomic) NSIndexPath *indexPath;
- (void)applyPressed:(NSIndexPath *)indexPath;







@end
