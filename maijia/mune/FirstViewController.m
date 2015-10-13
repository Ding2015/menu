//
//  FirstViewController.m
//  mune
//
//  Created by 王杨杨杨 on 15/9/21.
//  Copyright (c) 2015年 就不给你上. All rights reserved.
//

#import "FirstViewController.h"
#import "TabViewController.h"
#import "SlidingViewController.h"
@interface FirstViewController ()
- (IBAction)loginAction:(UIButton *)sender forEvent:(UIEvent *)event;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 退出程序用户名仍会保存（getUserDefaults方法的声明与实现存放在Utilities中）
    if (![[Utilities getUserDefaults:@"userName"] isKindOfClass:[NSNull class]]) {
        _userName.text = [Utilities getUserDefaults:@"userName"];
    }
}


- (void)popUpHomeTab
{
    
    // 登录按钮点击后跳转至TabViewController
    TabViewController *tabVC = [Utilities getStoryboardInstanceByIdentity:@"Tab"]; // 拿到StoryBoardID为“Tab”的页面
    
    
    UINavigationController* naviVC = [[UINavigationController alloc] initWithRootViewController:tabVC]; // 等于Editor-->EmbedIn-->添加一个导航控制器
    
    naviVC.navigationBarHidden = YES;
    
    _slidingViewController  = [ECSlidingViewController slidingWithTopViewController:naviVC]; // 设置topView
    _slidingViewController.delegate = self;
    //    _slidingViewController.defaultTransitionDuration = 0.25; // 设置动画时间
    
    // 给TopView增加手势（触摸Tapping 、拖拽Panning ）
    _slidingViewController.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGesturePanning;
    
    [naviVC.view addGestureRecognizer:_slidingViewController.panGesture]; // 表示ECSlidingViewControllerAnchoredGestureTapping和ECSlidingViewControllerAnchoredGesturePanning
    
    SlidingViewController *leftVC = [Utilities getStoryboardInstanceByIdentity:@"Left"]; // 拿到StoryBoardID为“Left”的页面
    
    _slidingViewController.underLeftViewController = leftVC; // 设置侧滑左侧视图
    
    _slidingViewController.anchorRightPeekAmount = UI_SCREEN_W / 4; // anchorRightPeekAmount：当划出左侧页面时，中间页面左边到屏幕右边的距离
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leftSwitchAction) name:@"leftSwitch" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enablePanGesOnSliding) name:@"enablePanGes" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disablePanGesOnSliding) name:@"disablePanGes" object:nil];
    
    [self presentViewController:_slidingViewController animated:YES completion:nil]; // 页面跳转至naviVC页面
}


#pragma mark - ECSlidingViewControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)slidingViewController:(ECSlidingViewController *)slidingViewController animationControllerForOperation:(ECSlidingViewControllerOperation)operation topViewController:(UIViewController *)topViewController {
    _operation = operation;
    return self;
}

- (id<ECSlidingViewControllerLayout>)slidingViewController:(ECSlidingViewController *)slidingViewController layoutControllerForTopViewPosition:(ECSlidingViewControllerTopViewPosition)topViewPosition {
    return self;
}

#pragma mark - ECSlidingViewControllerLayout

