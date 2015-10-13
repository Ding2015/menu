//
//  menu.h
//  mune
//
//  Created by XZH on 15/9/22.
//  Copyright (c) 2015年 就不给你上. All rights reserved.
//

#import "ViewController.h"
#import "TableViewCell.h"

@interface menu : ViewController <ActivityTableViewCellDelegate>
@property (strong, nonatomic) PFObject *menu;
@property (strong, nonatomic) PFObject *shopping;


@property (strong, nonatomic) NSMutableArray *objectsForShow;


@property (weak, nonatomic) IBOutlet UITableView *tableview;



@end
