//
//  PersonDetailViewController.m
//  DesignBook
//
//  Created by Visitor on 14-11-10.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import "PersonDetailViewController.h"
#import "MyNavigationBar.h"
#import "PersonHeaderView.h"
#import "INTERFACE.h"
#import "DownLoadManager.h"
#import "PersonResult.h"
#import "PersonInfo.h"
#import "UIImageView+WebCache.h"
#import "DesignCase.h"
#import "PersonBlog.h"
#import "BlogViewController.h"
#import "CommentView.h"
#import "PersonComment.h"
#import "ShowPhotoViewController.h"
#import "MJRefresh.h"

@interface PersonDetailViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>

@end

@implementation PersonDetailViewController
{
    UITableView *_mainTableView;
    UIView *_blackBtnView;
    DownLoadManager *_downLoadManager;
    NSMutableArray *_dataArray;
    NSMutableArray *_leftDesignCaseArr;
    NSMutableArray *_rightDesighCaseArr;
    PersonResult *_personResult;
    int _btnTag;
    
    NSMutableArray *_blogArr;
    NSMutableArray *_commentArr;
    CommentView *_commentView;
    
    MJRefreshHeaderView *_headerRefresh;
    MJRefreshFooterView *_footerRefresh;
    int _page;
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _btnTag = 1;
        _downLoadManager = [DownLoadManager sharedDownLoadManager];
        _leftDesignCaseArr = [[NSMutableArray alloc]init];
        _rightDesighCaseArr = [[NSMutableArray alloc]init];
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
    
    _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, 320, self.view.bounds.size.height-64) style:UITableViewStylePlain];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.separatorColor = [UIColor clearColor];
    _mainTableView.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.93f alpha:1.00f];
    [self.view addSubview:_mainTableView];
    
    _headerRefresh = [MJRefreshHeaderView header];
    _headerRefresh.scrollView = _mainTableView;
    _headerRefresh.delegate = self;
    [_headerRefresh beginRefreshing];
    
    _footerRefresh = [MJRefreshFooterView footer];
    _footerRefresh.scrollView = _mainTableView;
    _footerRefresh.delegate = self;

//    NSString *urlStr = [NSString stringWithFormat:kURL_PERSON_INFO,_uid];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish:) name:urlStr object:nil];
//    [_downLoadManager addDownLoadWithDownStr:urlStr andDownLoadType:kTYPE_PERSON_INFO andIsRefresh:YES andDownLoadPage:-1];
}
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (refreshView == _headerRefresh) {
        _page = 1;
        if (_btnTag == 100) {
            NSString *urlStr = [NSString stringWithFormat:kURL_DESIGN_CASE,_uid,8];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish0:) name:urlStr object:nil];
            [_downLoadManager addDownLoadWithDownStr:urlStr andDownLoadType:kTYPE_DESIGN_CASE andIsRefresh:YES andDownLoadPage:-1];
        
        }
        else if(_btnTag == 1)
        {
            NSString *urlStr = [NSString stringWithFormat:kURL_PERSON_INFO,_uid];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish:) name:urlStr object:nil];
            [_downLoadManager addDownLoadWithDownStr:urlStr andDownLoadType:kTYPE_PERSON_INFO andIsRefresh:YES andDownLoadPage:-1];
        }
        else if(_btnTag == 2)
        {
            NSString *urlStr = [NSString stringWithFormat:kURL_BLOG,_uid,8];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish1:) name:urlStr object:nil];
            [_downLoadManager addDownLoadWithDownStr:urlStr andDownLoadType:kTYPE_BLOG andIsRefresh:YES andDownLoadPage:-1];
        }
        else if(_btnTag == 3)
        {
            NSString *urlStr = [NSString stringWithFormat:kURL_COMMENT,_uid,8];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish2:) name:urlStr object:nil];
            [_downLoadManager addDownLoadWithDownStr:urlStr andDownLoadType:kTYPE_COMMENT andIsRefresh:YES andDownLoadPage:-1];
        }
    }
    else if(refreshView == _footerRefresh)
    {
        _page++;
        if (_btnTag == 100) {
            NSString *urlStr = [NSString stringWithFormat:kURL_DESIGN_CASE,_uid,8*_page];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish0:) name:urlStr object:nil];
            [_downLoadManager addDownLoadWithDownStr:urlStr andDownLoadType:kTYPE_DESIGN_CASE andIsRefresh:YES andDownLoadPage:-1];
        }
        else if(_btnTag == 1)
        {
            [_footerRefresh endRefreshing];
        }
        else if(_btnTag == 2)
        {
            NSString *urlStr = [NSString stringWithFormat:kURL_BLOG,_uid,_page];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish1:) name:urlStr object:nil];
            [_downLoadManager addDownLoadWithDownStr:urlStr andDownLoadType:kTYPE_BLOG andIsRefresh:YES andDownLoadPage:-1];
        }
        else if(_btnTag == 3)
        {
            NSString *urlStr = [NSString stringWithFormat:kURL_COMMENT,_uid,_page];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish2:) name:urlStr object:nil];
            [_downLoadManager addDownLoadWithDownStr:urlStr andDownLoadType:kTYPE_COMMENT andIsRefresh:YES andDownLoadPage:-1];
        }
    }
}


