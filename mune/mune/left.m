//
//  left.m
//  mune
//
//  Created by XZH on 15/9/28.
//  Copyright (c) 2015年 就不给你上. All rights reserved.
//

#import "left.h"

@interface left ()
- (IBAction)XGYH:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)XGMM:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)TC:(UIButton *)sender forEvent:(UIEvent *)event;

@end

@implementation left

- (void)viewDidLoad {
    [super viewDidLoad];
     PFUser*currentUser = [PFUser currentUser];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)XGYH:(UIButton *)sender forEvent:(UIEvent *)event {
    //弹窗
    UIAlertView *sellView = [[UIAlertView alloc]initWithTitle:nil message:@"修改用户名" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    //弹窗风格  （普通）
    [sellView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [sellView show];
    

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //如果按了1确定
    UITextField *textField = [alertView textFieldAtIndex:0];
    if (buttonIndex == 1) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        
        if([textField.text isEqualToString:@""]){
            [Utilities popUpAlertViewWithMsg:@"请填写用户名"  andTitle:nil];
            return;//终止操作
        }
    }
    PFUser *user=[PFUser currentUser];
    user[@"username"]=textField.text;
    
    UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [aiv stopAnimating];
        if (succeeded) {
            
            //退出
            [self dismissViewControllerAnimated:YES completion:nil];
            
        } else {
            [Utilities popUpAlertViewWithMsg:nil andTitle:nil];
        }
    }];
    
}


- (IBAction)XGMM:(UIButton *)sender forEvent:(UIEvent *)event {
    //        //获得按钮的一次触摸
    //        UITouch *touch = [[event allTouches] anyObject];
    CATransition *animation = [CATransition animation];
    animation.duration = 1.0;//持续时间
    animation.timingFunction = UIViewAnimationCurveEaseInOut;//缓慢的开始和结束
    
    animation.type = @"rippleEffect";//产生波纹效果
    animation.subtype = kCATransitionFromLeft;//图标类型从左过度
    [self.view.window.layer addAnimation:animation forKey:nil];
    
    
    
    
    
    UIViewController *tabVC = [Utilities getStoryboardInstanceByIdentity:@"xiugai"];
    UINavigationController* naviVC = [[UINavigationController alloc] initWithRootViewController:tabVC];
    naviVC.navigationBarHidden = YES;
    [self presentViewController:naviVC animated:YES completion:nil];
}

- (IBAction)TC:(UIButton *)sender forEvent:(UIEvent *)event {
    //parse的退出
    [PFUser logOut];
    //按退出按钮后回到登录页面
    [self dismissViewControllerAnimated:YES completion:nil];

}
@end
