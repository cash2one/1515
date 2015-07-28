
//
//  SearchResultViewController.m
//  DesignBook
//
//  Created by Visitor on 14-11-14.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import "SearchResultViewController.h"
#import "MyNavigationBar.h"
#import "MyHeaderView.h"
#import "INTERFACE.h"
#import "DownLoadManager.h"
#import "FindSjsCell.h"

#import "ShowPhotoViewController.h"
#import "UIImageView+WebCache.h"

#import "SearchSjs.h"
#import "ZXPhotoCell.h"
#import "SearchPhoto.h"
#import "AskCell.h"
#import "SearchAnswer.h"
#import "PersonDetailViewController.h"
#import "AskSubViewController.h"
#import "MJRefresh.h"

@interface SearchResultViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>

@end

@implementation SearchResultViewController
{
    UITableView *_tableView;
    
    NSMutableArray *_sjsDataSource;
    
    NSMutableArray *_photoDataArray;
    NSMutableArray *_pLeftDataArray;
    NSMutableArray *_pRightDataArray;
    
    NSMutableArray *_ansAataArray;
    AskCell *_myCell;
    
    DownLoadManager *_downLoadManager;
    
    MJRefreshHeaderView *_headerRefresh;
    MJRefreshFooterView *_footerRefresh;
    int _page1;
    int _page2;
    int _page3;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _downLoadManager = [DownLoadManager sharedDownLoadManager];
        _pLeftDataArray = [[NSMutableArray alloc]init];
        _pRightDataArray = [[NSMutableArray alloc]init];
        _myCell = [[AskCell alloc]init];
        _page1 = 1;
        _page2 = 1;
        _page3 = 1;
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
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createNavigationBar];
    [self createTableView];

    if (_enterType == 0) {
        NSString *urlStr = [NSString stringWithFormat:kURL_SEARCH_SJS,_keyWord,8];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish:) name:urlStr object:nil];
        [_downLoadManager addDownLoadWithDownStr:urlStr andDownLoadType:kTYPE_SEARCH_SJS andIsRefresh:YES andDownLoadPage:-1];
    }
    else if(_enterType == 1)
    {
        NSString *urlStr = [NSString stringWithFormat:kURL_SEARCH_PHOTO,_keyWord,8];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish:) name:urlStr object:nil];
        [_downLoadManager addDownLoadWithDownStr:urlStr andDownLoadType:kTYPE_SEARCH_PHOTO andIsRefresh:YES andDownLoadPage:-1];
    }
    else if(_enterType == 2)
    {
        NSString *urlStr = [NSString stringWithFormat:kURL_SEARCH_ANSWER,_keyWord,8];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish:) name:urlStr object:nil];
        [_downLoadManager addDownLoadWithDownStr:urlStr andDownLoadType:kTYPE_SEARCH_ANSWER andIsRefresh:YES andDownLoadPage:-1];
    }
}
-(void)createNavigationBar
{
    [self.navigationController setNavigationBarHidden:YES];
    MyNavigationBar *mnb = [[MyNavigationBar alloc]init];
    mnb.frame = CGRectMake(0, 20, 320, 44);
    [mnb createMyNavigationBarWithBgImageName:nil andTitle:self.vcTitle andLeftBtnImageName:@"back_arrow.png" andLeftBtnTitle:nil andRightBtnImageName:nil andRightBtnTitle:nil andClass:self andSEL:@selector(navigationBarBtnClick:)];
    self.view.backgroundColor = [UIColor colorWithRed:0.87f green:0.22f blue:0.20f alpha:1.00f];
    [self.view addSubview:mnb];
}
-(void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, 320, self.view.bounds.size.height-64) style:UITableViewStylePlain];
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
        _page1 = 1;
        _page2 = 1;
        _page3 = 1;
        if (_enterType == 0) {
            NSString *urlStr = [NSString stringWithFormat:kURL_SEARCH_SJS,_keyWord,8];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish:) name:urlStr object:nil];
            [_downLoadManager addDownLoadWithDownStr:urlStr andDownLoadType:kTYPE_SEARCH_SJS andIsRefresh:YES andDownLoadPage:-1];
        }
        else if(_enterType == 1)
        {
            NSString *urlStr = [NSString stringWithFormat:kURL_SEARCH_PHOTO,_keyWord,8];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish:) name:urlStr object:nil];
            [_downLoadManager addDownLoadWithDownStr:urlStr andDownLoadType:kTYPE_SEARCH_PHOTO andIsRefresh:YES andDownLoadPage:-1];
        }
        else if(_enterType == 2)
        {
            NSString *urlStr = [NSString stringWithFormat:kURL_SEARCH_ANSWER,_keyWord,8];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish:) name:urlStr object:nil];
            [_downLoadManager addDownLoadWithDownStr:urlStr andDownLoadType:kTYPE_SEARCH_ANSWER andIsRefresh:YES andDownLoadPage:-1];
        }
    }
    else if(refreshView == _footerRefresh)
    {
        _page1++;
        _page2++;
        _page3++;
        
        if (_enterType == 0) {
            NSString *urlStr = [NSString stringWithFormat:kURL_SEARCH_SJS,_keyWord,8*_page1];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish:) name:urlStr object:nil];
            [_downLoadManager addDownLoadWithDownStr:urlStr andDownLoadType:kTYPE_SEARCH_SJS andIsRefresh:YES andDownLoadPage:-1];
        }
        else if(_enterType == 1)
        {
            NSString *urlStr = [NSString stringWithFormat:kURL_SEARCH_PHOTO,_keyWord,8*_page2];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish:) name:urlStr object:nil];
            [_downLoadManager addDownLoadWithDownStr:urlStr andDownLoadType:kTYPE_SEARCH_PHOTO andIsRefresh:YES andDownLoadPage:-1];
        }
        else if(_enterType == 2)
        {
            NSString *urlStr = [NSString stringWithFormat:kURL_SEARCH_ANSWER,_keyWord,8*_page3];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish:) name:urlStr object:nil];
            [_downLoadManager addDownLoadWithDownStr:urlStr andDownLoadType:kTYPE_SEARCH_ANSWER andIsRefresh:YES andDownLoadPage:-1];
        }

    }
}


