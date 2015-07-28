//
//  SearchViewController.m
//  DesignBook
//
//  Created by Visitor on 14-11-14.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import "SearchViewController.h"
#import "MyNavigationBar.h"
#import "DownLoadManager.h"
#import "INTERFACE.h"
#import "SearchResultViewController.h"
@interface SearchViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@end

@implementation SearchViewController
{
    UITextField *_searchTextField;
    UITableView *_tableView;
    UIView *_baseView;
    DownLoadManager *_downLoadManage;
    NSMutableArray *_keyWordArr;
    NSMutableArray *_searchTypeArr;
    NSArray *_searchNameArray;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _downLoadManage = [DownLoadManager sharedDownLoadManager];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self createNavigationBar];
    [self createTableView];
    _searchTextField = [[UITextField alloc]init];
    _searchTextField.borderStyle = UITextBorderStyleRoundedRect;
    _searchTextField.frame = CGRectMake(0, 64, 320, 44);
    _searchTextField.placeholder = @"请输入你要搜索的内容或关键字";
    _searchTextField.delegate = self;
    _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _searchTextField.returnKeyType = UIReturnKeySearch;
    _searchTextField.rightViewMode = UITextFieldViewModeUnlessEditing;
    
    [self.view addSubview:_searchTextField];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    UIImage *image = [UIImage imageNamed:@"search_red.png"];
    imageView.frame = CGRectMake(0, (44-image.size.height)/2, image.size.width, image.size.height);
    imageView.image = image;
    UIView *rightView = [[UIView alloc]init];
    rightView.frame = CGRectMake(0, 0, 42, 44);
    [rightView addSubview:imageView];
    _searchTextField.rightView = rightView;
    

    _baseView = [[UIView alloc]init];
    _baseView.frame = CGRectMake(0, 64+44, 320, 165);
    _baseView.hidden = YES;
    [self.view addSubview:_baseView];
    [self createNineBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldNot) name:@"UITextFieldTextDidChangeNotification" object:nil];
    
    NSString *urlStr = [NSString stringWithFormat:kURL_SEARCH_KEYWORD];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish:) name:urlStr object:nil];
    [_downLoadManage addDownLoadWithDownStr:urlStr andDownLoadType:kTYPE_SEARCH_KEYWORD andIsRefresh:YES andDownLoadPage:-1];

    _searchNameArray = [[NSArray alloc]initWithObjects:@"找设计师",@"找装修图片",@"找有问必答", nil];
}

-(void)textFieldNot
{
    if (_searchTextField.text.length == 0) {
        _tableView.hidden = YES;
        
        UIButton *btn = (UIButton *)_baseView.subviews.firstObject;
        if (btn.titleLabel.text.length>0) {
            _baseView.hidden = NO;
        }
        else
        {
            _baseView.hidden = YES;
        }
        
    }
}
-(void)createNineBtn
{
    CGFloat space = (320 - 95*3)/4.0;
    for (int i = 0; i<9; i++) {
        int x = i/3;
        int y = i%3;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(space + (95+space)*x, space + (space + 40)*y, 95, 40);
        btn.tag = 100+i;
        btn.backgroundColor = [UIColor whiteColor];
        if (_keyWordArr.count>0) {
            [btn setTitle:_keyWordArr[i] forState:UIControlStateNormal];
        }
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_baseView addSubview:btn];
    }
}
-(void)btnClick:(UIButton *)btn
{
    NSLog(@"btnClick");
    
    SearchResultViewController *srvc = [[SearchResultViewController alloc]init];
    srvc.enterType = 1;
    srvc.vcTitle = btn.currentTitle;
    srvc.keyWord = [btn.currentTitle stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.navigationController pushViewController:srvc animated:YES];

}
-(void)createNavigationBar
{
    [self.navigationController setNavigationBarHidden:YES];
    MyNavigationBar *mnb = [[MyNavigationBar alloc]init];
    mnb.frame = CGRectMake(0, 20, 320, 44);
    [mnb createMyNavigationBarWithBgImageName:nil andTitle:@"搜索" andLeftBtnImageName:@"back_arrow.png" andLeftBtnTitle:nil andRightBtnImageName:nil andRightBtnTitle:nil andClass:self andSEL:@selector(navigationBarBtnClick:)];
    self.view.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.93f alpha:1.00f];
    mnb.backgroundColor = [UIColor colorWithRed:0.87f green:0.22f blue:0.20f alpha:1.00f];
    [self.view addSubview:mnb];
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
    topView.backgroundColor = [UIColor colorWithRed:0.87f green:0.22f blue:0.20f alpha:1.00f];
    [self.view addSubview:topView];
    [self.view addSubview:mnb];

    [mnb addSubview:_searchTextField];
}
-(void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+44, 320, self.view.bounds.size.height-64-44) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.hidden = YES;
    _tableView.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.93f alpha:1.00f];
    [self.view addSubview:_tableView];
}
-(void)navigationBarBtnClick:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - DownLoadManager
-(void)downLoadFinish:(NSNotification *)not
{
    _keyWordArr = [_downLoadManage getDataWithDownLoadString:not.name];
    for (UIView *subView in _baseView.subviews) {
        [subView removeFromSuperview];
    }
    _baseView.hidden = NO;
    
    [self createNineBtn];
}
-(void)downLoadFinish1:(NSNotification *)not
{
    _searchTypeArr = [_downLoadManage getDataWithDownLoadString:not.name];
    [_tableView reloadData];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:not.name object:nil];
}
#pragma mark - TextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *textStr;
    if ([string isEqualToString:@" "]) {
        textStr = [_searchTextField.text stringByAppendingString:@"\"\""];
        textField.text = @"\"\"";
    }
    else
    {
        textStr = [_searchTextField.text stringByAppendingString:string];
    }
    //NSString *textStr = [_searchTextField.text stringByAppendingString:string];
    NSString *textStrFormat = [textStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"textStrFormat = %@",textStrFormat);
    NSString *urlStr = [NSString stringWithFormat:kURL_SEARCH_TYPE,textStrFormat];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish1:) name:urlStr object:nil];
    [_downLoadManage addDownLoadWithDownStr:urlStr andDownLoadType:kTYPE_SEARCH_TYPE andIsRefresh:YES andDownLoadPage:-1];
    
    _tableView.hidden = NO;
    _baseView.hidden = YES;
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    _tableView.hidden = YES;
    
    UIButton *btn = (UIButton *)_baseView.subviews.firstObject;
    if (btn.titleLabel.text.length>0) {
       _baseView.hidden = NO;
    }
    else
    {
        _baseView.hidden = YES;
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    SearchResultViewController *srvc = [[SearchResultViewController alloc]init];
    srvc.enterType = 1;
    srvc.vcTitle = _searchTextField.text;
    srvc.keyWord = [_searchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.navigationController pushViewController:srvc animated:YES];
    
    return YES;
}

#pragma mark - TableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _searchTypeArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    for (UIView *subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    cell.textLabel.text = [_searchNameArray objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(0, 0, 310, 44);
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor darkGrayColor];
    label.text = [NSString stringWithFormat:@"%@个结果",_searchTypeArr[indexPath.row]];
    label.textAlignment = NSTextAlignmentRight;
    [cell.contentView addSubview:label];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0001;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchResultViewController *srvc = [[SearchResultViewController alloc]init];
    srvc.enterType = indexPath.row;
    srvc.vcTitle = _searchTextField.text;
    srvc.keyWord = [_searchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.navigationController pushViewController:srvc animated:YES];
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
     _baseView.hidden = NO;
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
