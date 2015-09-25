//
//  ViewController.m
//  mune
//
//  Created by XZH on 15/9/21.
//  Copyright (c) 2015年 就不给你上. All rights reserved.
//

#import "ViewController.h"
#import "TabViewController.h"
#import "left.h"
@interface ViewController ()
- (IBAction)login:(UIButton *)sender forEvent:(UIEvent *)event;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (![[Utilities getUserDefaults:@"UserName"] isKindOfClass:[NSNull class]]) {
       _UserName.text = [Utilities getUserDefaults:@"UserName"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    }

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (IBAction)login:(UIButton *)sender forEvent:(UIEvent *)event
    {
        
        NSString *username = _UserName.text;
        NSString *password = _PassWord.text;
        
        if ([username isEqualToString:@""] || [password isEqualToString:@""]) {
            [Utilities popUpAlertViewWithMsg:@"请填写所有信息" andTitle:nil];
            return;
        }
        UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
            [aiv stopAnimating];
        if (user) {
            
            //只要用户登陆过注册过就记住用户名
            [Utilities setUserDefaults:@"UserName" content:username];
            // _usernameTF.text = @"";
            _PassWord.text = @"";
            [self popUpHomePage];
            
        } else if (error.code == 101) {
            [Utilities popUpAlertViewWithMsg:@"用户名或密码错误" andTitle:nil];
        } else if (error.code == 100) {
            [Utilities popUpAlertViewWithMsg:@"网络不给力，请稍后再试" andTitle:nil];
        }else{
            [Utilities popUpAlertViewWithMsg:nil andTitle:nil];
        }
        
    }];


    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //判断
    if([[[storageMgr singletonStorageMgr]objectForKey:@"signup"]integerValue] == 1){
        [[storageMgr singletonStorageMgr]removeObjectForKey:@"signup"];
        //是1就跳转
        [self popUpHomePage];
    }
}

-(void)popUpHomePage
{
    //根据TabViewController取得Tab这个名字获得storyboardInstance
    TabViewController * tabVC = [Utilities getStoryboardInstanceByIdentity:@"Tab"];
    //创建导航控制器(用Model的方式跳转)
    UINavigationController * naviVC = [[UINavigationController alloc] initWithRootViewController:tabVC];
    //隐藏导航条
    naviVC.navigationBarHidden = YES;
    
    [self presentViewController:naviVC animated:YES completion:nil];

}
@end
