//
//  TableViewCell.m
//  mune
//
//  Created by XZH on 15/9/23.
//  Copyright (c) 2015年 就不给你上. All rights reserved.
//
#import"menu.h"

#import "TableViewCell.h"

@implementation TableViewCell


- (IBAction)add:(UIButton *)sender forEvent:(UIEvent *)event {
    if (_delegate && [_delegate respondsToSelector:@selector(applyPressed:)]) {
        [_delegate applyPressed:_indexPath];
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews {
    [super layoutSubviews];
}

@end
