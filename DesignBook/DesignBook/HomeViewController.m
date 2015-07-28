//
//  HomeViewController.m
//  DesignBook
//
//  Created by Visitor on 14-11-6.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import "HomeViewController.h"
#import "MyNavigationBar.h"
#import "HomeFocusView.h"
#import "DownLoadManager.h"
#import "HomeBtnView.h"
#import "FamousSjsView.h"
#import "HomeAskView.h"
#import "HomeNewZbView.h"
#import "SearchViewController.h"
#import "MJRefresh.h"

@interface HomeViewController ()<MJRefreshBaseViewDelegate>

@end

@implementation HomeViewController
{
    DownLoadManager *_downLoadManager;
    NSMutableArray *_dataArray;
    UIScrollView *_mainScrollView;
    MJRefreshHeaderView *_headerRefresh;
    
    HomeFocusView *_fv;
    HomeBtnView *_hbt;
    FamousSjsView *_fsv;
    UIView *_LotteryBtnbgView;
    HomeAskView *_askView;
    HomeNewZbView *_hnzv;
    
    UIImageView *_imageView;
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)removeImageView
{
    [UIView animateWithDuration:0.2 animations:^{
        _imageView.alpha = 0;
    } completion:^(BOOL finished) {
        [_imageView removeFromSuperview];
    }];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createNavigationBar];
    [self createMainScrollView];

    NSString *bgName = [NSString stringWithFormat:@"s_bg%d.png",arc4random()%2+1];
    _imageView = [[UIImageView alloc]init];
    _imageView.frame = self.view.bounds;
    _imageView.image = [UIImage imageNamed:bgName];
    _imageView.userInteractionEnabled = YES;
    [self.tabBarController.view addSubview:_imageView];
    
    UIImageView *logoImageView = [[UIImageView alloc]init];
    UIImage *logoImage = [UIImage imageNamed:@"s_logo.png"];
    logoImageView.image = logoImage;
    logoImageView.frame = CGRectMake((320-logoImage.size.width)/2, 300, logoImage.size.width, logoImage.size.height);
    [_imageView addSubview:logoImageView];
    
    
    [UIView animateWithDuration:1 animations:^{
        logoImageView.frame = CGRectMake((320-logoImage.size.width)/2, 450, logoImage.size.width, logoImage.size.height);
    } completion:^(BOOL finished) {
        [self performSelector:@selector(removeImageView) withObject:nil afterDelay:0.5];
    }];
    
    
    _downLoadManager = [DownLoadManager sharedDownLoadManager];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish) name:self.vcURLString object:nil];
    [_downLoadManager addDownLoadWithDownStr:self.vcURLString andDownLoadType:kTYPE_HOME andIsRefresh:YES andDownLoadPage:-1];
}

-(void)btnClick:(UIButton *)btn
{
    NSLog(@"btn.tag == %d",btn.tag);
}
-(void)downLoadFinish
{
    //askModule
    //famousSjs
    //hotImgArr
    //newZb
    
    _dataArray = [_downLoadManager getDataWithDownLoadString:self.vcURLString];
    [self createHomeFocusView];
    [self createHomeBtnView];
    [self createHomeFamousSjsView];
    [self createHomeLotteryBtn];
    [self createHomeAskView];
    [self createHomeNewZbView];
    [_headerRefresh endRefreshing];

}
-(void)createMainScrollView
{
    _mainScrollView = [[UIScrollView alloc]init];
    _mainScrollView.frame = CGRectMake(0, 64, 320, [UIScreen mainScreen].bounds.size.height-64);
    _mainScrollView.contentSize = CGSizeMake(320, 1100);
    _mainScrollView.backgroundColor = [UIColor whiteColor];
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_mainScrollView];
    
    _headerRefresh = [MJRefreshHeaderView header];
    _headerRefresh.scrollView = _mainScrollView;
    _headerRefresh.delegate = self;
    [_headerRefresh beginRefreshing];
    
}
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    _downLoadManager = [DownLoadManager sharedDownLoadManager];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish) name:self.vcURLString object:nil];
    [_downLoadManager addDownLoadWithDownStr:self.vcURLString andDownLoadType:kTYPE_HOME andIsRefresh:YES andDownLoadPage:-1];
}

