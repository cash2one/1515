//
//  AskViewController.m
//  DesignBook
//
//  Created by Visitor on 14-11-9.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import "AskViewController.h"
#import "MyHeaderView.h"
#import "MyNavigationBar.h"
#import "AskCell.h"
#import "DownLoadManager.h"
#import "INTERFACE.h"
#import "AskSubViewController.h"
#import "SearchViewController.h"
#import "MJRefresh.h"
@interface AskViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>

@end

@implementation AskViewController
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    
    AskCell *_myCell;
    DownLoadManager *_downLoadManager;
    MJRefreshHeaderView *_headerRefresh;
    MJRefreshFooterView *_footerRefresh;
    int _page;

}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _myCell = [[AskCell alloc]init];
        _downLoadManager = [DownLoadManager sharedDownLoadManager];
        _page = 1;
    }
    return self;
}
-(void)dealloc
{
    [_headerRefresh free];
    [_footerRefresh free];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self createNavigationBar];
    [self createMyHeaderView];
    [self createTableView];
    NSString *urlStr = [NSString stringWithFormat:kURL_ASKANSWER,kASKANSWER_RECTNT,8];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(downLoadFinish:) name:urlStr object:nil];
    [_downLoadManager addDownLoadWithDownStr:urlStr andDownLoadType:kTYPE_ASKANSWER andIsRefresh:YES andDownLoadPage:-1];
    
}
-(void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, 320, self.view.bounds.size.height-64-49) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.93f alpha:1.00f];
    _tableView.separatorColor = [UIColor clearColor];
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
            NSString *urlStr = [NSString stringWithFormat:kURL_ASKANSWER,kASKANSWER_RECTNT,8];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish:) name:urlStr object:nil];
            [_downLoadManager addDownLoadWithDownStr:urlStr andDownLoadType:kTYPE_ASKANSWER andIsRefresh:YES andDownLoadPage:-1];
        }
        else if(_enterType == 1)
        {
            NSString *urlStr = [NSString stringWithFormat:kURL_ASKANSWER,kASKANSWER_HOT,8];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish:) name:urlStr object:nil];
            [_downLoadManager addDownLoadWithDownStr:urlStr andDownLoadType:kTYPE_ASKANSWER andIsRefresh:YES andDownLoadPage:-1];
        }
        else if(_enterType == 2)
        {
            NSString *urlStr = [NSString stringWithFormat:kURL_ASKANSWER,kASKANSWER_NEW,8];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish:) name:urlStr object:nil];
            [_downLoadManager addDownLoadWithDownStr:urlStr andDownLoadType:kTYPE_ASKANSWER andIsRefresh:YES andDownLoadPage:-1];
        }
        else if(_enterType == 3)
        {
            NSString *urlStr = [NSString stringWithFormat:kURL_ASKANSWER,kASKANSWER_WAIT,8];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish:) name:urlStr object:nil];
            [_downLoadManager addDownLoadWithDownStr:urlStr andDownLoadType:kTYPE_ASKANSWER andIsRefresh:YES andDownLoadPage:-1];
        }
    }
    else if(refreshView == _footerRefresh)
    {
        _page++;
        if (_enterType == 0) {
            NSString *urlStr = [NSString stringWithFormat:kURL_ASKANSWER,kASKANSWER_RECTNT,8*_page];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish:) name:urlStr object:nil];
            [_downLoadManager addDownLoadWithDownStr:urlStr andDownLoadType:kTYPE_ASKANSWER andIsRefresh:YES andDownLoadPage:-1];
        }
        else if(_enterType == 1)
        {
            NSString *urlStr = [NSString stringWithFormat:kURL_ASKANSWER,kASKANSWER_HOT,8*_page];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish:) name:urlStr object:nil];
            [_downLoadManager addDownLoadWithDownStr:urlStr andDownLoadType:kTYPE_ASKANSWER andIsRefresh:YES andDownLoadPage:-1];
        }
        else if(_enterType == 2)
        {
            NSString *urlStr = [NSString stringWithFormat:kURL_ASKANSWER,kASKANSWER_NEW,8*_page];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish:) name:urlStr object:nil];
            [_downLoadManager addDownLoadWithDownStr:urlStr andDownLoadType:kTYPE_ASKANSWER andIsRefresh:YES andDownLoadPage:-1];
        }
        else if(_enterType == 3)
        {
            NSString *urlStr = [NSString stringWithFormat:kURL_ASKANSWER,kASKANSWER_WAIT,8*_page];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish:) name:urlStr object:nil];
            [_downLoadManager addDownLoadWithDownStr:urlStr andDownLoadType:kTYPE_ASKANSWER andIsRefresh:YES andDownLoadPage:-1];
        }
    }
}
-(void)createNavigationBar
{
    [self.navigationController setNavigationBarHidden:YES];
    MyNavigationBar *mnb = [[MyNavigationBar alloc]init];
    mnb.frame = CGRectMake(0, 20, 320, 44);
    [mnb createMyNavigationBarWithBgImageName:nil andTitle:self.vcTitle andLeftBtnImageName:@"search.png" andLeftBtnTitle:nil andRightBtnImageName:@"sjs_filter.png" andRightBtnTitle:nil andClass:self andSEL:@selector(navigationBarBtnClick:)];
    self.view.backgroundColor = [UIColor colorWithRed:0.87f green:0.22f blue:0.20f alpha:1.00f];
    [self.view addSubview:mnb];
}
-(void)navigationBarBtnClick:(UIButton *)btn
{
    if (btn.tag == 1) {
        SearchViewController *svc = [[SearchViewController alloc]init];
        [self.navigationController pushViewController:svc animated:YES];
    }
}
-(void)createMyHeaderView
{
    NSArray *titleArray = [[NSArray alloc]initWithObjects:@"最近活跃", @"最热", @"最新", @"待回答" ,nil];
    MyHeaderView *mhv = [[MyHeaderView alloc]init];
    mhv.frame = CGRectMake(0, 64, 320, 45);
    [mhv createMyHeaderViewWithNameArray:titleArray andClass:self andSEL:@selector(myHeaderBtnClick:) andSelectIndex:0];
    mhv.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:mhv];
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
        _dataArray = nil;
    }
    else if(btn.tag == 1)
    {
        _enterType = 1;
        _dataArray = nil;
    }
    else if(btn.tag == 2)
    {
        _enterType = 2;
        _dataArray = nil;
    }
    else if(btn.tag == 3)
    {
        _enterType = 3;
        _dataArray = nil;
    }
    [_tableView reloadData];
    [_headerRefresh beginRefreshing];
    
}
#pragma mark - DownLoadManager
-(void)downLoadFinish:(NSNotification *)not
{
    _dataArray = [_downLoadManager getDataWithDownLoadString:not.name];
    [_headerRefresh endRefreshing];
    [_footerRefresh endRefreshing];
    [_tableView reloadData];
}
#pragma mark - TableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray[0] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[AskCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    [cell createUI];
    [cell setFrameWithAskAnswerItem:(AskAnswer *)[[_dataArray objectAtIndex:0] objectAtIndex:indexPath.row]];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_myCell createUI];
    [_myCell setFrameWithAskAnswerItem:(AskAnswer *)[[_dataArray objectAtIndex:0] objectAtIndex:indexPath.row]];
    return _myCell.baseView.bounds.size.height+5;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *titleArray = [[NSArray alloc]initWithObjects:@"最近活跃", @"最热", @"最新", @"待回答" ,nil];
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
    label.text = [NSString stringWithFormat:@"%@个问题",_dataArray[1]];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor whiteColor];
    [baseView addSubview:label];

    return mhv;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AskSubViewController *asvc = [[AskSubViewController alloc]init];
    asvc.idStr = ((AskAnswer *)[[_dataArray objectAtIndex:0] objectAtIndex:indexPath.row]).uid;
    [self.navigationController pushViewController:asvc animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 65;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
