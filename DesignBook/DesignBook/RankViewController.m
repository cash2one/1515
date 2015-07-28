//
//  RankViewController.m
//  DesignBook
//
//  Created by Visitor on 14-11-6.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import "RankViewController.h"
#import "MyNavigationBar.h"
#import "RankBtnView.h"
#import "RankSubViewController.h"
#import "INTERFACE.h"
#import "SearchViewController.h"
#import "PersonName.h"
#import "DownLoadManager.h"
#import "PersonDetailViewController.h"

@interface RankViewController ()

@end

@implementation RankViewController
{
    NSMutableArray *_dataArray;
    NSTimer *_timer;
    UIView *_baseView;
    NSMutableArray *_baseViewArr;
    DownLoadManager *_downLoadManager;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _downLoadManager = [DownLoadManager sharedDownLoadManager];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self createNavigationBar];
    [self createRankShowNameView];
    [self createRankBtnView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish:) name:kURL_PERSON_NAME object:nil];
    [_downLoadManager addDownLoadWithDownStr:kURL_PERSON_NAME andDownLoadType:kTYPE_PERSON_NAME andIsRefresh:NO andDownLoadPage:-1];
    
}
-(void)createNavigationBar
{
    [self.navigationController setNavigationBarHidden:YES];
    MyNavigationBar *mnb = [[MyNavigationBar alloc]init];
    mnb.frame = CGRectMake(0, 20, 320, 44);
    [mnb createMyNavigationBarWithBgImageName:nil andTitle:self.vcTitle andLeftBtnImageName:nil andLeftBtnTitle:nil andRightBtnImageName:@"search.png" andRightBtnTitle:nil andClass:self andSEL:@selector(navigationBarBtnClick:)];
    self.view.backgroundColor = [UIColor colorWithRed:0.87f green:0.22f blue:0.20f alpha:1.00f];
    [self.view addSubview:mnb];
}
-(void)navigationBarBtnClick:(UIButton *)btn
{
    SearchViewController *svc = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:svc animated:YES];
}
-(void)createRankShowNameView
{
    _baseView = [[UIView alloc]init];
    _baseView.frame = CGRectMake(0, 64, 320, ([UIScreen mainScreen].bounds.size.height - 64-49)*120/367);
    _baseView.backgroundColor = [UIColor colorWithRed:0.87f green:0.22f blue:0.20f alpha:1.00f];
    [self.view addSubview:_baseView];
}

