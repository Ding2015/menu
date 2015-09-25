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

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews {
    [super layoutSubviews];
   
    UILongPressGestureRecognizer *cellLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cellLongPress:)];
    [self addGestureRecognizer:cellLongPress];
    
    UITapGestureRecognizer *photoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTap:)];
    [self.photo addGestureRecognizer:photoTap];
}

- (void)cellLongPress:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        if (_delegate && _indexPath && [_delegate respondsToSelector:@selector(cellLongPressAtIndexPath:)]) {
            [_delegate cellLongPressAtIndexPath:_indexPath];
        }
    }
}

- (void)photoTap:(UITapGestureRecognizer *)tap {
    if (tap.state == UIGestureRecognizerStateRecognized) {
        if (_delegate && self.indexPath && [_delegate respondsToSelector:@selector(photoTapAtIndexPath:)]) {
            [_delegate photoTapAtIndexPath:_indexPath];
        }
    }
}

@end
