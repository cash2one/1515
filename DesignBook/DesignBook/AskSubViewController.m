//
//  AskSubViewController.m
//  DesignBook
//
//  Created by Visitor on 14-11-13.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import "AskSubViewController.h"
#import "Answer.h"
#import "Question.h"
#import "MyNavigationBar.h"
#import "UIImageView+WebCache.h"
#import "DownLoadManager.h"
#import "INTERFACE.h"
#import "AskSubCell.h"
#import "MJRefresh.h"
@interface AskSubViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>

@end

@implementation AskSubViewController
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    UIView *_baseView;
    DownLoadManager *_downLoadManager;
    AskSubCell *_myCell;
    UIView *_bottomView;
    
    MJRefreshHeaderView *_headerRefresh;
    MJRefreshFooterView *_footerRefresh;
    int _page;
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _downLoadManager = [DownLoadManager sharedDownLoadManager];
        _myCell = [[AskSubCell alloc]init];
        _page = 1;
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
    
    NSString *urlStr = [NSString stringWithFormat:kURL_ASKANSWER_SUB,_idStr.intValue,6];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(downLoadFinish:) name:urlStr object:nil];
    [_downLoadManager addDownLoadWithDownStr:urlStr andDownLoadType:kTYPE_SUBASKANSWER andIsRefresh:YES andDownLoadPage:-1];
    
}
-(void)createNavigationBar
{
    [self.navigationController setNavigationBarHidden:YES];
    MyNavigationBar *mnb = [[MyNavigationBar alloc]init];
    mnb.frame = CGRectMake(0, 20, 320, 44);
    [mnb createMyNavigationBarWithBgImageName:nil andTitle:@"有问必答" andLeftBtnImageName:@"back_arrow.png" andLeftBtnTitle:nil andRightBtnImageName:nil andRightBtnTitle:nil andClass:self andSEL:@selector(navigationBarBtnClick:)];
    self.view.backgroundColor = [UIColor colorWithRed:0.87f green:0.22f blue:0.20f alpha:1.00f];
    [self.view addSubview:mnb];
}
-(void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, 320, self.view.bounds.size.height - 64 - 49) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
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
        NSString *urlStr = [NSString stringWithFormat:kURL_ASKANSWER_SUB,_idStr.intValue,6];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(downLoadFinish:) name:urlStr object:nil];
        [_downLoadManager addDownLoadWithDownStr:urlStr andDownLoadType:kTYPE_SUBASKANSWER andIsRefresh:YES andDownLoadPage:-1];
    }
    else if(refreshView == _footerRefresh)
    {
        _page++;
        NSString *urlStr = [NSString stringWithFormat:kURL_ASKANSWER_SUB,_idStr.intValue,6*_page];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(downLoadFinish:) name:urlStr object:nil];
        [_downLoadManager addDownLoadWithDownStr:urlStr andDownLoadType:kTYPE_SUBASKANSWER andIsRefresh:YES andDownLoadPage:-1];
    }
}

