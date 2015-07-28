//
//  AppDelegate.m
//  DesignBook
//
//  Created by Visitor on 14-11-6.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "RankViewController.h"
#import "HomeViewController.h"
#import "MineViewController.h"
#import "PublicViewController.h"
#import "MyTabBar.h"
#import "MyButton.h"
//#import "UMSocial.h"



@implementation AppDelegate
{
    UITabBarController *_tbc;
    UIView *_nviView;
    UIView *_baseView;
    UIButton *_naviBtn;
    BOOL _isClick;
    MyTabBar *_mtb;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    //[UMSocialData setAppKey:@"54682b36fd98c509e9001066"];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    NSString *vcPlistStr = [[NSBundle mainBundle] pathForResource:@"VCConfig" ofType:@"plist"];
    NSArray *vcArray = [NSArray arrayWithContentsOfFile:vcPlistStr];
    NSMutableArray *controllers = [[NSMutableArray alloc]init];
    for (NSDictionary *vcDict in vcArray) {
        if ([vcDict[@"type"] length]>0) {
            RootViewController *rvc = [[NSClassFromString(vcDict[@"type"]) alloc]init];
            rvc.vcTitle = vcDict[@"title"];
            rvc.vcURLString = vcDict[@"urlString"];
            rvc.title = rvc.vcTitle;
            UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:rvc];
            [nvc setNavigationBarHidden:YES animated:NO];
            [controllers addObject:nvc];
        }
    }
    _tbc = [[UITabBarController alloc]init];
    _tbc.tabBar.frame = CGRectMake(1, 1000, 1, 1);
    _tbc.viewControllers = controllers;
    _tbc.selectedIndex = 1;
    
    self.window.rootViewController = _tbc;
    
    _mtb = [MyTabBar sharedMyTabBar];
    _mtb.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-49, 320, 49);
    [_mtb createMyTabBarWithBgImageName:@"tabbar_bg1" andViewControllerPlistName:@"tabBar.plist" andClass:self andSEL:@selector(btnClick:)];
    [_tbc.view addSubview:_mtb];

    //导航视图 114x35;
    _nviView = [[UIView alloc]init];
    _nviView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    _nviView.frame = CGRectMake(0, 20, 320, [UIScreen mainScreen].bounds.size.height-49-20);
    [self.window addSubview:_nviView];
    _nviView.hidden = YES;
    
    
    
    
    _baseView = [[UIView alloc]init];
    _baseView.autoresizesSubviews = YES;
    _baseView.layer.anchorPoint = CGPointMake(0.5, 1);
    _baseView.frame = CGRectMake(20, _nviView.bounds.size.height - 220, 114, 200);
    CGFloat space = (200 -35*4)/4.0/2.0;
    for (int i = 0; i<4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame  = CGRectMake(0,space +(35+2*space)*i, 114, 35);
        NSString *norStr = [NSString stringWithFormat:@"menu_icon%d.png",i+1];
        NSString *selStr = [NSString stringWithFormat:@"menu_icon%d_sel.png",i+1];
        [btn setImage:[UIImage imageNamed:norStr] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:selStr] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 5+i;
        btn.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_baseView addSubview:btn];
    }
    [_nviView addSubview:_baseView];
    
    _baseView.transform = CGAffineTransformMakeScale(1, 0.0001f);
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
    
    
}

-(void)btnClick:(id)sender
{
    if ([sender isKindOfClass:[MyButton class]]) {
        MyButton *myBtn = (MyButton *)sender;
        self.enterType = myBtn.enterType;
    }
    UIButton *btn = (UIButton *)sender;
    _tbc.moreNavigationController.navigationBarHidden = YES;
    if (btn.tag == 0) {
        [self.window bringSubviewToFront:_nviView];
        if (_isClick == NO) {
            _naviBtn = btn;
            _nviView.hidden = NO;
            btn.selected = YES;
            [UIView animateWithDuration:0.3 animations:^{
                _baseView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                _isClick = YES;
                _baseView.frame = CGRectMake(20, _nviView.bounds.size.height - 220, 114, 200);
            }];
            
        }
        else {
            btn.selected = NO;
            [UIView animateWithDuration:0.3 animations:^{
                _baseView.transform = CGAffineTransformMakeScale(1, 0.0001f);
            } completion:^(BOOL finished) {
                _isClick = NO;
                _nviView.hidden = YES;
            }];
        }
    }
    else {
        for (UIView *baseView in _mtb.subviews) {
            if (![baseView isKindOfClass:[UIImageView class]]) {
                //baseView
                UIButton *button = (UIButton *)[baseView.subviews lastObject];
                if (button.tag != 0) {
                    button.selected = NO;
                }
            }
        }
        for (UIView *subView in _baseView.subviews) {
            UIButton *button = (UIButton *)subView;
            if (button.tag == btn.tag) {
                button.selected = YES;
            }
            else
            {
                button.selected = NO;
            }
        }
        if (btn.tag>4) {
            [UIView animateWithDuration:0.3 animations:^{
                _baseView.transform = _baseView.transform = CGAffineTransformMakeScale(1, 0.0001f);
            } completion:^(BOOL finished) {
                _isClick = NO;
                _naviBtn.selected = NO;
                _nviView.hidden = YES;
            }];
        }
        
        btn.selected = YES;
        _tbc.selectedIndex = btn.tag-1;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _naviBtn.selected = NO;
    [UIView animateWithDuration:0.3 animations:^{
        _baseView.transform = _baseView.transform = CGAffineTransformMakeScale(1, 0.0001f);
    } completion:^(BOOL finished) {
        _isClick = NO;
        _nviView.hidden = YES;
    }];
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