#pragma mark - DownLoadManager
-(void)downLoadFinish:(NSNotification *)not
{
    [_headerRefresh endRefreshing];
    [_footerRefresh endRefreshing];
    
    if (_enterType == 0) {
        _sjsDataSource = [_downLoadManager getDataWithDownLoadString:not.name];
    }
    else if(_enterType == 1)
    {
        [_pRightDataArray removeAllObjects];
        [_pLeftDataArray removeAllObjects];
        
        _photoDataArray = [_downLoadManager getDataWithDownLoadString:not.name];
        NSArray *array = [_photoDataArray objectAtIndex:0];
        
        for (int i = 0; i< [array  count]; i++) {
            if (i%2 == 0) {
                [_pLeftDataArray addObject:[array objectAtIndex:i]];
            }
            if (i%2 == 1) {
                [_pRightDataArray addObject:[array objectAtIndex:i]];
            }
        }
    }
    else if(_enterType == 2)
    {
        _ansAataArray = [_downLoadManager getDataWithDownLoadString:not.name];
        [_tableView reloadData];

    }
    [_tableView reloadData];
}
-(void)tapAction:(UITapGestureRecognizer *)tap
{
    int index = tap.view.superview.superview.tag;
    
    ShowPhotoViewController *shvc = [[ShowPhotoViewController alloc]init];
    
    if (tap.view.tag == 1) {
        NSLog(@"index = %d",index);
        SearchPhoto *sp = [_pLeftDataArray objectAtIndex:index];
        shvc.idStr = sp.uid;
        shvc.uidStr = sp.category;
        [self.navigationController pushViewController:shvc animated:YES];
    }
    if(tap.view.tag == 2)
    {
        NSLog(@"index = %d",index);
        SearchPhoto *sp = [_pRightDataArray objectAtIndex:index];
        shvc.idStr = sp.uid;
        shvc.uidStr = sp.category;
        [self.navigationController pushViewController:shvc animated:YES];
    }
}

