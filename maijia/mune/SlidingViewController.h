//
//  SlidingViewController.h
//  mune
//
//  Created by 王杨杨杨 on 15/9/25.
//  Copyright (c) 2015年 就不给你上. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlidingViewController : UIViewController<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *photoIV;


@property (strong, nonatomic) UIImagePickerController *imagePickerController;

@end