- (CGRect)slidingViewController:(ECSlidingViewController *)slidingViewController frameForViewController:(UIViewController *)viewController topViewPosition:(ECSlidingViewControllerTopViewPosition)topViewPosition {
    if (topViewPosition == ECSlidingViewControllerTopViewPositionAnchoredRight && viewController == slidingViewController.topViewController) {
        return [self topViewAnchoredRightFrame:slidingViewController];
    } else {
        return CGRectInfinite; // 返回中间页面的位置（topView的位置）
    }
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *topViewController = [transitionContext viewControllerForKey:ECTransitionContextTopViewControllerKey];
    UIViewController *underLeftViewController  = [transitionContext viewControllerForKey:ECTransitionContextUnderLeftControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    UIView *topView = topViewController.view;
    topView.frame = containerView.bounds;
    underLeftViewController.view.layer.transform = CATransform3DIdentity;
    
    if (_operation == ECSlidingViewControllerOperationAnchorRight) {
        [containerView insertSubview:underLeftViewController.view belowSubview:topView];
        
        [self topViewStartingStateLeft:topView containerFrame:containerView.bounds];
        [self underLeftViewStartingState:underLeftViewController.view containerFrame:containerView.bounds];
        
        NSTimeInterval duration = [self transitionDuration:transitionContext];
        [UIView animateWithDuration:duration animations:^{
            [self underLeftViewEndState:underLeftViewController.view];
            [self topViewAnchorRightEndState:topView anchoredFrame:[transitionContext finalFrameForViewController:topViewController]];
        } completion:^(BOOL finished) {
            if ([transitionContext transitionWasCancelled]) {
                underLeftViewController.view.frame = [transitionContext finalFrameForViewController:underLeftViewController];
                underLeftViewController.view.alpha = 1;
                [self topViewStartingStateLeft:topView containerFrame:containerView.bounds];
            }
            [transitionContext completeTransition:finished];
        }];
    } else if (_operation == ECSlidingViewControllerOperationResetFromRight) {
        [self topViewAnchorRightEndState:topView anchoredFrame:[transitionContext initialFrameForViewController:topViewController]];
        [self underLeftViewEndState:underLeftViewController.view];
        
        NSTimeInterval duration = [self transitionDuration:transitionContext];
        [UIView animateWithDuration:duration animations:^{
            [self underLeftViewStartingState:underLeftViewController.view containerFrame:containerView.bounds];
            [self topViewStartingStateLeft:topView containerFrame:containerView.bounds];
        } completion:^(BOOL finished) {
            if ([transitionContext transitionWasCancelled]) {
                [self underLeftViewEndState:underLeftViewController.view];
                [self topViewAnchorRightEndState:topView anchoredFrame:[transitionContext initialFrameForViewController:topViewController]];
            } else {
                underLeftViewController.view.alpha = 1;
                underLeftViewController.view.layer.transform = CATransform3DIdentity;
                [underLeftViewController.view removeFromSuperview];
            }
            [transitionContext completeTransition:finished];
        }];
    }
}

#pragma mark - Private

- (CGRect)topViewAnchoredRightFrame:(ECSlidingViewController *)slidingViewController {
    CGRect frame = slidingViewController.view.bounds;
    
    frame.origin.x = slidingViewController.anchorRightRevealAmount;
    frame.size.width = frame.size.width * 0.75;
    frame.size.height = frame.size.height * 0.75;
    frame.origin.y = (slidingViewController.view.bounds.size.height - frame.size.height) / 2;
    
    return frame;
}

- (void)topViewStartingStateLeft:(UIView *)topView containerFrame:(CGRect)containerFrame {
    topView.layer.transform = CATransform3DIdentity;
    topView.layer.position = CGPointMake(containerFrame.size.width / 2, containerFrame.size.height / 2);
}

- (void)underLeftViewStartingState:(UIView *)underLeftView containerFrame:(CGRect)containerFrame {
    underLeftView.alpha = 0;
    underLeftView.frame = containerFrame;
    underLeftView.layer.transform = CATransform3DMakeScale(1.25, 1.25, 1);
}

- (void)underLeftViewEndState:(UIView *)underLeftView {
    underLeftView.alpha = 1;
    underLeftView.layer.transform = CATransform3DIdentity;
}

- (void)topViewAnchorRightEndState:(UIView *)topView anchoredFrame:(CGRect)anchoredFrame {
    topView.layer.transform = CATransform3DMakeScale(0.75, 0.75, 1);
    topView.frame = anchoredFrame;
    topView.layer.position  = CGPointMake(anchoredFrame.origin.x + ((topView.layer.bounds.size.width * 0.75) / 2), topView.layer.position.y);
}


- (void)leftSwitchAction // 重新设置状态（如果在左侧触发这个方法就会回正，在中间时就会划到左边）
{
    if (_slidingViewController.currentTopViewPosition == ECSlidingViewControllerTopViewPositionAnchoredRight) {
        [_slidingViewController resetTopViewAnimated:YES];
    } else {
        [_slidingViewController anchorTopViewToRightAnimated:YES];
    }
}

// 允许手势
- (void)enablePanGesOnSliding
{
    _slidingViewController.panGesture.enabled = YES;
}

// 关闭手势
- (void)disablePanGesOnSliding
{
    _slidingViewController.panGesture.enabled = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([[[storageMgr singletonStorageMgr] objectForKey:@"signUp"] integerValue] == 1) {
        [[storageMgr singletonStorageMgr] removeObjectForKey:@"signUp"];
        [self popUpHomeTab];
    }
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

- (IBAction)loginAction:(UIButton *)sender forEvent:(UIEvent *)event {
    
    // 登录功能的实现：判断用户输入信息是否完整
    NSString *username = _userName.text;
    NSString *password = _passWord.text;
    
    if ([username isEqualToString:@""] || [password isEqualToString:@""]) {
        [Utilities popUpAlertViewWithMsg:@"请填写所有信息" andTitle:nil];
        return;
    }
    
    // 添加菊花指示器（方法声明与实现放在Utilities文件中）
    UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
    
    // 登录功能的实现：联网核对用户信息是否正确
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
        
        [aiv stopAnimating]; // 停止菊花指示器
        
        if (user) { // 登陆成功后执行以下操作
            
            [Utilities setUserDefaults:@"userame" content:username]; // 保留已登录过的账号
            
            _passWord.text = @""; // 清除密码
            
            [self popUpHomeTab]; // 执行popUpHomeTab方法，跳转至首页
            
        } else if (error.code == 101) {
            [Utilities popUpAlertViewWithMsg:@"用户名或密码错误" andTitle:nil];
        } else if (error.code == 100) {
            [Utilities popUpAlertViewWithMsg:@"网络不给力，请稍后再试" andTitle:nil];
        } else {
            [Utilities popUpAlertViewWithMsg:nil andTitle:nil];
        }
    }];

}



@end
