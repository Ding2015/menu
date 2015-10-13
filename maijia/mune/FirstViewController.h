//
//  FirstViewController.h
//  mune
//
//  Created by 王杨杨杨 on 15/9/21.
//  Copyright (c) 2015年 就不给你上. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController <UIViewControllerAnimatedTransitioning, ECSlidingViewControllerDelegate, ECSlidingViewControllerLayout>

@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passWord;

@property (strong, nonatomic) ECSlidingViewController *slidingViewController;
@property (assign, nonatomic) ECSlidingViewControllerOperation operation;

@end
