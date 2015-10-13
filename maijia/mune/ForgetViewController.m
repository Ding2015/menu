//
//  ForgetViewController.m
//  mune
//
//  Created by 王杨杨杨 on 15/9/21.
//  Copyright (c) 2015年 就不给你上. All rights reserved.
//

#import "ForgetViewController.h"

@interface ForgetViewController ()
- (IBAction)qdAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)phoneAction:(UIButton *)sender forEvent:(UIEvent *)event;

@end

@implementation ForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 键盘收起
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {//敲回车时，键盘缩回
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)qdAction:(UIButton *)sender forEvent:(UIEvent *)event {
}

- (IBAction)phoneAction:(UIButton *)sender forEvent:(UIEvent *)event {
    
    NSString *msg = [[NSString alloc]initWithFormat:@"这应该是一个电话号码，是否拨号？"];
    UIAlertView *confirmView = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [confirmView show];
    
}
@end