#pragma mark - TableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_enterType == 0) {

        return [[_sjsDataSource objectAtIndex:0] count];
    }
    else if(_enterType == 1)
    {
        return _pLeftDataArray.count;
    }
    else if(_enterType == 2)
    {
        return [_ansAataArray[0] count];
    }
    
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_enterType == 0) {
        
        
        FindSjsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sjsCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"FindSjsCell" owner:self options:nil]lastObject] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        SearchSjs *ssjs = [[_sjsDataSource objectAtIndex:0] objectAtIndex:indexPath.row];
        
        [cell.HeadImageView setImageWithURL:[NSURL URLWithString:ssjs.headphoto] placeholderImage:[UIImage imageNamed:@""]];
        cell.nameLabel.text = ssjs.truename;
        cell.designLabel.text = [NSString stringWithFormat:@"设计作品/精: %@/%@",ssjs.pic_num,ssjs.elite_num];
        NSString *yuyueStr = [NSString stringWithFormat:@"预约%@次",ssjs.yuyue_nums];
        if (ssjs.qiandanNum.intValue>0) {
            yuyueStr = [NSString stringWithFormat:@"预约%@次 签单%@个项目",ssjs.yuyue_nums,ssjs.qiandanNum];
        }
        cell.yuyueLabel.text = yuyueStr;
        return cell;
    }
    else if(_enterType == 1)
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
        SearchPhoto *leftSp = [_pLeftDataArray objectAtIndex:indexPath.row];
        [cell.leftPhotoImageView setImageWithURL:[NSURL URLWithString:leftSp.path]];
        cell.leftTitleLabel.text = leftSp.name;
        cell.leftNameLabel.text = leftSp.add_name;
        cell.leftCollectionLabel.text = leftSp.nb_image;
        
        if (indexPath.row < _pRightDataArray.count) {
            SearchPhoto *rightSp = [_pRightDataArray objectAtIndex:indexPath.row];
            [cell.rightPhotoImageView setImageWithURL:[NSURL URLWithString:rightSp.path]];
            cell.rightTitleLabel.text = rightSp.name;
            cell.rightNameLabel.text = rightSp.add_name;
            cell.rightCollectionLabel.text = rightSp.nb_image;
        }
        if (_pRightDataArray.count ==indexPath.row) {
            [cell.rightPhotoImageView.superview removeFromSuperview];
        }
        

        return cell;
    }
    else if(_enterType == 2)
    {
        AskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ccell"];
        if (!cell) {
            cell = [[AskCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ccell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        [cell createUI];
        [cell setFrameWithAskSearchAnswer:(SearchAnswer *)[[_ansAataArray objectAtIndex:0] objectAtIndex:indexPath.row]];
        return cell;
    }
    
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *titleArray = [[NSArray alloc]initWithObjects:@"找设计师", @"找装修图片", @"找有问必答",nil];
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
    
    if (_enterType == 0) {
        label.text = [NSString stringWithFormat:@"%d位设计师入驻", [[_sjsDataSource objectAtIndex:1] intValue]];
    }
    else if(_enterType == 1)
    {
        label.text = [NSString stringWithFormat:@"图片总数%d张", [[_photoDataArray objectAtIndex:1] intValue]];
    }
    else if(_enterType == 2)
    {
        label.text = [NSString stringWithFormat:@"%d个问题",[[_ansAataArray objectAtIndex:1] intValue]];
    }
    
   
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor whiteColor];
    [baseView addSubview:label];
    return mhv;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_enterType == 0) {
        return 73;
    }
    
    else if(_enterType == 1)
    {
        return 175;
    }
    else if(_enterType == 2)
    {
        [_myCell createUI];
        [_myCell setFrameWithAskSearchAnswer:(SearchAnswer *)[[_ansAataArray objectAtIndex:0] objectAtIndex:indexPath.row ]];
        return _myCell.baseView.bounds.size.height+5;
    }
    
    return 44;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_enterType == 0) {
        SearchSjs *ss = (SearchSjs*)[[_sjsDataSource objectAtIndex:0] objectAtIndex:indexPath.row];
        PersonDetailViewController *pdvc = [[PersonDetailViewController alloc]init];
        pdvc.uid = ss.uid;
        pdvc.nick = ss.truename;
        [self.navigationController pushViewController:pdvc animated:YES];
    }
    else if(_enterType == 1)
    {
    
    }
    else if(_enterType == 2)
    {
        AskSubViewController *asvc = [[AskSubViewController alloc]init];
        asvc.idStr = ((SearchAnswer *)[[_ansAataArray objectAtIndex:0] objectAtIndex:indexPath.row]).aid.stringValue;
        [self.navigationController pushViewController:asvc animated:YES];
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
        _sjsDataSource = nil;
    }
    else if(btn.tag == 1)
    {
        _enterType = 1;
        [_pLeftDataArray removeAllObjects];
        [_pRightDataArray removeAllObjects];
        _photoDataArray = nil;
    }
    else if(btn.tag == 2)
    {
        _enterType = 2;
        _ansAataArray = nil;
    }
    [_tableView reloadData];
    [_headerRefresh beginRefreshing];

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 65;
}
-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
    UIView *myT = [self.tabBarController.view.subviews lastObject];
    myT.hidden = YES;
    
    UIView *view = [self.tabBarController.view.subviews objectAtIndex:0];
    view.frame = CGRectMake(0, 0, 320, self.view.bounds.size.height);
}
-(void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
    UIView *myT = [self.tabBarController.view.subviews lastObject];
    myT.hidden = NO;
    
    UIView *view = [self.tabBarController.view.subviews objectAtIndex:0];
    view.frame = CGRectMake(0, 0, 320, self.view.bounds.size.height-49);
}
-(void)navigationBarBtnClick:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
