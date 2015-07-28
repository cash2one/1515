
//
//  RankSubViewController.m
//  DesignBook
//
//  Created by Visitor on 14-11-13.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import "RankSubViewController.h"
#import "MyNavigationBar.h"
#import "MyHeaderView.h"
#import "RankCell.h"
#import "DownLoadManager.h"
#import "INTERFACE.h"
#import "PersonDetailViewController.h"
#import "MJRefresh.h"
#import "SearchViewController.h"
@interface RankSubViewController ()<UITableViewDelegate,UITableViewDataSource,MJRefreshBaseViewDelegate>

@end

@implementation RankSubViewController
{
    UITableView *_tableView;
    NSMutableArray *_dataSource;
    DownLoadManager *_downLoadManager;
    MJRefreshHeaderView *_headerRefresh;
    MJRefreshFooterView *_footerRefresh;
    int _page;
}
- (void)dealloc
{
    [_headerRefresh free];
    [_footerRefresh free];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _downLoadManager = [DownLoadManager sharedDownLoadManager];
        _page = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self createNavigationBar];
    [self createTableView];
    
    NSString *urlStr = [NSString stringWithFormat:kURL_RANK,_rtNum,2,6];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish:) name:urlStr object:nil];
    [_downLoadManager addDownLoadWithDownStr:urlStr andDownLoadType:kTYPE_RANK andIsRefresh:YES andDownLoadPage:-1];
    
}
-(void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, 320, self.view.bounds.size.height - 49 - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.93f alpha:1.00f];
    [self.view addSubview:_tableView];
    
    _headerRefresh = [MJRefreshHeaderView header];
    _headerRefresh.scrollView = _tableView;
    _headerRefresh.delegate = self;
    [_headerRefresh beginRefreshing];
    
    _footerRefresh = [MJRefreshFooterView footer];
    _footerRefresh.scrollView = _tableView;
    _footerRefresh.delegate = self;
    
}
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (refreshView == _headerRefresh) {
        _page = 1;
        if (_enterType == 0) {
            NSString *urlStr = [NSString stringWithFormat:kURL_RANK,_rtNum,_enterType+1,6];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish:) name:urlStr object:nil];
            [_downLoadManager addDownLoadWithDownStr:urlStr andDownLoadType:kTYPE_RANK andIsRefresh:YES andDownLoadPage:-1];
        }
        else if(_enterType == 1)
        {
            NSString *urlStr = [NSString stringWithFormat:kURL_RANK,_rtNum,_enterType+1,6];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish:) name:urlStr object:nil];
            [_downLoadManager addDownLoadWithDownStr:urlStr andDownLoadType:kTYPE_RANK andIsRefresh:YES andDownLoadPage:-1];
            
        }
        else if(_enterType == 2)
        {
            NSString *urlStr = [NSString stringWithFormat:kURL_RANK,_rtNum,_enterType+1,6];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish:) name:urlStr object:nil];
            [_downLoadManager addDownLoadWithDownStr:urlStr andDownLoadType:kTYPE_RANK andIsRefresh:YES andDownLoadPage:-1];
        }

    }
    else if(refreshView == _footerRefresh)
    {
        _page++;
        if (_enterType == 0) {
            NSString *urlStr = [NSString stringWithFormat:kURL_RANK,_rtNum,_enterType+1,6*_page];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish:) name:urlStr object:nil];
            [_downLoadManager addDownLoadWithDownStr:urlStr andDownLoadType:kTYPE_RANK andIsRefresh:YES andDownLoadPage:-1];
        }
        else if(_enterType == 1)
        {
            NSString *urlStr = [NSString stringWithFormat:kURL_RANK,_rtNum,_enterType+1,6*_page];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish:) name:urlStr object:nil];
            [_downLoadManager addDownLoadWithDownStr:urlStr andDownLoadType:kTYPE_RANK andIsRefresh:YES andDownLoadPage:-1];
            
        }
        else if(_enterType == 2)
        {
            NSString *urlStr = [NSString stringWithFormat:kURL_RANK,_rtNum,_enterType+1,6*_page];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish:) name:urlStr object:nil];
            [_downLoadManager addDownLoadWithDownStr:urlStr andDownLoadType:kTYPE_RANK andIsRefresh:YES andDownLoadPage:-1];
        }
    }
}

