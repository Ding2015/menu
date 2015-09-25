//
//  RegisterViewController.m
//  mune
//
//  Created by XZH on 15/9/22.
//  Copyright (c) 2015年 就不给你上. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()
- (IBAction)signup:(UIButton *)sender forEvent:(UIEvent *)event;


@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (IBAction)signup:(UIButton *)sender forEvent:(UIEvent *)event {
    
    NSString *username = _UserName.text;
    NSString *email = _Email.text;
    NSString *password = _PassWord.text;
    NSString *confirmPwd = _ConfirmPw.text;
    //四个信息其中有个没写
    if ([username isEqualToString:@""] ||[email isEqualToString:@""]||[password isEqualToString:@""]||[confirmPwd isEqualToString:@""]) {
        [Utilities popUpAlertViewWithMsg:@"请填写所有信息" andTitle:nil];
        return;//阻止后面所有操作
    }
    //密码与第二次密码不同
    if(![password isEqualToString:confirmPwd]){
        [Utilities popUpAlertViewWithMsg:@"确认密码必须与密码保持一致" andTitle:nil];
        return;//阻止后面所有操作
    }
    //parse里的方法
    PFUser *user = [PFUser user];
    user.username = username;
    user.password = password;
    user.email = email;
    
    //保护膜 菊花 延迟的时候防止用户乱按
    //    UIActivityIndicatorView *aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    //    aiv.frame = self.view.bounds;
    //    [self.view addSubview:aiv];
    //菊花开始转
    //    [aiv startAnimating];
    //用菊花覆盖当前视图
    UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
    
    
    //写入数据库
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        //菊花停止转
        [aiv stopAnimating];
        //没错就注册成功
        if (!error) {
            //只要用户登陆过注册过就记住用户名
            [Utilities setUserDefaults:@"UserName" content:username];
            //在登录页面判断是否为1  注册成功后插入键值队 在单例化全局变量中插入一个键值队
            [[storageMgr singletonStorageMgr]addKeyAndValue:@"signup" And:@1];
            //注册成功回到登录页面  push方式返回 跳转首页
            [self.navigationController popViewControllerAnimated:YES];
            
            //有错执行下面
        } else if (error.code == 202) {
            [Utilities popUpAlertViewWithMsg:@"该用户名已被使用，请尝试其它名称" andTitle:nil];
        } else if (error.code == 203) {
            [Utilities popUpAlertViewWithMsg:@"该电子邮箱已被使用，请尝试其它名称" andTitle:nil];
        }else if (error.code == 125) {
            [Utilities popUpAlertViewWithMsg:@"该电子邮箱为非法地址" andTitle:nil];
        }
        else if (error.code == 100) {
            [Utilities popUpAlertViewWithMsg:@"网络不给力，请稍后再试" andTitle:nil];
        }
        
    }];
    

}
@end
