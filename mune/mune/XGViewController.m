//
//  XGViewController.m
//  mune
//
//  Created by XZH on 15/9/23.
//  Copyright (c) 2015年 就不给你上. All rights reserved.
//
#import "RegisterViewController.h"
#import "XGViewController.h"

@interface XGViewController ()
- (IBAction)FH:(UIBarButtonItem *)sender;
- (IBAction)QD:(UIBarButtonItem *)sender;

@end

@implementation XGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
-(BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return  YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    [self.view endEditing:YES];
}

- (IBAction)FH:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)QD:(UIBarButtonItem *)sender {
    if ([self.YMM.text isEqualToString:[Utilities getUserDefaults:@"password"]]) {
        if ([self.XMM.text isEqualToString:self.QD.text]) {
            PFUser *currUser=[PFUser currentUser];
            currUser.password=self.XMM.text;
            UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
            [currUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [aiv stopAnimating];
                if (succeeded) {
                    [Utilities setUserDefaults:@"password" content:self.XMM.text];
                    [Utilities popUpAlertViewWithMsg:@"成功修改！" andTitle:nil];
                    
                    [PFUser logOut];//退出Parse
                    [aiv startAnimating];
                    //重新登录
                    [PFUser logInWithUsernameInBackground:currUser.username password:self.XMM.text block:^(PFUser *user, NSError *error) {
                        
                        [aiv stopAnimating];
                        if (user) {
                            [self dismissViewControllerAnimated:YES completion:nil];
                        } else if (error.code == 101) {
                            [Utilities popUpAlertViewWithMsg:@"用户名或密码错误" andTitle:nil];
                        } else if (error.code == 100) {
                            [Utilities popUpAlertViewWithMsg:@"网络不给力，请稍后再试" andTitle:nil];
                        }else{
                            [Utilities popUpAlertViewWithMsg:nil andTitle:nil];
                        }
                    }];
                    
                } else {
                    [Utilities popUpAlertViewWithMsg:nil andTitle:nil];
                }
            }];
        }else{
            [Utilities popUpAlertViewWithMsg:@"俩次密码不一致，请重新输入" andTitle:nil];
        }
        
    }else{
        [Utilities popUpAlertViewWithMsg:@"与原密码不同，请重新输入" andTitle:nil];
    }

}
@end
