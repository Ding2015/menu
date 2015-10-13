//
//  SlidingViewController.m
//  mune
//
//  Created by 王杨杨杨 on 15/9/25.
//  Copyright (c) 2015年 就不给你上. All rights reserved.
//

#import "SlidingViewController.h"

@interface SlidingViewController ()

- (IBAction)logout:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)changeName:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)photoAc:(UITapGestureRecognizer *)sender;

@end

@implementation SlidingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back.jpg"]];
    [self readingUsername];
    [self readingUserphoto];
  
    
}

-(void)readingUsername{
    // 读取用户名
    PFUser *currentUser = [PFUser currentUser];
    self.userName.text=[NSString stringWithFormat:@"账号名：%@",currentUser[@"username"]];
}

- (void)readingUserphoto{
    
    // 下面两句作用：接收当前用户的头像
    PFUser *currentUser = [PFUser currentUser];
    PFFile *photo = currentUser[@"photo"];
    
    [photo getDataInBackgroundWithBlock:^(NSData *photoData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:photoData];
            dispatch_async(dispatch_get_main_queue(), ^{
                _photoIV.image = image;
            });
        }
    }];
}

- (void)savingPhoto{
    
    
    // 获取用户选择的照片，转化为PNG形式的二进制数据流
    NSData *photoData = UIImagePNGRepresentation(_photoIV.image);
    // 将PNG数据流储存在photoFile中，命名为photo.png
    PFFile *photoFile = [PFFile fileWithName:@"photo.png" data:photoData];
    // 将photoFile保存在表的Photo列中
    
    PFUser *currentUser = [PFUser currentUser];
    
    UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view]; // 添加菊花指示器
    
//    PFObject *item = [PFObject objectWithClassName:@"User"];
    
    currentUser[@"photo"] = photoFile;
    
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [aiv stopAnimating]; // 停止指示器运行
        if (succeeded) {
            [Utilities popUpAlertViewWithMsg:@"上传成功" andTitle:@"提示"];
            
        } else {
            [Utilities popUpAlertViewWithMsg:nil andTitle:nil];
        }
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// textview键盘收起
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) { // 按下回车时收起键盘（换行符）
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

// textfield键盘收起
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField { // 点击ruturn收起
    [theTextField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event { // 点击键盘外任意区域收起
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


- (IBAction)logout:(UIButton *)sender forEvent:(UIEvent *)event {
    [PFUser logOut];
    // 返回首页
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)changeName:(UIButton *)sender forEvent:(UIEvent *)event {
    
    [self readingUsername];
    UIAlertView *sellView = [[UIAlertView alloc]initWithTitle:@"警告" message:[NSString stringWithFormat:@"当前%@\n请输入你修改后的用户名",self.userName.text] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [sellView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    
    [sellView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==1) {
        [self readingUsername];
        UITextField *textField = [alertView textFieldAtIndex:0];
        if ([textField.text isEqualToString:@""]||[textField.text isEqualToString:self.userName.text]) {
            [Utilities popUpAlertViewWithMsg:@"你输入的用户名为空" andTitle:nil]
            ;
            return;
        }
        PFUser *user=[PFUser currentUser];
        user[@"username"]=textField.text;
        UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [aiv stopAnimating];
            if (succeeded) {
                [Utilities setUserDefaults:@"userName" content:textField.text];
                [Utilities popUpAlertViewWithMsg:@"成功修改，请重新登录" andTitle:nil];
                //回到上一页前更新页面的通知
                // [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:[NSNotification notificationWithName:@"refreshMine" object:self] waitUntilDone:YES];
                //返回上一页
                [PFUser logOut];//退出Parse
                //退出
                [self dismissViewControllerAnimated:YES completion:nil];
                
                //[self.navigationController popViewControllerAnimated:YES];
            } else {
                [Utilities popUpAlertViewWithMsg:nil andTitle:nil];
            }
        }];
    }
}

- (IBAction)photoAc:(UITapGestureRecognizer *)sender {
    
    // 弹出actionsheet
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
    [actionSheet setExclusiveTouch:YES];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // 2 = 按了第三个按钮
    if (buttonIndex == 2)
        return;
    // 0 = 按了第一个按钮（拍照，打开相机）
    UIImagePickerControllerSourceType temp;
    if (buttonIndex == 0) {
        temp = UIImagePickerControllerSourceTypeCamera;
    } else if (buttonIndex == 1) { // 1 = 按了第二个按钮（打开图库）
        temp = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    if ([UIImagePickerController isSourceTypeAvailable:temp]) {
        _imagePickerController = nil;
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
        _imagePickerController.allowsEditing = YES;
        _imagePickerController.sourceType = temp;
        [self presentViewController:_imagePickerController animated:YES completion:nil];
    } else {
        if (temp == UIImagePickerControllerSourceTypeCamera) {
            [Utilities popUpAlertViewWithMsg:@"当前设备无照相功能" andTitle:nil];
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 获得照片
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    _photoIV.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self savingPhoto];
    
}


@end
