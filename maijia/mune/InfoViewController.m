//
//  InfoViewController.m
//  mune
//
//  Created by 王杨杨杨 on 15/9/21.
//  Copyright (c) 2015年 就不给你上. All rights reserved.
//

#import "InfoViewController.h"

@interface InfoViewController ()
- (IBAction)phoneAction:(UIButton *)sender forEvent:(UIEvent *)event;

@end

@implementation InfoViewController

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

- (IBAction)phoneAction:(UIButton *)sender forEvent:(UIEvent *)event {
    
    NSString *msg = [[NSString alloc]initWithFormat:@"这应该是一个电话号码，是否拨号？"];
    UIAlertView *confirmView = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [confirmView show];
    
}
@end
