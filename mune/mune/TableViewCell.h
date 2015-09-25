//
//  TableViewCell.h
//  mune
//
//  Created by XZH on 15/9/23.
//  Copyright (c) 2015年 就不给你上. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ActivityTableViewCellDelegate;

@interface TableViewCell : UITableViewCell
@property (weak, nonatomic) id<ActivityTableViewCellDelegate> delegate;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *number;
@property(strong,nonatomic) PFObject *menu;

@end

@protocol ActivityTableViewCellDelegate <NSObject>

@required
- (void)cellLongPressAtIndexPath:(NSIndexPath *)indexPath;
- (void)photoTapAtIndexPath:(NSIndexPath *)indexPath;
- (void)applyPressed:(NSIndexPath *)indexPath;

@end