-(void)downLoadFinish:(NSNotification *)not
{
    _dataArray = [_downLoadManager getDataWithDownLoadString:not.name];
    _personResult = [_dataArray lastObject];
    [_mainTableView reloadData];
    [_headerRefresh endRefreshing];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:not.name object:nil];
}
-(void)createNavigationBar
{
    [self.navigationController setNavigationBarHidden:YES];
    MyNavigationBar *mnb = [[MyNavigationBar alloc]init];
    mnb.frame = CGRectMake(0, 20, 320, 44);
    [mnb createMyNavigationBarWithBgImageName:nil andTitle:_nick andLeftBtnImageName:@"back_arrow.png" andLeftBtnTitle:nil andRightBtnImageName:nil andRightBtnTitle:nil andClass:self andSEL:@selector(navigationBarBtnClick:)];
    self.view.backgroundColor = [UIColor colorWithRed:0.87f green:0.22f blue:0.20f alpha:1.00f];
    [self.view addSubview:mnb];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(mnb.bounds.size.width-10-50, (44-29)/2, 50, 29);
    [btn setTitle:@"关注" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [mnb addSubview:btn];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_btnTag == 1) {
        return 3;
    }
    else if(_btnTag == 100)
    {
        return _leftDesignCaseArr.count ;
    }
    else if(_btnTag == 2)
    {
        return _blogArr.count;
    }
    else if(_btnTag == 3)
    {
        return _commentArr.count;
    }
    else
        return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.contentView.tag = indexPath.row;
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    if (_btnTag == 1) {
        if (indexPath.row == 0) {
            UIView *baseView = [[UIView alloc]init];
            baseView.frame = CGRectMake(5, 5, 310, 100);
            baseView.backgroundColor = [UIColor whiteColor];
            NSArray *nameArr = [[NSArray alloc]initWithObjects:@"个人信息:",@"姓名/公司名称:",@"ID:",@"类型:",@"设计经验:",@"所在地:", nil];
            
            for (int i = 0; i<6; i++) {
                UILabel *label = [[UILabel alloc]init];
                label.frame = CGRectMake(10, 5 + (100-10)/6 * i, 300, (100-10)/6);
                
                NSString *string = [NSString stringWithFormat:@"%@",nameArr[i]];
                if (i == 1) {
                    string = [NSString stringWithFormat:@"%@ %@",nameArr[i],_personResult.info.truename];
                }
                if (i== 2) {
                    string = [NSString stringWithFormat:@"%@ %@",nameArr[i],_personResult.info.uid];
                }
                if (i==3) {
                    string = [NSString stringWithFormat:@"%@ %@",nameArr[i],_personResult.info.type];
                }
                if (i==4) {
                    string = [NSString stringWithFormat:@"%@ %@",nameArr[i],_personResult.info.workyears];
                }
                if (i==5) {
                    string = [NSString stringWithFormat:@"%@ %@ %@",nameArr[i],_personResult.info.shen,_personResult.info.city];
                }
                
                label.text = string;
                label.font = [UIFont systemFontOfSize:12];
                label.textColor = [UIColor darkGrayColor];
                [baseView addSubview:label];
            }
            
            [cell.contentView addSubview:baseView];
        }
        if (indexPath.row == 1) {
            
            UIView *baseView = [[UIView alloc]init];
            baseView.frame = CGRectMake(5, 5, 310, 100);
            baseView.backgroundColor = [UIColor whiteColor];
            NSArray *nameArr = [[NSArray alloc]initWithObjects:@"其他信息:",@"擅长风格:",@"其他风格:",@"设计专长:",@"其他专长:",@"证书与奖励:\n", nil];
            CGFloat height = 5;
            for (int i = 0; i<6; i++) {
                UILabel *label = [[UILabel alloc]init];
                NSString *string = [NSString stringWithFormat:@"%@",nameArr[i]];
                if (i == 1) {
                    string = [NSString stringWithFormat:@"%@ %@",nameArr[i],_personResult.info.style];
                }
                if (i== 2) {
                    string = [NSString stringWithFormat:@"%@ %@",nameArr[i],_personResult.info.otherstyle];
                }
                if (i==3) {
                    string = [NSString stringWithFormat:@"%@ %@",nameArr[i],_personResult.info.mainfield];
                }
                if (i==4) {
                    string = [NSString stringWithFormat:@"%@ %@",nameArr[i],_personResult.info.otherfield];
                }
                if (i==5) {
                    string = [NSString stringWithFormat:@"%@ %@ %@",nameArr[i],_personResult.info.yeji,_personResult.info.city];
                }
                
                CGSize size = [string sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(290, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
                
                label.text = string;
                label.frame = CGRectMake(10, height, 290, size.height);
                label.numberOfLines = 0;
                label.font = [UIFont systemFontOfSize:12];
                label.textColor = [UIColor darkGrayColor];
                [baseView addSubview:label];
                height = height + size.height;
            }
            baseView.frame = baseView.frame = CGRectMake(5, 5, 310, height+5);
            [cell.contentView addSubview:baseView];
        }
        if (indexPath.row == 2) {
            NSString *str = [NSString stringWithFormat:@"个人简介:\n%@",_personResult.info.introduce];
            CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(290, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
            UIView *baseView = [[UIView alloc]init];
            baseView.backgroundColor = [UIColor whiteColor];
            
            UILabel *label = [[UILabel alloc]init];
            label.frame = CGRectMake(10, 5, 290, size.height);
            label.numberOfLines = 0;
            label.text = str;
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = [UIColor darkGrayColor];
            [baseView addSubview:label];
            
            baseView.frame = CGRectMake(5, 5, 310, size.height+10);
            [cell.contentView addSubview:baseView];
        }
    }
    else if(_btnTag == 100 && _leftDesignCaseArr.count >0) {
        
        UIImageView *leftImageView = [[UIImageView alloc]init];
        leftImageView.tag = 1;
        leftImageView.userInteractionEnabled = YES;
        leftImageView.frame = CGRectMake(10, 10, 145, 145);
        [leftImageView setImageWithURL:[NSURL URLWithString:((DesignCase *)_leftDesignCaseArr[indexPath.row]).path] placeholderImage:[UIImage imageNamed:@""]];
        UILabel *leftLabel = [[UILabel alloc]init];
        leftLabel.frame = CGRectMake(0, 125, 145, 20);
        leftLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        leftLabel.font = [UIFont systemFontOfSize:14];
        leftLabel.text = ((DesignCase *)_leftDesignCaseArr[indexPath.row]).name;
        leftLabel.textColor = [UIColor whiteColor];
        [leftImageView addSubview:leftLabel];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [leftImageView addGestureRecognizer:tap];
        
        [cell.contentView addSubview:leftImageView];
        
        if (indexPath.row<=_rightDesighCaseArr.count-1&&_rightDesighCaseArr.count>0) {
            UIImageView *rightImageView = [[UIImageView alloc]init];
            rightImageView.tag = 2;
            rightImageView.userInteractionEnabled = YES;
            rightImageView.frame = CGRectMake(165, 10, 145, 145);
            [rightImageView setImageWithURL:[NSURL URLWithString:((DesignCase *)_rightDesighCaseArr[indexPath.row]).path] placeholderImage:[UIImage imageNamed:@""]];
            
            UILabel *rightLabel = [[UILabel alloc]init];
            rightLabel.frame = CGRectMake(0, 125, 145, 20);
            rightLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
            rightLabel.font = [UIFont systemFontOfSize:14];
            rightLabel.text = ((DesignCase *)_leftDesignCaseArr[indexPath.row]).name;
            rightLabel.textColor = [UIColor whiteColor];
            [rightImageView addSubview:rightLabel];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
            [rightImageView addGestureRecognizer:tap];
            
            [cell.contentView addSubview:rightImageView];
        }
        
    }
    else if(_btnTag == 2){
        PersonBlog *pb = [_blogArr objectAtIndex:indexPath.row];
        
        UIButton *btn = [UIButton  buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(5, 5, 310, 63);
        btn.backgroundColor = [UIColor whiteColor];
        [btn addTarget:self action:@selector(blogBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = indexPath.row;
        [cell.contentView addSubview:btn];
        
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake( 15, 0, 260, 63);
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor darkGrayColor];
        label.text = pb.subject;
        label.textAlignment = NSTextAlignmentLeft;
        [btn addSubview:label];
        
        UILabel *timeLabel = [[UILabel alloc]init];
        timeLabel.frame = CGRectMake(225, 43, 50, 10);
        timeLabel.font = [UIFont systemFontOfSize:10];
        timeLabel.textColor = [UIColor lightGrayColor];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.text = pb.puttime;
        [btn addSubview:timeLabel];
        
        UIImageView *arrowImageView = [[UIImageView alloc]init];
        arrowImageView.frame = CGRectMake(285, 23, 7, 13);
        arrowImageView.image = [UIImage imageNamed:@"table_arrow.png"];
        [btn addSubview:arrowImageView];

    }
    else if(_btnTag == 3){
        
        PersonComment *pc = [_commentArr objectAtIndex:indexPath.row];
        _commentView = [[[NSBundle mainBundle]loadNibNamed:@"CommentView" owner:self options:nil] lastObject];
        _commentView.frame = CGRectMake(5, 5, 310, 105);
        [_commentView.btn1 addTarget:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_commentView.btn2 addTarget:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _commentView.koubeiLabel.text = pc.cxt_num;
        _commentView.haopingLabel.text = pc.haoping;
        _commentView.numhaopingLabel.text = pc.hp_num;
        _commentView.chapingLabel.text = pc.cp_num;
        _commentView.btn1.titleLabel.text = [NSString stringWithFormat:@"总共承接%@个项目",pc.project_num];
        _commentView.btn2.titleLabel.text = [NSString stringWithFormat:@"客户差评(%@)",pc.comment_num];
        [cell.contentView addSubview:_commentView];
    }
    return cell;
}
-(void)tapAction:(UITapGestureRecognizer *)tap
{
    int index = tap.view.superview.tag;
    if (tap.view.tag == 1) {
        ShowPhotoViewController *spvc = [[ShowPhotoViewController alloc]init];
        spvc.uidStr = ((DesignCase *)[_leftDesignCaseArr objectAtIndex:index]).uid;
        spvc.idStr = ((DesignCase *)[_leftDesignCaseArr objectAtIndex:index]).image_id;
        [self.navigationController pushViewController:spvc animated:YES];
    }
    else if(tap.view.tag == 2)
    {
        ShowPhotoViewController *spvc = [[ShowPhotoViewController alloc]init];
        spvc.uidStr = ((DesignCase *)[_rightDesighCaseArr objectAtIndex:index]).uid;
        spvc.idStr = ((DesignCase *)[_rightDesighCaseArr objectAtIndex:index]).image_id;
        [self.navigationController pushViewController:spvc animated:YES];
    }
}
-(void)commentBtnClick:(UIButton *)btn
{
    NSLog(@"commentBtn.tag = %d",btn.tag);
}
-(void)blogBtnClick:(UIButton *)btn
{
    BlogViewController *bvc = [[BlogViewController alloc]init];
    bvc.lid = ((PersonBlog *)[_blogArr objectAtIndex:btn.tag]).lid;
    bvc.uid = ((PersonBlog *)[_blogArr objectAtIndex:btn.tag]).uid;
    [self.navigationController pushViewController:bvc animated:YES];
    NSLog(@"btn = %d",btn.tag);
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_btnTag == 1) {
        if (indexPath.row == 0) {
            return 110;
        }
        else if(indexPath.row == 1)
        {
            CGFloat height = 5;
            NSArray *nameArr = [[NSArray alloc]initWithObjects:@"其他信息:",@"擅长风格:",@"其他风格:",@"设计专长:",@"其他专长:",@"证书与奖励:\n", nil];
            for (int i = 0; i<6; i++) {
                NSString *string = [NSString stringWithFormat:@"%@",nameArr[i]];
                if (i == 1) {
                    string = [NSString stringWithFormat:@"%@ %@",nameArr[i],_personResult.info.style];
                }
                if (i== 2) {
                    string = [NSString stringWithFormat:@"%@ %@",nameArr[i],_personResult.info.otherstyle];
                }
                if (i==3) {
                    string = [NSString stringWithFormat:@"%@ %@",nameArr[i],_personResult.info.mainfield];
                }
                if (i==4) {
                    string = [NSString stringWithFormat:@"%@ %@",nameArr[i],_personResult.info.otherfield];
                }
                if (i==5) {
                    string = [NSString stringWithFormat:@"%@ %@ %@",nameArr[i],_personResult.info.yeji,_personResult.info.city];
                }
                CGSize size = [string sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(290, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
                
                height = height + size.height;
            }
            return height+10;
        }
        else if (indexPath.row == 2)
        {
            NSString *str = [NSString stringWithFormat:@"个人简介:\n%@",_personResult.info.introduce];
            CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(290, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
            return size.height+10;
        }
    }
    else if(_btnTag == 100){
        return 155;
    }
    else if(_btnTag == 2)
    {
        return 67;
    }
    else if(_btnTag == 3)
    {
        return 110;
    }
        return 44;
}
-(void)btnClick:(UIButton *)btn
{
    NSLog(@"关注点击");
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *baseView = [[UIView alloc]init];
    baseView.frame = CGRectMake(0, 0, 320, 157);
    
    PersonHeaderView *personView = [[[NSBundle mainBundle] loadNibNamed:@"PersonHeaderView" owner:self options:nil] lastObject];
    [personView.headImageView setImageWithURL:[NSURL URLWithString:_personResult.info.photo] placeholderImage:[UIImage imageNamed:@"default_header.png"]];
    personView.focusLabel.text = _personResult.info.num1;
    personView.fansLabel.text =_personResult.info.num2;
    personView.designLabel.text = [NSString stringWithFormat:@"%@",_personResult.info.num3];
    personView.signLabel.text = _personResult.info.num4;
    personView.goodLabel.text = _personResult.info.style;
    personView.longLabel.text = _personResult.info.mainfield;
    [personView.yuyueBtn addTarget:self action:@selector(yuyueBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    NSString *cityStr = [NSString stringWithFormat:@"%@",_personResult.info.shen];
    if (_personResult.info.city.length>0) {
        cityStr = [NSString stringWithFormat:@"%@,%@",_personResult.info.shen,_personResult.info.city];
    }
    personView.cityLabel.text = cityStr;
    personView.typeLabel.text = _personResult.info.type;
    personView.yuyueLabel.text = [NSString stringWithFormat:@"已被%d 人预约",_personResult.info.yuyue_nums.intValue];
    if ([_personResult.info.goodlevel isEqualToString:@"5"]) {
        personView.starImageView1.image = [UIImage imageNamed:@"sjs_zm.png"];
        if ([_personResult.info.vip isEqual:[NSNumber numberWithInt:1]]) {
            personView.starImageView2.image = [UIImage imageNamed:@"sjs_v.png"];
        }
    }
    else if([_personResult.info.goodlevel isEqualToString:@"4"])
    {
        personView.starImageView1.image = [UIImage imageNamed:@"sjs_jr.png"];
        if ([_personResult.info.vip isEqual:[NSNumber numberWithInt:1]]) {
            personView.starImageView2.image = [UIImage imageNamed:@"sjs_v.png"];
        }
    }else
    {
        if ([_personResult.info.vip isEqual:[NSNumber numberWithInt:1]]) {
            personView.starImageView1.image = [UIImage imageNamed:@"sjs_v.png"];
        }
    }
    personView.frame = CGRectMake(0, 0, 320, 113);
    [baseView addSubview:personView];

    CGFloat space = (320/4-70)/2;
    
    //button的背景view
    UIView *btnView = [[UIView alloc]init];
    btnView.frame = CGRectMake(0, 113, 320, 44);
    btnView.backgroundColor = [UIColor redColor];
    btnView.backgroundColor = [UIColor colorWithRed:0.87f green:0.22f blue:0.20f alpha:1.00f];
    [baseView addSubview:btnView];
    
    //白色的长条
    _blackBtnView = [[UIView alloc]init];
    _blackBtnView.backgroundColor = [UIColor whiteColor];
    _blackBtnView.layer.cornerRadius = 11;
    
    if (_btnTag == 100) {
        _blackBtnView.frame = CGRectMake(space + (320/4)*(_btnTag-100), 11, 70, 22);
    }
    else
        _blackBtnView.frame = CGRectMake(space + (320/4)*_btnTag, 11, 70, 22);
    
    [btnView addSubview:_blackBtnView];
    
    NSArray *nameArray = [[NSArray alloc]initWithObjects:@"作品案例", @"关注",@"博文",@"交易评价",nil];
    for (int i =0; i<4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(320/4*i, 0, 320/4, 44);
        [btn setTitle:nameArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn addTarget:self action:@selector(middleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i==0) {
            btn.tag = 100;
        }
        else {
            btn.tag = i;
        }
        [btnView addSubview:btn];
    }
    UIButton *btn = (UIButton *)[btnView viewWithTag:_btnTag];
    btn.selected = YES;
    
    return baseView;
}
//预约按钮
-(void)yuyueBtnClick:(UIButton *)btn
{
    NSLog(@"预约按钮点击");
}
-(void)middleBtnClick:(UIButton *)btn
{
    if (btn.selected == YES) {
        return;
    }
    for (UIView *view in btn.superview.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)view;
            if (btn.tag == button.tag) {
                btn.selected = YES;
            }else
                button.selected = NO;
        }
    }
    [UIView animateWithDuration:0.3 animations:^{
        _blackBtnView.frame = CGRectMake((320/4-70)/2 + btn.frame.origin.x , 11, 70, 22);
    } completion:^(BOOL finished) {
        [self.view bringSubviewToFront:btn];
        [self performSelector:@selector(headerRefresh) withObject:nil afterDelay:0.1];
    }];
    _btnTag = btn.tag;
}
-(void)headerRefresh
{
    _dataArray = nil;
    [_mainTableView reloadData];
    [_headerRefresh beginRefreshing];
}
-(void)downLoadFinish0:(NSNotification *)not
{
    NSLog(@"designCase downLoadFinish");
    NSArray *arr = [_downLoadManager getDataWithDownLoadString:not.name];
    
    [_rightDesighCaseArr removeAllObjects];
    [_leftDesignCaseArr removeAllObjects];
    
    for (int i = 0; i<arr.count; i++) {

        if (i%2 == 0) {
            [_leftDesignCaseArr addObject:[arr objectAtIndex:i]];
        }
        else {
            [_rightDesighCaseArr addObject:[arr objectAtIndex:i]];
        }
    }
    [_headerRefresh endRefreshing];
    [_footerRefresh endRefreshing];
    [_mainTableView reloadData];
}
-(void)downLoadFinish1:(NSNotification *)not
{
    _blogArr = [_downLoadManager getDataWithDownLoadString:not.name];
    [_headerRefresh endRefreshing];
    [_footerRefresh endRefreshing];
    [_mainTableView reloadData];
}
-(void)downLoadFinish2:(NSNotification *)not
{
    _commentArr = [_downLoadManager getDataWithDownLoadString:not.name];
    [_headerRefresh endRefreshing];
    [_footerRefresh endRefreshing];
    [_mainTableView reloadData];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 157;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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
