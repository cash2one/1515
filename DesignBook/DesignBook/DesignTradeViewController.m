//
//  DesignTradeViewController.m
//  DesignBook
//
//  Created by Visitor on 14-11-9.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import "DesignTradeViewController.h"
#import "MyNavigationBar.h"
#import "MyHeaderView.h"
#import "DesignTradeCell.h"
#import "DesignTradeData.h"
#import "DownLoadManager.h"
#import "INTERFACE.h"
#import "MJRefresh.h"
@interface DesignTradeViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>

@end

@implementation DesignTradeViewController
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    DownLoadManager *_downLaodManager;
    
    MJRefreshHeaderView *_headerRefresh;
    MJRefreshFooterView *_footerRefresh;
    int _page;
    
    UIView *_infoView;
    UITableView *_infoTableView;
    NSMutableArray *_infoCityArr;
    NSMutableArray *_infoXMArr;
    
    NSMutableDictionary *_checkCityDict;
    NSMutableDictionary *_checkTtDict;
    int _btnTag;
    
    int _city;
    int _tt;
    
}
-(void)dealloc
{
    [_headerRefresh free];
    [_footerRefresh free];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.navigationController setNavigationBarHidden:YES];
        _downLaodManager = [DownLoadManager sharedDownLoadManager];
        _page = 1;
        _infoCityArr = [[NSMutableArray alloc]init];
        _infoXMArr = [[NSMutableArray alloc]init];
        _checkCityDict = [[NSMutableDictionary alloc]init];
        _checkTtDict = [[NSMutableDictionary alloc]init];
        _btnTag = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self createNavigationBar];
    [self createTableView];
    [self createInfoView];
    NSString *urlStr = [NSString stringWithFormat:kURL_DESIGN_TRADE,kDESIGNTRADE_RECENT,_city,_tt,8];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish:) name:urlStr object:nil];
    [_downLaodManager addDownLoadWithDownStr:urlStr andDownLoadType:kTYPE_DESIGNTRADE andIsRefresh:YES andDownLoadPage:-1];
    
}
-(void)createInfoView
{
    _infoView = [[UIView alloc]init];
    _infoView.frame = CGRectMake(0, 64, 320, self.view.bounds.size.height-64-49);
    _infoView.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.93f alpha:1.00f];
    _infoView.hidden = YES;
    [self.view addSubview:_infoView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, _infoView.bounds.size.height - 44, 320, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [_infoView addSubview:lineView];
    
    UIView *aView = [[UIView alloc]init];
    aView.frame = CGRectMake(0, _infoView.bounds.size.height - 44, 320, 44);
    [_infoView addSubview:aView];
    
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    clearBtn.frame = CGRectMake(10, (44 - 28)/2, 75,28);
    [clearBtn setTitle:@"清空选项" forState:UIControlStateNormal];
    clearBtn.backgroundColor = [UIColor colorWithRed:0.73f green:0.71f blue:0.70f alpha:1.00f];
    [clearBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [clearBtn addTarget:self action:@selector(okBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    clearBtn.tag = 11;
    [aView addSubview:clearBtn];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    okBtn.frame = CGRectMake(250, (44 - 28)/2, 55, 28);
    okBtn.backgroundColor = [UIColor redColor];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(okBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    okBtn.tag = 12;
    [aView addSubview:okBtn];
    
    
    UIButton *cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cityBtn.frame = CGRectMake(0, 0, 130, 40);
    [cityBtn setImage:[UIImage imageNamed:@"sjs_icon1.png"] forState:UIControlStateNormal];
    [cityBtn setTitle:@"   城       市" forState:UIControlStateNormal];
    cityBtn.backgroundColor = [UIColor whiteColor];
    [cityBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    cityBtn.tag = 1;
    cityBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [cityBtn addTarget:self action:@selector(infoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_infoView addSubview:cityBtn];

    UIButton *xmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    xmBtn.frame = CGRectMake(0, 40, 130, 40);
    [xmBtn setImage:[UIImage imageNamed:@"sjs_icon3.png"] forState:UIControlStateNormal];
    [xmBtn setTitle:@"   项目类型" forState:UIControlStateNormal];
    [xmBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    xmBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [xmBtn addTarget:self action:@selector(infoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    xmBtn.tag = 2;
    [_infoView addSubview:xmBtn];
    
    _infoTableView = [[UITableView alloc]initWithFrame:CGRectMake(130, 0, 320-130, _infoView.bounds.size.height - 44) style:UITableViewStylePlain];
    _infoTableView.delegate = self;
    _infoTableView.dataSource =self;
    [_infoView addSubview:_infoTableView];
    
    
    dispatch_queue_t confitQueue = dispatch_queue_create("config", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(confitQueue, ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"config_shejiben" ofType:@"txt"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *resultDict = rootDict[@"result"];
        
        for (int i = 65; i< 65+26; i++) {
            NSMutableArray *array = [[NSMutableArray alloc]init];
            for (NSDictionary *dict in resultDict[@"city"]) {
                if ([dict[@"en"] characterAtIndex:0] == i) {
                    [array addObject:dict];
                }
            }
            [_infoCityArr addObject:array];
        }
        _infoXMArr = resultDict[@"gz"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_infoTableView reloadData];
        });
    });
    
    
    
}
-(void)infoBtnClick:(UIButton *)btn
{
    for (UIView *view in _infoView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)view;
            if (btn.tag == button.tag) {
                button.backgroundColor = [UIColor whiteColor];
            }
            else{
                button.backgroundColor = [UIColor clearColor];
            }
        }
    }
    if(btn.tag == 1)
    {
        _btnTag = 1;
        [_infoTableView reloadData];
    }
    else if(btn.tag == 2)
    {
        _btnTag = 2;
        [_infoTableView reloadData];
    }
}
-(void)okBtnClick:(UIButton *)btn
{
    if (btn.tag == 12) {
        
        _infoView.hidden = YES;
        
        if ([_checkCityDict objectForKey:@"check"]) {
            NSArray *arr1 = [_infoCityArr objectAtIndex: ((NSIndexPath *)[_checkCityDict objectForKey:@"check"]).section];
            NSDictionary *dict1 = [arr1 objectAtIndex:((NSIndexPath *)[_checkCityDict objectForKey:@"check"]).row];
            _city = [[dict1 objectForKey:@"cityid"] intValue];
        }
        if ([_checkTtDict objectForKey:@"check"]) {
            NSDictionary *dict2 = [_infoXMArr objectAtIndex:((NSIndexPath *)[_checkTtDict objectForKey:@"check"]).row];
            _tt = [[dict2 objectForKey:@"id"] intValue];
        }
        
        [_headerRefresh beginRefreshing];
    }
    else if(btn.tag == 11)
    {
        //清空选项
        _city = 0;
        _tt = 0;
        [_checkCityDict removeAllObjects];
        [_checkTtDict removeAllObjects];
        [_infoTableView reloadData];
    }
    NSLog(@"city = %d,tt = %d",_city,_tt);
}
-(void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, 320, self.view.bounds.size.height-64-49) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource =self;
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
-(void)createNavigationBar
{
    [self.navigationController setNavigationBarHidden:YES];
    MyNavigationBar *mnb = [[MyNavigationBar alloc]init];
    mnb.frame = CGRectMake(0, 20, 320, 44);
    [mnb createMyNavigationBarWithBgImageName:nil andTitle:self.vcTitle andLeftBtnImageName:nil andLeftBtnTitle:nil andRightBtnImageName:@"sjs_filter.png" andRightBtnTitle:nil andClass:self andSEL:@selector(navigationBarBtnClick:)];
    self.view.backgroundColor = [UIColor colorWithRed:0.87f green:0.22f blue:0.20f alpha:1.00f];
    [self.view addSubview:mnb];
}

-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (refreshView == _headerRefresh) {
        _page = 1;
        if (_enterType == 0)
        {
            NSString *urlStr = [NSString stringWithFormat:kURL_DESIGN_TRADE,kDESIGNTRADE_RECENT,_city,_tt,8];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish:) name:urlStr object:nil];
            [_downLaodManager addDownLoadWithDownStr:urlStr andDownLoadType:kTYPE_DESIGNTRADE andIsRefresh:YES andDownLoadPage:-1];
        }
        else if(_enterType == 1)
        {
            NSString *urlStr = [NSString stringWithFormat:kURL_DESIGN_TRADE,kDESIGNTRADE_NOW,_city,_tt,8];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish:) name:urlStr object:nil];
            [_downLaodManager addDownLoadWithDownStr:urlStr andDownLoadType:kTYPE_DESIGNTRADE andIsRefresh:YES andDownLoadPage:-1];
        }
        else if(_enterType == 2)
        {
            NSString *urlStr = [NSString stringWithFormat:kURL_DESIGN_TRADE,kDESIGNTRADE_END,_city,_tt,8];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish:) name:urlStr object:nil];
            [_downLaodManager addDownLoadWithDownStr:urlStr andDownLoadType:kTYPE_DESIGNTRADE andIsRefresh:YES andDownLoadPage:-1];
        }
    }
    else if(refreshView == _footerRefresh)
    {
        _page++;
        if (_enterType == 0)
        {
            NSString *urlStr = [NSString stringWithFormat:kURL_DESIGN_TRADE,kDESIGNTRADE_RECENT,_city,_tt,8*_page];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish:) name:urlStr object:nil];
            [_downLaodManager addDownLoadWithDownStr:urlStr andDownLoadType:kTYPE_DESIGNTRADE andIsRefresh:YES andDownLoadPage:-1];
        }
        else if(_enterType == 1)
        {
            NSString *urlStr = [NSString stringWithFormat:kURL_DESIGN_TRADE,kDESIGNTRADE_NOW,_city,_tt,8*_page];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish:) name:urlStr object:nil];
            [_downLaodManager addDownLoadWithDownStr:urlStr andDownLoadType:kTYPE_DESIGNTRADE andIsRefresh:YES andDownLoadPage:-1];
        }
        else if(_enterType == 2)
        {
            NSString *urlStr = [NSString stringWithFormat:kURL_DESIGN_TRADE,kDESIGNTRADE_END,_city,_tt,8*_page];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish:) name:urlStr object:nil];
            [_downLaodManager addDownLoadWithDownStr:urlStr andDownLoadType:kTYPE_DESIGNTRADE andIsRefresh:YES andDownLoadPage:-1];
        }
    }
}
-(void)navigationBarBtnClick:(UIButton *)btn
{
    if (_infoView.hidden == YES) {
        _infoView.hidden = NO;
    }
    else
    {
        _infoView.hidden = YES;
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
    if (btn.tag == 0)
    {
        _dataArray = nil;
        _enterType = 0;
    }
    else if(btn.tag == 1)
    {
        _dataArray = nil;
        _enterType = 1;
    }
    else if(btn.tag == 2)
    {
        _dataArray = nil;
        _enterType = 2;
    }
     [_tableView reloadData];
    [_headerRefresh beginRefreshing];
}
#pragma mark - DownLoadManager
-(void)downLoadFinish:(NSNotification *)not
{
    _dataArray = [_downLaodManager getDataWithDownLoadString:not.name];
    [_headerRefresh endRefreshing];
    [_footerRefresh endRefreshing];
    [_tableView reloadData];
}

#pragma mark - TableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_tableView == tableView) {
         return _dataArray.count;
    }
    else
    {
        if (_btnTag == 1) {
            return [_infoCityArr[section] count];
        }
        else if(_btnTag == 2)
        {
            return [_infoXMArr count];
        }
    }
        return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_tableView == tableView) {
        DesignTradeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"DesignTradeCell" owner:self options:nil] lastObject];
        }
        DesignTradeData *dtd = [_dataArray objectAtIndex:indexPath.row];
        
        cell.nameLabel.text = dtd.zb_name;
        
        cell.squalLabel.text = [NSString stringWithFormat:@"%@㎡",dtd.zb_area];
        cell.cityLabel.text = dtd.shen;
        cell.attentionLabel.text = [NSString stringWithFormat:@"%@人已关注",dtd.follower];
        cell.timeLabel.text = dtd.puttime;
        if ([dtd.status.stringValue isEqual:@"0"]) {
            UIImage *image = [[UIImage imageNamed:@"jy_icon2.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0];
            cell.stateImageView.image = image;
        }
        else {
            UIImage *image = [[UIImage imageNamed:@"jy_icon1.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0];
            cell.stateImageView.image = image;
            cell.nowLabel.text = @"正在进行";
        }
        if ([dtd.zxys rangeOfString:@"-"].length>0) {
            cell.moneyLabel.text = dtd.zxys;
            cell.wanlabel.frame = CGRectMake(290, 54, 14, 14);
            cell.wanlabel.text = @"万以下";
            CGFloat mWidth = cell.moneyLabel.frame.size.width;
            cell.moneyLabel.frame = CGRectMake(201, 45, mWidth, 25);
        }
        else
        {
            cell.wanlabel.frame = CGRectMake(290-28, 54, 42, 14);
            cell.wanlabel.text = @"万以下";
            CGFloat mWidth = cell.moneyLabel.frame.size.width;
            cell.moneyLabel.frame = CGRectMake(201-28, 45, mWidth, 25);
        }
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"info"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"info"];
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            cell.textLabel.textColor = [UIColor darkGrayColor];
        }
        
        
        
        if (_btnTag == 1) {
            if ([[_checkCityDict objectForKey:@"check"] isEqual:indexPath]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            else
            {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            
            cell.textLabel.text = [[_infoCityArr[indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"cn"];
        }
        
        else if(_btnTag == 2)
        {
            if ([[_checkTtDict objectForKey:@"check"] isEqual:indexPath]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            else
            {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            cell.textLabel.text = [_infoXMArr[indexPath.row] objectForKey:@"name"];
        }
        
        return cell;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == _tableView) {
        NSArray *titleArray = [[NSArray alloc]initWithObjects:@"最近", @"正在进行", @"已结束", nil];
        MyHeaderView *mhv = [[MyHeaderView alloc]init];
        mhv.frame = CGRectMake(0, 64, 320, 45);
        [mhv createMyHeaderViewWithNameArray:titleArray andClass:self andSEL:@selector(myHeaderBtnClick:) andSelectIndex:_enterType];
        mhv.backgroundColor = [UIColor whiteColor];
        return mhv;
    }
    else
        return nil;
}
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == _infoTableView) {
        if (_btnTag == 1) {
            return [NSArray arrayWithObjects:@"A",@"•",@"C",@"•",@"F",@"•",@"H",@"•",@"J",@"•",@"L",@"•",@"O",@"•",@"Q",@"•",@"S",@"•",@"U",@"•",@"X",@"•",@"Z", nil];
        }
        else
        {
            return nil;
        }
    }
    return nil;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == _infoTableView) {
        if (_btnTag == 1) {
            NSArray *title = [NSArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", nil];
            return [title objectAtIndex:section];
        }
        else
            return nil;
    }
    else
        return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView) {
        return 85;
    }
    else
        return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_tableView == tableView) {
         return 45;
    }
    else
    {
        if (_btnTag == 1) {
            return 15;
        }
        else
        {
            return 0.001;
        }
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView) {
        
    }
    else
    {
        if (_btnTag == 1) {
            [_checkCityDict setValue:indexPath forKey:@"check"];
        }
        else{
            [_checkTtDict setValue:indexPath forKey:@"check"];
        }
        [_infoTableView reloadData];
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_tableView == tableView) {
        return 1;
    }
    else
    {
        if (_btnTag == 1) {
            return _infoCityArr.count;
        }
        else
        {
            return 1;
        }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
