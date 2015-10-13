//
//  ViewController.m
//  mune
//
//  Created by XZH on 15/9/21.
//  Copyright (c) 2015年 就不给你上. All rights reserved.
//
#import "Utilities.h"
#import "left.h"
#import "ViewController.h"
#import "TabViewController.h"
//#import "LeftViewController.h"
#import "ECSlidingConstants.h"
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
            [Utilities setUserDefaults:@"password" content:_PassWord.text];

            
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
    
    //监听通知都执行leftSwitch这个方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leftSwitchAction) name:@"leftSwitch" object:nil];
    //注册两个通知 有人发enablePanGes就手势激活
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enablePanGesOnSliding) name:@"enablePanGes" object:nil];
    //有人发enablePanGes就手势关闭
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disablePanGesOnSliding) name:@"disablePanGes" object:nil];
   
    
    
    //初始化slidingViewController并naviVC作为topview中间页面
    _slidingViewController = [ECSlidingViewController slidingWithTopViewController:naviVC];
    
    _slidingViewController.delegate = self;
    
    
    //topview增加手势tapping触摸panning拖拽
    _slidingViewController.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGesturePanning;
    
    //给naviVC的视图（naviVC.view）增加手势
    //导航对应导航系所有页面使第二个页面也能拖拽
    [naviVC.view addGestureRecognizer:self.slidingViewController.panGesture];
    
    //获得左边页面实例
    left *leftVC = [Utilities getStoryboardInstanceByIdentity:@"Left"];
    
    //underLeftViewController第三方的样式 可以滑 (设置侧滑左侧视图)
    _slidingViewController.underLeftViewController = leftVC;
    
    //滑到屏幕四分之一位置 anchorRightPeekAmount当滑出左侧菜单时 中间页面左边到屏幕右边的距离
    //右滑anchorLeftPeekAmount当滑出右侧页面时 中间页面右边到屏幕左边的距离
    _slidingViewController.anchorRightPeekAmount = UI_SCREEN_W / 6;
    //通知，自己监听，不管谁发送通知都执行leftSwitch方法
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(leftSwitchAction)name:@"leftSwitch" object:nil];
    
    
    [self presentViewController:_slidingViewController animated:YES completion:nil];
    //[self presentViewController:naviVC animated:YES completion:nil];
    
}

//键盘退出
//打开或关闭移门
- (void)leftSwitchAction {
    //如果当前页面在左边
    if (_slidingViewController.currentTopViewPosition == ECSlidingViewControllerTopViewPositionAnchoredRight) {
        //回正
        [_slidingViewController resetTopViewAnimated:YES];
    } else {//不在左边就滑到左边
        [_slidingViewController anchorTopViewToRightAnimated:YES];
    }
}
//登录
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
        return CGRectInfinite;
    }
}


#pragma mark - UIViewControllerAnimatedTransitioning
//设置转场动画时间间隔
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

//手势激活
- (void)enablePanGesOnSliding {
    _slidingViewController.panGesture.enabled = YES;
}
//手势关闭
- (void)disablePanGesOnSliding {
    _slidingViewController.panGesture.enabled = NO;
}




@end
