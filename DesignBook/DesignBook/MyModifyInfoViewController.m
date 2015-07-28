//
//  MyModifyInfoViewController.m
//  DesignBook
//
//  Created by Visitor on 14-11-18.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import "MyModifyInfoViewController.h"
#import "MyNavigationBar.h"
#import "DownLoadManager.h"
#import "MyInfoView.h"
#import "INTERFACE.h"
#import "MyInfo.h"
//#import "UMSocial.h"
@interface MyModifyInfoViewController ()

@end

@implementation MyModifyInfoViewController
{
    UIScrollView *_mainScrollView;
    DownLoadManager *_downLoadManager;
    MyInfoView *_infoView;
}
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
    [self createNavigationBar];
    
    _mainScrollView = [[UIScrollView alloc]init];
    _mainScrollView.frame = CGRectMake(0, 64, 320, self.view.bounds.size.height-64);
    _mainScrollView.contentSize = CGSizeMake(320, self.view.bounds.size.height-63);
    [self.view addSubview:_mainScrollView];

    
    _infoView = [[[NSBundle mainBundle]loadNibNamed:@"MyInfoView" owner:self options:nil]lastObject];
    _infoView.frame = CGRectMake(0, 0, 320, self.view.bounds.size.height-64);
    [_infoView.exitBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_mainScrollView addSubview:_infoView];
    
    NSString *msg = [[NSUserDefaults standardUserDefaults] objectForKey:@"msg"];
    
    if (msg.intValue>0) {
        _downLoadManager = [DownLoadManager sharedDownLoadManager];
        NSLog(@"下载");
        NSString *urlStr = [NSString stringWithFormat:kURL_MY_INFO,msg];
        NSLog(@"urlStr = %@",urlStr);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish:) name:urlStr object:nil];
        [_downLoadManager addDownLoadWithDownStr:urlStr andDownLoadType:kTYPE_MY_INFO andIsRefresh:YES andDownLoadPage:-1];
    }
    
    
}
-(void)btnClick:(UIButton *)btn
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"msg"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //[[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToSina  completion:^(UMSocialResponseEntity *response){
    //    NSLog(@"response is %@",response);
   // }];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)createNavigationBar
{
    [self.navigationController setNavigationBarHidden:YES];
    MyNavigationBar *mnb = [[MyNavigationBar alloc]init];
    mnb.frame = CGRectMake(0, 20, 320, 44);
    [mnb createMyNavigationBarWithBgImageName:nil andTitle:@"个人信息" andLeftBtnImageName:@"back_arrow.png" andLeftBtnTitle:nil andRightBtnImageName:nil andRightBtnTitle:nil andClass:self andSEL:@selector(navigationBarBtnClick:)];
    self.view.backgroundColor = [UIColor colorWithRed:0.87f green:0.22f blue:0.20f alpha:1.00f];
    [self.view addSubview:mnb];
}
-(void)navigationBarBtnClick:(UIButton *)btn
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)downLoadFinish:(NSNotification *)not
{
    NSMutableArray *dataArr = [_downLoadManager getDataWithDownLoadString:not.name];
    MyInfo *info = [dataArr objectAtIndex:0];
    _infoView.nameLabel.text = info.truename;
    _infoView.idLabel.text = [NSString stringWithFormat:@"ID:%@",info.uid];
    _infoView.emailLabel.text = info.email;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