-(void)navigationBarBtnClick:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
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
    return [[_dataArray objectAtIndex:0] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AskSubCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[AskSubCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    for (UIView *subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    Answer *as = [[_dataArray objectAtIndex:0] objectAtIndex:indexPath.row];
    [cell createUI];
    [cell setFrameWith:as andClass:self];
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    Question *qs = [_dataArray lastObject];
    
    _baseView = [[UIView alloc]init];
    _baseView.backgroundColor = [UIColor whiteColor];
    CGSize titleSize = [qs.title sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(290, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 290, titleSize.height)];
    titleLabel.text = qs.title;
    titleLabel.font = [UIFont boldSystemFontOfSize:14];
    titleLabel.textColor = [UIColor darkGrayColor];
    [_baseView addSubview:titleLabel];

    UIImageView *titleImageView = [[UIImageView alloc]init];
    titleImageView.frame = CGRectMake(15, CGRectGetMaxY(titleLabel.frame)+5, 1, 1);
    if (qs.total_pic.count>0) {
        titleImageView.frame = CGRectMake(15, CGRectGetMaxY(titleLabel.frame)+5, 290, 140);
        titleImageView.contentMode = UIViewContentModeScaleAspectFill;
        titleImageView.clipsToBounds = YES;
        [titleImageView setImageWithURL:[NSURL URLWithString:[qs.total_pic objectAtIndex:0]]];
        [_baseView addSubview:titleImageView];

    }

    UIImageView *headImageView = [[UIImageView alloc]init];
    UIImage *headImage = [UIImage imageNamed:@"ask_icon5.png"];
    headImageView.image = headImage;
    headImageView.frame = CGRectMake(15, CGRectGetMaxY(titleImageView.frame)+5, 14, 14);
    [_baseView addSubview:headImageView];
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.frame = CGRectMake(35, CGRectGetMaxY(titleImageView.frame)+5, 150, 14);
    nameLabel.font = [UIFont systemFontOfSize:11];
    nameLabel.textColor = [UIColor lightGrayColor];
    nameLabel.text = [NSString stringWithFormat:@"%@",qs.nick];
    [_baseView addSubview:nameLabel];
    
    UIImageView *timeImageView = [[UIImageView alloc]init];
    timeImageView.frame  = CGRectMake(190, CGRectGetMaxY(titleImageView.frame)+5, 14, 14);
    timeImageView.image = [UIImage imageNamed:@"ask_icon1.png"];
    [_baseView addSubview:timeImageView];
    
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.frame = CGRectMake(210, CGRectGetMaxY(titleImageView.frame)+5, 50, 14);
    timeLabel.text = qs.createtime;
    timeLabel.font = [UIFont systemFontOfSize:11];
    timeLabel.textColor = [UIColor lightGrayColor];
    [_baseView addSubview:timeLabel];
    
    UIImageView *eyeImageView = [[UIImageView alloc]init];
    eyeImageView.frame = CGRectMake(269, CGRectGetMaxY(titleImageView.frame)+5, 14, 14);
    eyeImageView.image = [UIImage imageNamed:@"ask_icon3.png"];
    [_baseView addSubview:eyeImageView];
    
    UILabel *eyeLabel = [[UILabel alloc]init];
    eyeLabel.frame = CGRectMake(288, CGRectGetMaxY(titleImageView.frame)+5, 25, 14);
    eyeLabel.font = [UIFont systemFontOfSize:11];
    eyeLabel.textColor = [UIColor lightGrayColor];
    eyeLabel.text = qs.view_nums;
    [_baseView addSubview:eyeLabel];
    
    _baseView.frame = CGRectMake(0, 0, 320, CGRectGetMaxY(eyeLabel.frame)+5);
    
    UIView *balckView = [[UIView alloc]init];
    balckView.frame = CGRectMake(0, CGRectGetMaxY(_baseView.frame), 320, 20);
    balckView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [_baseView addSubview:balckView];
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(5, 0, 150, 20);
    label.text = [NSString stringWithFormat:@"%@个回答",qs.comment_nums];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor whiteColor];
    [balckView addSubview:label];
    
    
    
    return _baseView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = 20;
    
    Question *qs = [_dataArray lastObject];
    CGSize titleSize = [qs.title sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(290, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    height  = height + 5 + titleSize.height + 5;
    if (qs.total_pic.count>0) {
        height = height + 140 ;
    }
    height = height + 19+5;

    if (_dataArray.count > 0) {
        return height;
    }
    else
    {
        return 0.001;
    }

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Answer *as = [[_dataArray objectAtIndex:0] objectAtIndex:indexPath.row];
    [_myCell createUI];
    [_myCell setFrameWith:as andClass:self];
    return _myCell.baseView.bounds.size.height;
}
-(void)createBottomBar
{
    _bottomView = [[UIView alloc]init];
    _bottomView.backgroundColor = [UIColor blackColor];
    _bottomView.frame = CGRectMake(0, self.view.bounds.size.height - 49, 320, 49);
    [self.view addSubview:_bottomView];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(0, 0, 135, 49);
    [btn1 setImage:[UIImage imageNamed:@"ask_btn0.png"] forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn1.tag = 1;
    [btn1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(135, 0, 110, 49);
    [btn2 setImage:[UIImage imageNamed:@"ask_btn1.png"] forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn2.tag = 2;
    [btn2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:btn2];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame = CGRectMake(245, 0, 75, 49);
    [btn3 setImage:[UIImage imageNamed:@"ask_btn2.png"] forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn3.tag = 3;
    [btn3 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:btn3];
}
-(void)btnClick:(UIButton *)btn
{
    if (btn.tag == 1) {
        
    }
    else if(btn.tag == 2)
    {
    
    }
    else if(btn.tag == 3)
    {
    
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
    UIView *myT = [self.tabBarController.view.subviews lastObject];
    myT.hidden = YES;
    UIView *view = [self.tabBarController.view.subviews objectAtIndex:0];
    view.frame = CGRectMake(0, 0, 320, self.view.bounds.size.height);
}
-(void)viewWillAppear:(BOOL)animated
{
    [self createBottomBar];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_bottomView removeFromSuperview];
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
