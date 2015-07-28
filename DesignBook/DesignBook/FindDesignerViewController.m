//
//  FindDesignerViewController.m
//  DesignBook
//
//  Created by Visitor on 14-11-12.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import "FindDesignerViewController.h"
#import "MyNavigationBar.h"
#import "MyHeaderView.h"
#import "FindSjsCell.h"
#import "DownLoadManager.h"
#import "INTERFACE.h"
#import "FindSjsCell.h"
#import "UIImageView+WebCache.h"
#import "FindSjsResult.h"
#import "FindSjsData.h"
#import "PersonDetailViewController.h"
#import "AppDelegate.h"
#import "MJRefresh.h"
@interface FindDesignerViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>

@end

@implementation FindDesignerViewController
{
    UITableView *_tableView;
    DownLoadManager *_downLoadManager;
    NSMutableArray *_dataSource;
    
    MJRefreshHeaderView *_headerRefresh;
    MJRefreshFooterView *_footerRefresh;
    AppDelegate *_appD;
    int _page;
    
    
    UIView *_infoView;
    UITableView *_infoTableView;
    NSMutableArray *_infoCityArr;
    NSMutableArray *_infoKJArr;
    NSMutableArray *_infoFGArr;
    NSMutableArray *_infoNXArr;
    NSMutableArray *_infoSLArr;
    
    //NSMutableArray *_infoXMArr;
    
    NSMutableDictionary *_checkCityDict;
    
    NSMutableDictionary *_checkKJDict;
    NSMutableDictionary *_checkFGDict;
    NSMutableDictionary *_checkNXDict;
    NSMutableDictionary *_checkSLDict;
    
    int _btnTag;
    
    int _city;
    int _kj;
    int _fg;
    int _nx;
    int _sl;
    
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _downLoadManager = [DownLoadManager sharedDownLoadManager];
        _appD = [UIApplication sharedApplication].delegate;
        _page = 1;
        _infoCityArr = [[NSMutableArray alloc]init];
        _checkCityDict = [[NSMutableDictionary alloc]init];
        _checkKJDict = [[NSMutableDictionary alloc]init];
        _checkFGDict = [[NSMutableDictionary alloc]init];
        _checkNXDict = [[NSMutableDictionary alloc]init];
        _checkSLDict = [[NSMutableDictionary alloc]init];
        _btnTag = 1;
    }
    return self;
}
- (void)dealloc
{
    [_headerRefresh free];
    [_footerRefresh free];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self createNavigationBar];
    [self createTableView];
    [self createInfoView];
    
    
    NSString *urlStr = [NSString stringWithFormat:kURL_FIND_SJS,kFIND_SJS_RECTENT,_city,_kj,_nx,_sl,_fg,8];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish:) name:urlStr object:nil];
    [_downLoadManager addDownLoadWithDownStr:urlStr andDownLoadType:kTYPE_FIND_SJS andIsRefresh:YES andDownLoadPage:-1];
}

