
//
//  BlogViewController.m
//  DesignBook
//
//  Created by Visitor on 14-11-12.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import "BlogViewController.h"
#import "INTERFACE.h"
#import "MyNavigationBar.h"
@interface BlogViewController ()

@end

@implementation BlogViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self createNavigationBar];
    NSString *urlString = [NSString stringWithFormat:kURL_ARTICLE,_uid,_lid];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, 320, self.view.bounds.size.height)];
    [webView loadRequest:request];
    [self.view addSubview:webView];
    
}
-(void)createNavigationBar
{
    [self.navigationController setNavigationBarHidden:YES];
    MyNavigationBar *mnb = [[MyNavigationBar alloc]init];
    mnb.frame = CGRectMake(0, 20, 320, 44);
    [mnb createMyNavigationBarWithBgImageName:nil andTitle:@"博文" andLeftBtnImageName:@"back_arrow.png" andLeftBtnTitle:nil andRightBtnImageName:nil andRightBtnTitle:nil andClass:self andSEL:@selector(navigationBarBtnClick:)];
    self.view.backgroundColor = [UIColor colorWithRed:0.87f green:0.22f blue:0.20f alpha:1.00f];
    [self.view addSubview:mnb];
}
-(void)navigationBarBtnClick:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
    UIView *myT = [self.tabBarController.view.subviews lastObject];
    myT.hidden = YES;
    
    UIView *view = [self.tabBarController.view.subviews objectAtIndex:0];
    view.frame = CGRectMake(0, 0, 320, self.view.bounds.size.height);
}
-(void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
    UIView *myT = [self.tabBarController.view.subviews lastObject];
    myT.hidden = NO;
    
    UIView *view = [self.tabBarController.view.subviews objectAtIndex:0];
    view.frame = CGRectMake(0, 0, 320, self.view.bounds.size.height-49);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