-(void)createNavigationBar
{
    [self.navigationController setNavigationBarHidden:YES];
    MyNavigationBar *mnb = [[MyNavigationBar alloc]init];
    mnb.frame = CGRectMake(0, 20, 320, 44);
    [mnb createMyNavigationBarWithBgImageName:nil andTitle:self.vcTitle andLeftBtnImageName:@"back_arrow.png" andLeftBtnTitle:nil andRightBtnImageName:@"search.png" andRightBtnTitle:nil andClass:self andSEL:@selector(navigationBarBtnClick:)];
    self.view.backgroundColor = [UIColor colorWithRed:0.87f green:0.22f blue:0.20f alpha:1.00f];
    [self.view addSubview:mnb];
}

-(void)navigationBarBtnClick:(UIButton *)btn
{
    if (btn.tag == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        SearchViewController *svc = [[SearchViewController alloc]init];
        [self.navigationController pushViewController:svc animated:YES];
    }
}
-(void)myHeaderBtnClick:(UIButton *)btn
{
    if (btn.selected == YES) {
        return;
    }
    for (UIView *view in btn.superview.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)view;
            if (btn.tag == button.tag) {
                button.selected = YES;
            }
            else
                button.selected = NO;
        }
    }
    if (btn.tag == 0) {
        _enterType = 0;
    }
    else if(btn.tag == 1)
    {
        _enterType = 1;
    }
    else if(btn.tag == 2)
    {
        _enterType = 2;
    }
    _dataSource = nil;
    [_tableView reloadData];
    [_headerRefresh beginRefreshing];
}
#pragma mark -DownLoadManager
-(void)downLoadFinish:(NSNotification *)not
{
    _dataSource = [_downLoadManager getDataWithDownLoadString:not.name];
    [_tableView reloadData];
    [_headerRefresh endRefreshing];
    [_footerRefresh endRefreshing];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:not.name object:nil];
    
}
#pragma mark - TableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [[_dataSource objectAtIndex:1] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RankCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[RankCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    for (UIView *subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    
    NSArray *arr = [_dataSource objectAtIndex:1];
    [cell createUI];
    [cell setFrameWithRankList:(RankList *)[arr objectAtIndex:indexPath.row] andClass:self];
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *titleArray = [[NSArray alloc]initWithObjects:@"今日", @"本周", @"本月",nil];
    MyHeaderView *mhv = [[MyHeaderView alloc]init];
    mhv.frame = CGRectMake(0, 64, 320, 45);
    [mhv createMyHeaderViewWithNameArray:titleArray andClass:self andSEL:@selector(myHeaderBtnClick:) andSelectIndex:_enterType];
    mhv.backgroundColor = [UIColor whiteColor];
    
    UIView *baseView = [[UIView alloc]init];
    baseView.frame = CGRectMake(0, 45, 320, 20);
    baseView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [mhv addSubview:baseView];
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(5, 0, 150, 20);
    
    NSNumber *myRank = [_dataSource objectAtIndex:0];
    if (myRank.intValue == 0) {
        label.text = [NSString stringWithFormat:@"您没有登录,无法显示排名"];
    }
    else
    {
        label.text = [NSString stringWithFormat:@"您的排名,第%d名",myRank.intValue];
    }
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor whiteColor];
    [baseView addSubview:label];
    
    return mhv;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arr = [_dataSource objectAtIndex:1];
    RankList *rl = [arr objectAtIndex:indexPath.row];
    PersonDetailViewController *pdvc = [[PersonDetailViewController alloc]init];
    pdvc.nick = rl.nick;
    pdvc.uid = rl.uid;
    [self.navigationController pushViewController:pdvc animated:YES];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 64;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
