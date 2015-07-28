
//
//  MineViewController.m
//  DesignBook
//
//  Created by Visitor on 14-11-6.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import "MineViewController.h"
#import "MyNavigationBar.h"
#import "MineIconView.h"
#import "LoginViewController.h"
//#import "UMSocial.h"
#import "UIImageView+WebCache.h"
#import "MyModifyInfoViewController.h"
#import "INTERFACE.h"


@interface MineViewController ()

@end

@implementation MineViewController
{
    UIScrollView *_mainScrollView;
    UILabel *_loginLabel;
    UIButton *_loginBtn;
    NSMutableData *_data;
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
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createMainScrollView];
    [self createNavigationBar];
    [self createMineHeaderView];
    [self createMineIconView];
}
-(void)createNavigationBar
{
    [self.navigationController setNavigationBarHidden:YES];
    self.view.backgroundColor = [UIColor colorWithRed:0.87f green:0.22f blue:0.20f alpha:1.00f];
    UIView *navView = [[UIView alloc]init];
    navView.frame = CGRectMake(0, 20, 320, 44);
    [self.view addSubview:navView];
    UILabel *label = [[UILabel alloc]init];
    label.frame = navView.bounds;
    label.text = self.vcTitle;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = [UIColor whiteColor];
    [navView addSubview:label];
    _loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _loginBtn.frame = CGRectMake(navView.bounds.size.width-10-50, (44-29)/2, 50, 29);
    [_loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _loginBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:_loginBtn];
}
-(void)loginBtnClick:(UIButton *)btn
{
    LoginViewController *lvc = [[LoginViewController alloc]init];
    //lvc.delegate = self;
    [self presentViewController:lvc animated:YES completion:^{}];
}
-(void)navigationBarBtnClick:(UIButton *)btn
{
    NSLog(@"aaa");
}
-(void)createMainScrollView
{
    _mainScrollView = [[UIScrollView alloc]init];
    _mainScrollView.frame = CGRectMake(0, 64, 320, [UIScreen mainScreen].bounds.size.height - 64-49);
    _mainScrollView.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.93f alpha:1.00f];
    _mainScrollView.contentSize = CGSizeMake(320, [UIScreen mainScreen].bounds.size.height - 64-48);
    [self.view addSubview:_mainScrollView];
}
-(void)createMineHeaderView
{
//    MineTitleView *mtv = [[MineTitleView alloc]init];
//    mtv.frame = CGRectMake(0, 0, 320, ([UIScreen mainScreen].bounds.size.height - 64-49)*120/367+5);
//    [mtv createMineTitleView];
//    [_mainScrollView addSubview:mtv];
    
    UIView *mtv = [[UIView alloc]init];
    mtv.frame = CGRectMake(0, 0, 320, ([UIScreen mainScreen].bounds.size.height - 64-49)*120/367+5);
    [_mainScrollView addSubview:mtv];
    
    UIImageView *bgImageView = [[UIImageView alloc]init];
    bgImageView.frame = CGRectMake(5, 0, 310, mtv.bounds.size.height);
    bgImageView.image = [UIImage imageNamed:@"my_header_bg.png"];
    [mtv addSubview:bgImageView];
    
    
    UIImage *leftImage = [UIImage imageNamed:@"my_left_icon.png"];
    UIImage *rightImage = [UIImage imageNamed:@"my_right_icon.png"];
    CGFloat space = (bgImageView.bounds.size.width - leftImage.size.width*2)/3.0;
    
    UIImageView *headImageView = [[UIImageView alloc] init];
    headImageView.frame = CGRectMake(5+space, 28, 50, 50);
    [headImageView setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"default_header.png"]];
    [mtv addSubview:headImageView];
    
    _loginLabel = [[UILabel alloc]init];
    _loginLabel.frame = CGRectMake(CGRectGetMaxX(headImageView.frame) + 15, headImageView.frame.origin.y, 200, 17);
    _loginLabel.text = @"未登录";
    _loginLabel.font = [UIFont systemFontOfSize:15];
    _loginLabel.textColor = [UIColor darkGrayColor];
    [mtv addSubview:_loginLabel];
    
    UILabel *detailLabel = [[UILabel alloc]init];
    detailLabel.frame = CGRectMake(CGRectGetMinX(_loginLabel.frame), CGRectGetMaxY(_loginLabel.frame)+8, 200, 15);
    detailLabel.text = @"简介 -";
    detailLabel.font = [UIFont systemFontOfSize:12];
    detailLabel.textColor = [UIColor darkGrayColor];
    [mtv addSubview:detailLabel];
    
    
    
    UIButton *leftIconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftIconBtn.frame = CGRectMake(5+space, CGRectGetMaxY(headImageView.frame)+5, leftImage.size.width, leftImage.size.height);
    [leftIconBtn setBackgroundImage:leftImage forState:UIControlStateNormal];
    NSString *coinStr = [NSString stringWithFormat:@"金币: 0"];
    [leftIconBtn setTitle:coinStr forState:UIControlStateNormal];
    leftIconBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [leftIconBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [leftIconBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [mtv addSubview:leftIconBtn];
    
    UIButton *rightIconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightIconBtn.frame = CGRectMake(CGRectGetMaxX(leftIconBtn.frame) + space, CGRectGetMaxY(headImageView.frame)+5, leftImage.size.width, leftImage.size.height);
    [rightIconBtn setBackgroundImage:rightImage forState:UIControlStateNormal];
    
    [rightIconBtn setTitle:@"    签到赚金币" forState:UIControlStateNormal];
    rightIconBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [rightIconBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightIconBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [mtv addSubview:rightIconBtn];
    
    UIImageView *enterImageView = [[UIImageView alloc]init];
    UIImage *enterImage = [UIImage imageNamed:@"table_arrow.png"];
    enterImageView.image = enterImage;
    enterImageView.frame = CGRectMake(280, (mtv.bounds.size.height - enterImage.size.height)/2-20, enterImage.size.width, enterImage.size.height);
    [mtv addSubview:enterImageView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(5+space, 28, 280, 50);
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = 1;
    [mtv addSubview:btn];
}
-(void)btnClick:(UIButton *)btn
{
    if (btn.tag == 1 && [[NSUserDefaults standardUserDefaults] objectForKey:@"msg"]) {
        MyModifyInfoViewController *mvc = [[MyModifyInfoViewController alloc]init];
        [self.navigationController pushViewController:mvc animated:YES];
    }
}
-(void)createMineIconView
{
    MineIconView *mivc = [[MineIconView alloc]init];
    mivc.frame = CGRectMake(0, ([UIScreen mainScreen].bounds.size.height - 64-49)*120/367+2, 320, [UIScreen mainScreen].bounds.size.height-([UIScreen mainScreen].bounds.size.height - 64-49)*120/367-64-49);
    [mivc createMineIconView];
    [_mainScrollView addSubview:mivc];
}
-(void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
                     
        if ([myDefault objectForKey:@"msg"]) {
            _loginLabel.text = [myDefault objectForKey:@"msg"];
            _loginBtn.hidden = YES;
        }
        else
        {
            _loginLabel.text = @"未登录";
            _loginBtn.hidden = NO;
        }

}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"登陆接收到响应");
    _data = [[NSMutableData alloc]init];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_data appendData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:_data options:NSJSONReadingMutableContainers error:nil];
    NSString *msg = [rootDict objectForKey:@"msg"];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:msg forKey:@"msg"];
    [userDefault synchronize];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