-(void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, 320, self.view.bounds.size.height - 64 - 49) style:UITableViewStylePlain];
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
        _page ++;
        if (_enterType == 0) {
            NSString *urlStr = [NSString stringWithFormat:kURL_FIND_SJS,kFIND_SJS_RECTENT,_city,_kj,_nx,_sl,_fg,8];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish:) name:urlStr object:nil];
            [_downLoadManager addDownLoadWithDownStr:urlStr andDownLoadType:kTYPE_FIND_SJS andIsRefresh:YES andDownLoadPage:-1];
        }
        else if(_enterType == 1)
        {
            NSString *urlStr = [NSString stringWithFormat:kURL_FIND_SJS,kFIND_SJS_WONDER,_city,_kj,_nx,_sl,_fg,8];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish:) name:urlStr object:nil];
            [_downLoadManager addDownLoadWithDownStr:urlStr andDownLoadType:kTYPE_FIND_SJS andIsRefresh:YES andDownLoadPage:-1];
        }
        else if(_enterType == 2)
        {
            NSString *urlStr = [NSString stringWithFormat:kURL_FIND_SJS,kFIND_SJS_SAMECITY,_city,_kj,_nx,_sl,_fg,8];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish:) name:urlStr object:nil];
            [_downLoadManager addDownLoadWithDownStr:urlStr andDownLoadType:kTYPE_FIND_SJS andIsRefresh:YES andDownLoadPage:-1];

        }
        else if(_enterType == 3)
        {
            NSString *urlStr = [NSString stringWithFormat:kURL_FIND_SJS,kFIND_SJS_REPUTATION,_city,_kj,_nx,_sl,_fg,8];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish:) name:urlStr object:nil];
            [_downLoadManager addDownLoadWithDownStr:urlStr andDownLoadType:kTYPE_FIND_SJS andIsRefresh:YES andDownLoadPage:-1];
        }
    }
    else if(refreshView == _footerRefresh)
    {
        _page++;
        if (_enterType == 0) {
            NSString *urlStr = [NSString stringWithFormat:kURL_FIND_SJS,kFIND_SJS_RECTENT,_city,_kj,_nx,_sl,_fg,8*_page];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish:) name:urlStr object:nil];
            [_downLoadManager addDownLoadWithDownStr:urlStr andDownLoadType:kTYPE_FIND_SJS andIsRefresh:YES andDownLoadPage:-1];
        }
        else if(_enterType == 1)
        {
            NSString *urlStr = [NSString stringWithFormat:kURL_FIND_SJS,kFIND_SJS_WONDER,_city,_kj,_nx,_sl,_fg,8*_page];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish:) name:urlStr object:nil];
            [_downLoadManager addDownLoadWithDownStr:urlStr andDownLoadType:kTYPE_FIND_SJS andIsRefresh:YES andDownLoadPage:-1];
        }
        else if(_enterType == 2)
        {
            NSString *urlStr = [NSString stringWithFormat:kURL_FIND_SJS,kFIND_SJS_SAMECITY,_city,_kj,_nx,_sl,_fg,8*_page];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish:) name:urlStr object:nil];
            [_downLoadManager addDownLoadWithDownStr:urlStr andDownLoadType:kTYPE_FIND_SJS andIsRefresh:YES andDownLoadPage:-1];
            
        }
        else if(_enterType == 3)
        {
            NSString *urlStr = [NSString stringWithFormat:kURL_FIND_SJS,kFIND_SJS_REPUTATION,_city,_kj,_nx,_sl,_fg,8*_page];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish:) name:urlStr object:nil];
            [_downLoadManager addDownLoadWithDownStr:urlStr andDownLoadType:kTYPE_FIND_SJS andIsRefresh:YES andDownLoadPage:-1];
        }
    }
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
    if (btn.tag == 0) {
        _appD.enterType = 0;
    }
    else if(btn.tag == 1)
    {
        _appD.enterType = 1;
    }
    else if(btn.tag == 2)
    {
        _appD.enterType = 2;
    }
    else if(btn.tag == 3)
    {
        _appD.enterType = 3;
    }
    _dataSource = nil;
    [_tableView reloadData];
    [_headerRefresh beginRefreshing];
}