-(void)createNavigationBar
{
    [self.navigationController setNavigationBarHidden:YES];
    MyNavigationBar *mnb = [[MyNavigationBar alloc]init];
    mnb.frame = CGRectMake(0, 20, 320, 44);
    [mnb createMyNavigationBarWithBgImageName:@"NavigatetBgc.png" andTitle:self.vcTitle andLeftBtnImageName:nil andLeftBtnTitle:nil andRightBtnImageName:@"search.png" andRightBtnTitle:nil andClass:self andSEL:@selector(navigationBarBtnClick:)];
    self.view.backgroundColor = [UIColor colorWithRed:0.87f green:0.22f blue:0.20f alpha:1.00f];
    [self.view addSubview:mnb];
    
    UIImageView *logoImageView = [[UIImageView alloc]init];
    UIImage *image = [UIImage imageNamed:@"logo.png"];
    logoImageView.image = image;
    logoImageView.frame = CGRectMake(10, (44 - image.size.height)/2, image.size.width, image.size.height);
    [mnb addSubview:logoImageView];
}
-(void)createHomeFocusView
{
    [_fv removeFromSuperview];
    _fv = [[HomeFocusView alloc]init];
    _fv.frame = CGRectMake(0, 0, 320, 155);
    [_fv createFocusViewWithHotImgArr:_dataArray andClass:self];
    _fv.backgroundColor = [UIColor yellowColor];
    [_mainScrollView addSubview:_fv];
}
-(void)createHomeBtnView
{
    [_hbt removeFromSuperview];
    _hbt = [[HomeBtnView alloc]initWithFrame:CGRectMake(0, 155, 320, 75)];
    [_hbt createBtnViewWithClass:[UIApplication sharedApplication].delegate andSEL:@selector(btnClick:)];
    [_mainScrollView addSubview:_hbt];
}
-(void)createHomeFamousSjsView
{
    [_fsv removeFromSuperview];
    _fsv = [[FamousSjsView alloc]init];
    _fsv.frame = CGRectMake(0, 155 + 75, 300, 275);
    [_fsv createFamousSjsViewWithArray:_dataArray addClass:self];
    [_mainScrollView addSubview:_fsv];
}

-(void)createHomeLotteryBtn
{
    [_LotteryBtnbgView removeFromSuperview];
    _LotteryBtnbgView = [[UIView alloc]init];
    _LotteryBtnbgView.frame = CGRectMake(0, 155 + 75+275, 320, 46);
    [_mainScrollView addSubview:_LotteryBtnbgView];
    UIButton *moneyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moneyBtn.frame = CGRectMake(20/3, 0, 150, 46);
    [moneyBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg_13.png"] forState:UIControlStateNormal];
    [moneyBtn setTitle:@"签到赚金币" forState:UIControlStateNormal];
    moneyBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [moneyBtn addTarget:self action:@selector(lotteryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    moneyBtn.tag = 0;
    [_LotteryBtnbgView addSubview:moneyBtn];
    
    UIButton *rewardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rewardBtn.frame = CGRectMake(20/3*2+150, 0, 150, 46);
    [rewardBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg_14.png"] forState:UIControlStateNormal];
    [rewardBtn setTitle:@"今日剩5次抽奖" forState:UIControlStateNormal];
    rewardBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [rewardBtn addTarget:self action:@selector(lotteryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    rewardBtn.tag = 1;
    [_LotteryBtnbgView addSubview:rewardBtn];
}
-(void)createHomeAskView
{
    
    _askView = [[HomeAskView alloc]init];
    _askView.frame = CGRectMake(0, 155 + 75 +275+50, 320, 310);
    [_askView createAskViewWithArray:_dataArray andClass:self];
    [_mainScrollView addSubview:_askView];
}
-(void)createHomeNewZbView
{
    [_hnzv removeFromSuperview];
    _hnzv = [[HomeNewZbView alloc]init];
    _hnzv.frame = CGRectMake(0, 155 + 75 +275+50 +310, 320, 150);
    [_hnzv createHomeNewZbViewWithArray:_dataArray];
    [_mainScrollView addSubview:_hnzv];
}
-(void)lotteryBtnClick:(UIButton *)btn
{
    if (btn.tag == 0) {
        
    }
    else{
        
    }
}
-(void)navigationBarBtnClick:(UIButton *)btn
{
    SearchViewController *svc = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:svc animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end