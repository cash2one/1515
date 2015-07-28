//
//  DesignPhotoViewController.m
//  DesignBook
//
//  Created by Visitor on 14-11-9.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import "DesignPhotoViewController.h"
#import "MyHeaderView.h"
#import "MyNavigationBar.h"
#import "ZXPhotoCell.h"
#import "DownLoadManager.h"
#import "UIImageView+WebCache.h"
#import "ZXPhoto.h"
#import "INTERFACE.h"
#import "ShowPhotoViewController.h"
#import "MJRefresh.h"
@interface DesignPhotoViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>

@end

@implementation DesignPhotoViewController
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    NSMutableArray *_leftDataArray;
    NSMutableArray *_rightDataArray;
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
        _downLoadManager = [DownLoadManager sharedDownLoadManager];
        _leftDataArray = [[NSMutableArray alloc]init];
        _rightDataArray = [[NSMutableArray alloc]init];
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

    NSString *urlStr = [NSString stringWithFormat:kURL_ZX_PHOTO,kZX_RECENT,8];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish:) name:urlStr object:nil];
    [_downLoadManager addDownLoadWithDownStr:urlStr andDownLoadType:8 andIsRefresh:YES andDownLoadPage:-1];
}
-(void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, 320, self.view.bounds.size.height - 64- 49) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource =self;
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
            NSString *urlStr = [NSString stringWithFormat:kURL_ZX_PHOTO,kZX_RECENT,8];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish:) name:urlStr object:nil];
            [_downLoadManager addDownLoadWithDownStr:urlStr andDownLoadType:kTYPE_ZX_PHOTO andIsRefresh:YES andDownLoadPage:-1];
        }
        else if(_enterType == 1)
        {
            NSString *urlStr = [NSString stringWithFormat:kURL_ZX_PHOTO,kZX_TODAY,8];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish:) name:urlStr object:nil];
            [_downLoadManager addDownLoadWithDownStr:urlStr andDownLoadType:kTYPE_ZX_PHOTO andIsRefresh:YES andDownLoadPage:-1];
        }
        else if(_enterType == 2)
        {
            NSString *urlStr = [NSString stringWithFormat:kURL_ZX_PHOTO,kZX_TOTAL,8];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish:) name:urlStr object:nil];
            [_downLoadManager addDownLoadWithDownStr:urlStr andDownLoadType:kTYPE_ZX_PHOTO andIsRefresh:YES andDownLoadPage:-1];
        }
        else if(_enterType == 3)
        {
            NSString *urlStr = [NSString stringWithFormat:kURL_ZX_PHOTO,kZX_NEW,8];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish:) name:urlStr object:nil];
            [_downLoadManager addDownLoadWithDownStr:urlStr andDownLoadType:kTYPE_ZX_PHOTO andIsRefresh:YES andDownLoadPage:-1];
        }
    }
    else if(refreshView == _footerRefresh)
    {
        _page++;
        NSString *urlStr = [NSString stringWithFormat:kURL_ZX_PHOTO,kZX_RECENT,8*_page];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish:) name:urlStr object:nil];
        [_downLoadManager addDownLoadWithDownStr:urlStr andDownLoadType:8 andIsRefresh:YES andDownLoadPage:-1];
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
    else if(btn.tag == 3)
    {
        _enterType = 3;
    }
    [_rightDataArray removeAllObjects];
    [_leftDataArray removeAllObjects];
    _dataArray = nil;
    [_tableView reloadData];
    [_headerRefresh beginRefreshing];
}
-(void)tapAction:(UITapGestureRecognizer *)tap
{
    int index = tap.view.superview.superview.tag;
    
    ShowPhotoViewController *shvc = [[ShowPhotoViewController alloc]init];
    
    if (tap.view.tag == 1) {
        NSLog(@"index = %d",index);
        ZXPhoto *zxp = [_leftDataArray objectAtIndex:index];
        shvc.idStr = zxp.uid;
        shvc.uidStr = zxp.category;
        [self.navigationController pushViewController:shvc animated:YES];
    }
    if(tap.view.tag == 2)
    {
        NSLog(@"index = %d",index);
        ZXPhoto *zxp = [_rightDataArray objectAtIndex:index];
        shvc.idStr = zxp.uid;
        shvc.uidStr = zxp.category;
        [self.navigationController pushViewController:shvc animated:YES];
    }
}
#pragma mark - DownLoadManager
-(void)downLoadFinish:(NSNotification *)not
{
    [_rightDataArray removeAllObjects];
    [_leftDataArray removeAllObjects];
    
    _dataArray = [_downLoadManager getDataWithDownLoadString:not.name];
    
    for (int i = 0; i< [[_dataArray objectAtIndex:0] count]; i++) {
        if (i%2 == 0) {
            [_leftDataArray addObject:[[_dataArray objectAtIndex:0] objectAtIndex:i]];
        }
        if (i%2 == 1) {
            [_rightDataArray addObject:[[_dataArray objectAtIndex:0] objectAtIndex:i]];
        }
    }
    [_headerRefresh endRefreshing];
    [_footerRefresh endRefreshing];
    [_tableView reloadData];
}


#pragma mark - TableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _leftDataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"photoCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZXPhotoCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.contentView.tag = indexPath.row;
    UITapGestureRecognizer *leftTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    UITapGestureRecognizer *rightTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [cell.leftPhotoImageView addGestureRecognizer:leftTapGesture];
    [cell.rightPhotoImageView addGestureRecognizer:rightTapGesture];
    
    ZXPhoto *leftZxp = [_leftDataArray objectAtIndex:indexPath.row];
    [cell.leftPhotoImageView setImageWithURL:[NSURL URLWithString:leftZxp.path]];
    cell.leftTitleLabel.text = leftZxp.name;
    cell.leftNameLabel.text = leftZxp.add_name;
    cell.leftCollectionLabel.text = leftZxp.nb_image;
    
    if (indexPath.row <= _rightDataArray.count) {
        ZXPhoto *rightZxp = [_rightDataArray objectAtIndex:indexPath.row];
        [cell.rightPhotoImageView setImageWithURL:[NSURL URLWithString:rightZxp.path]];
        cell.rightTitleLabel.text = rightZxp.name;
        cell.rightNameLabel.text = rightZxp.add_name;
        cell.rightCollectionLabel.text = rightZxp.nb_image;
    }
    
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *titleArray = [[NSArray alloc]initWithObjects:@"最近活跃", @"今日热门", @"总热门榜", @"最新推荐", nil];
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
    label.text = [NSString stringWithFormat:@"图片总数%@张",_dataArray[1]];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor whiteColor];
    [baseView addSubview:label];
    
    return mhv;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 175;
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