#pragma mark - DownManager
-(void)downLoadFinish:(NSNotification *)not
{
    _dataSource = [_downLoadManager getDataWithDownLoadString:not.name];
    [_headerRefresh endRefreshing];
    [_footerRefresh endRefreshing];
    [_tableView reloadData];
}
#pragma mark - TableViewDelegate
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == _tableView) {
        NSArray *titleArray = [[NSArray alloc]initWithObjects:@"最近活跃", @"精彩作品", @"同城", @"口碑值", nil];
        MyHeaderView *mhv = [[MyHeaderView alloc]init];
        mhv.frame = CGRectMake(0, 64, 320, 45);
        [mhv createMyHeaderViewWithNameArray:titleArray andClass:self andSEL:@selector(myHeaderBtnClick:) andSelectIndex:_appD.enterType];
        mhv.backgroundColor = [UIColor whiteColor];
        
        UIView *baseView = [[UIView alloc]init];
        baseView.frame = CGRectMake(0, 45, 320, 20);
        baseView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [mhv addSubview:baseView];
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(5, 0, 150, 20);
        label.text = [NSString stringWithFormat:@"%@位设计师入驻",[_dataSource objectAtIndex:1] ];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor whiteColor];
        [baseView addSubview:label];
        return mhv;
    }
    else
        return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView) {
        
        FindSjsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sjsCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"FindSjsCell" owner:self options:nil]lastObject] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        FindSjsResult *fsr = [_dataSource lastObject];
        FindSjsData *fsd = (FindSjsData *)[fsr.data objectAtIndex:indexPath.row];
        
        [cell.HeadImageView setImageWithURL:[NSURL URLWithString:fsd.headphoto] placeholderImage:[UIImage imageNamed:@""]];
        cell.nameLabel.text = fsd.truename;
        cell.designLabel.text = [NSString stringWithFormat:@"设计作品/精: %@/%@",fsd.pic_num,fsd.elite_num];
        NSString *yuyueStr = [NSString stringWithFormat:@"预约%@次",fsd.yuyueNum];
        if (fsd.qiandanNum.intValue>0) {
            yuyueStr = [NSString stringWithFormat:@"预约%@次 签单%@个项目",fsd.yuyueNum,fsd.qiandanNum];
        }
        cell.yuyueLabel.text = yuyueStr;
        
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
            if ([[_checkKJDict objectForKey:@"check"] isEqual:indexPath]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            else
            {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            cell.textLabel.text = [_infoKJArr[indexPath.row] objectForKey:@"name"];
        }
        else if(_btnTag == 3)
        {
            if ([[_checkFGDict objectForKey:@"check"] isEqual:indexPath]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            else
            {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            cell.textLabel.text = [_infoFGArr[indexPath.row] objectForKey:@"name"];
        }
        else if(_btnTag == 4)
        {
            if ([[_checkNXDict objectForKey:@"check"] isEqual:indexPath]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            else
            {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            cell.textLabel.text = [_infoNXArr[indexPath.row] objectForKey:@"name"];
        }
        else if(_btnTag == 5)
        {
            if ([[_checkSLDict objectForKey:@"check"] isEqual:indexPath]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            else
            {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            cell.textLabel.text = [_infoSLArr[indexPath.row] objectForKey:@"name"];
        }
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == _tableView) {
        FindSjsResult *fsr = [_dataSource lastObject];
        FindSjsData *fsd = (FindSjsData *)[fsr.data objectAtIndex:indexPath.row];
        
        PersonDetailViewController *pdvc = [[PersonDetailViewController alloc]init];
        pdvc.uid = fsd.uid;
        pdvc.nick = fsd.truename;
        [self.navigationController pushViewController:pdvc animated:YES];
    }
    else{
            if (_btnTag == 1) {
                [_checkCityDict setValue:indexPath forKey:@"check"];
            }
            else if(_btnTag == 2){
                [_checkKJDict setValue:indexPath forKey:@"check"];
            }
            else if(_btnTag == 3){
                [_checkFGDict setValue:indexPath forKey:@"check"];
            }
            else if(_btnTag == 4){
                [_checkNXDict setValue:indexPath forKey:@"check"];
            }
            else if(_btnTag == 5){
                [_checkSLDict setValue:indexPath forKey:@"check"];
            }
            [_infoTableView reloadData];
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tableView) {
    FindSjsResult *fsr = [_dataSource lastObject];
    return fsr.data.count;
    }
    else
    {
        if (_btnTag == 1) {
            return [_infoCityArr[section] count];
        }
        else if(_btnTag == 2)
        {
            return [_infoKJArr count];
        }
        else if(_btnTag == 3)
        {
            return [_infoFGArr count];
        }
        else if(_btnTag == 4)
        {
            return [_infoNXArr count];
        }
        else if(_btnTag == 5)
        {
            return [_infoSLArr count];
        }
    }
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView) {
        return 73;
    }
    else
        return 40;
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
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_tableView == tableView) {
        return 65;
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

-(void)viewWillAppear:(BOOL)animated
{
    [_tableView reloadData];
}
#pragma mark - InfoTableView
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
    
    UIButton *kjBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    kjBtn.frame = CGRectMake(0, 40, 130, 40);
    [kjBtn setImage:[UIImage imageNamed:@"sjs_icon2.png"] forState:UIControlStateNormal];
    [kjBtn setTitle:@"   擅长空间" forState:UIControlStateNormal];
    [kjBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    kjBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [kjBtn addTarget:self action:@selector(infoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    kjBtn.tag = 2;
    [_infoView addSubview:kjBtn];
    
    UIButton *fgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    fgBtn.frame = CGRectMake(0, 80, 130, 40);
    [fgBtn setImage:[UIImage imageNamed:@"sjs_icon3.png"] forState:UIControlStateNormal];
    [fgBtn setTitle:@"   擅长风格" forState:UIControlStateNormal];
    [fgBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    fgBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [fgBtn addTarget:self action:@selector(infoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    fgBtn.tag = 3;
    [_infoView addSubview:fgBtn];
    
    UIButton *nxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nxBtn.frame = CGRectMake(0, 120, 130, 40);
    [nxBtn setImage:[UIImage imageNamed:@"sjs_icon4.png"] forState:UIControlStateNormal];
    [nxBtn setTitle:@"   设计年限" forState:UIControlStateNormal];
    [nxBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    nxBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [nxBtn addTarget:self action:@selector(infoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    nxBtn.tag = 4;
    [_infoView addSubview:nxBtn];
    
    UIButton *slBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    slBtn.frame = CGRectMake(0, 160, 130, 40);
    [slBtn setImage:[UIImage imageNamed:@"sjs_icon5.png"] forState:UIControlStateNormal];
    [slBtn setTitle:@"   实       力" forState:UIControlStateNormal];
    [slBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    slBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [slBtn addTarget:self action:@selector(infoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    slBtn.tag = 5;
    [_infoView addSubview:slBtn];
    
    
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
        //_infoXMArr = resultDict[@"gz"];
        _infoKJArr = resultDict[@"spec"];  //擅长空间
        _infoFGArr = resultDict[@"yz_lovestyle"]; //擅长风格
        _infoNXArr = resultDict[@"workyear"]; //设计年限
        _infoSLArr = resultDict[@"goodlevel"]; //实力
        dispatch_async(dispatch_get_main_queue(), ^{
            [_infoTableView reloadData];
        });
    });
    
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
        
        if ([_checkKJDict objectForKey:@"check"]) {
            NSDictionary *dict2 = [_infoKJArr objectAtIndex:((NSIndexPath *)[_checkKJDict objectForKey:@"check"]).row];
            _kj = [[dict2 objectForKey:@"id"] intValue];
        }
        if ([_checkFGDict objectForKey:@"check"]) {
            NSDictionary *dict2 = [_infoFGArr objectAtIndex:((NSIndexPath *)[_checkFGDict objectForKey:@"check"]).row];
            _fg = [[dict2 objectForKey:@"id"] intValue];
        }
        if ([_checkNXDict objectForKey:@"check"]) {
            NSDictionary *dict2 = [_infoNXArr objectAtIndex:((NSIndexPath *)[_checkNXDict objectForKey:@"check"]).row];
            _nx = [[dict2 objectForKey:@"id"] intValue];
        }
        if ([_checkSLDict objectForKey:@"check"]) {
            NSDictionary *dict2 = [_infoSLArr objectAtIndex:((NSIndexPath *)[_checkSLDict objectForKey:@"check"]).row];
            _sl = [[dict2 objectForKey:@"id"] intValue];
        }

        [_headerRefresh beginRefreshing];
    }
    else if(btn.tag == 11)
    {
        //清空选项
        _city = 0;
        _kj = 0;
        _fg = 0;
        _nx = 0;
        _sl = 0;
        
        [_checkCityDict removeAllObjects];
        [_checkKJDict removeAllObjects];
        [_checkFGDict removeAllObjects];
        [_checkNXDict removeAllObjects];
        [_checkSLDict removeAllObjects];
        
        [_infoTableView reloadData];
    }
    //NSLog(@"city = %d,tt = %d",_city,_tt);
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
    }
    else if(btn.tag == 2)
    {
        _btnTag = 2;
    }
    else if(btn.tag == 3)
    {
        _btnTag = 3;
    }
    else if(btn.tag == 4)
    {
        _btnTag = 4;
    }
    else if(btn.tag == 5)
    {
        _btnTag = 5;
    }
    
    [_infoTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