-(void)animate
{
    for (UIView *elementView in _baseView.subviews) {
        UIButton *btn = (UIButton *)elementView.subviews.lastObject;
        CGFloat k = (-2*(elementView.center.y - 80))/200.0;
        btn.titleLabel.font = [UIFont systemFontOfSize:(elementView.bounds.size.height/2)];
        if (k>0) {

            btn.alpha =1-k;
        }
        else
        {
            btn.alpha =1-k;
        }
        elementView.center = CGPointMake( elementView.center.x, elementView.center.y + 0.8);
        elementView.bounds = CGRectMake(0, 0,elementView.bounds.size.width + k, elementView.bounds.size.height + k);
    }
    static int n = 0;
    if (n %60 == 0) {
        int index = arc4random()%20;
        UIView *view;
        while (1) {
            if (((UIView *)[_baseViewArr objectAtIndex:index]).tag == 100) {
                view = (UIView *)[_baseViewArr objectAtIndex:index];
                break;
            }
            else
            {
                index = arc4random()%20;
            }
        }
        view.tag = 50;
        [_baseView addSubview:view];
        view.frame = CGRectMake(33+arc4random()%40, 0, 20, 10);
    }
    if (n %60 == 29 || n==0) {
        int index = arc4random()%20;
        UIView *view;
        while (1) {
            if (((UIView *)[_baseViewArr objectAtIndex:index]).tag == 100) {
                view = (UIView *)[_baseViewArr objectAtIndex:index];
                break;
            }
            else
            {
                index = arc4random()%20;
            }
        }
        view.tag = 50;
        [_baseView addSubview:view];
        view.frame = CGRectMake(139+arc4random()%40, 0, 20, 10);
    }
    if (n %60 == 59 || n==0) {
        int index = arc4random()%20;
        UIView *view;
        while (1) {
            if (((UIView *)[_baseViewArr objectAtIndex:index]).tag == 100) {
                view = (UIView *)[_baseViewArr objectAtIndex:index];
                break;
            }
            else
            {
                index = arc4random()%20;
            }
        }
        view.tag = 50;
        [_baseView addSubview:view];
        view.frame = CGRectMake(245+arc4random()%40, 0, 20, 10);
    }
    n++;
    for (UIView *elementView in _baseView.subviews) {
        if (elementView.center.y>150) {
            elementView.frame = CGRectMake(40+arc4random()%100, 0, 20, 10);
            elementView.alpha = 1;
            elementView.tag = 100;
            [elementView.subviews.lastObject setAlpha:0];
            [elementView removeFromSuperview];
        }
    }
}
-(void)createRankBtnView
{
    RankBtnView *rbv = [[RankBtnView alloc]init];
    rbv.frame = CGRectMake(0, ([UIScreen mainScreen].bounds.size.height - 64-49)*120/367+64, 320, [UIScreen mainScreen].bounds.size.height-([UIScreen mainScreen].bounds.size.height - 64-49)*120/367-64-49);
    [rbv createRankBtnViewWithClass:self andSEL:@selector(btnClick:)];
    [self.view addSubview:rbv];
}
-(void)btnClick:(UIButton *)btn
{
    RankSubViewController *rsvc = [[RankSubViewController alloc]init];
    if (btn.tag == 0) {
        rsvc.vcTitle = @"热心榜";
        rsvc.rtNum = kRANK_RX_RT;
        [self.navigationController pushViewController:rsvc animated:YES];
    }
    else if(btn.tag == 1)
    {
        rsvc.vcTitle = @"作品收藏榜";
        rsvc.rtNum = kRANK_SC_RT;
        [self.navigationController pushViewController:rsvc animated:YES];

    }
    else if(btn.tag == 2)
    {
        rsvc.vcTitle = @"口碑榜";
        rsvc.rtNum = kRANK_KB_RT;
        [self.navigationController pushViewController:rsvc animated:YES];

    }
    else if(btn.tag == 3)
    {
        rsvc.vcTitle = @"项目经验榜";
        rsvc.rtNum = kRANK_EX_RT;
        [self.navigationController pushViewController:rsvc animated:YES];

    }
    else if(btn.tag == 4)
    {
        rsvc.vcTitle = @"人气榜";
        rsvc.rtNum = kRANK_RQ_RT;
        [self.navigationController pushViewController:rsvc animated:YES];

    }
    else if(btn.tag == 5)
    {
        rsvc.vcTitle = @"头标最多榜";
        rsvc.rtNum = kRANK_TB_RT;
        [self.navigationController pushViewController:rsvc animated:YES];
    }
}
-(void)prepareNameLabel
{
    _baseViewArr = [[NSMutableArray alloc] init];
    for (int i = 0 ; i<_dataArray.count; i++) {
        UIView *bv = [[UIView alloc]init];
        bv.frame = CGRectMake(40+arc4random()%100, 0, 20, 10);
        bv.tag = 100;
        [_baseViewArr addObject:bv];
   
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.bounds = CGRectMake(0, 0, 300, 50);
        btn.center = CGPointMake(10, 5);
        [btn addTarget:self action:@selector(nameBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:5];
        btn.alpha = 0;
        [bv addSubview:btn];
        
        PersonName *name = [_dataArray objectAtIndex:i];
        btn.tag = i;
        [btn setTitle:name.nick forState:UIControlStateNormal];
    }
}
-(void)nameBtnClick:(UIButton *)btn
{
    PersonName *pname = [_dataArray objectAtIndex:btn.tag];
    PersonDetailViewController *pdvc = [[PersonDetailViewController alloc]init];
    pdvc.nick = pname.nick;
    pdvc.uid = pname.uid;
    [self.navigationController pushViewController:pdvc animated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    if (_timer.isValid == YES) {
        NSLog(@"isValid");
        [_timer setFireDate:[NSDate distantPast]];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_timer setFireDate:[NSDate distantFuture]];
}

#pragma mark - DownLoadManager
-(void)downLoadFinish:(NSNotification *)not
{
    _dataArray =[_downLoadManager getDataWithDownLoadString:not.name];
    [self prepareNameLabel];
    _timer = [NSTimer scheduledTimerWithTimeInterval:10/160.0 target:self selector:@selector(animate) userInfo:nil repeats:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
