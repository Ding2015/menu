//
//  ViewController.h
//  mune
//
//  Created by XZH on 15/9/21.
//  Copyright (c) 2015年 就不给你上. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"

@interface ViewController : UIViewController<UIViewControllerAnimatedTransitioning, ECSlidingViewControllerDelegate, ECSlidingViewControllerLayout>
@property (weak, nonatomic) IBOutlet UITextField *UserName;
@property (weak, nonatomic) IBOutlet UITextField *PassWord;
@property(strong,nonatomic) ECSlidingViewController *slidingViewController;
@property (assign,nonatomic) ECSlidingViewControllerOperation operation;
@end

