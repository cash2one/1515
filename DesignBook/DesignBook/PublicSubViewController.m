//
//  PublicSubViewController.m
//  DesignBook
//
//  Created by Visitor on 14-11-9.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import "PublicSubViewController.h"
#import "MyNavigationBar.h"
@interface PublicSubViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation PublicSubViewController
{
    NSMutableDictionary *_dataDict;
    UITableView *_tableView;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self prepareNavigationBar];
    [self prepareDataSource];
    [self prepareTableView];
}
-(void)prepareNavigationBar
{
    [self.navigationController setNavigationBarHidden:YES];
    MyNavigationBar *mnb = [[MyNavigationBar alloc]init];
    mnb.frame = CGRectMake(0, 20, 320, 44);
    [mnb createMyNavigationBarWithBgImageName:@"NavigatetBgc.png" andTitle:self.subTitle andLeftBtnImageName:@"back_arrow.png" andLeftBtnTitle:nil andRightBtnImageName:nil andRightBtnTitle:nil andClass:self andSEL:@selector(navigationBarBtnClick:)];
    self.view.backgroundColor = [UIColor colorWithRed:0.87f green:0.22f blue:0.20f alpha:1.00f];
    [self.view addSubview:mnb];
}
-(void)navigationBarBtnClick:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)prepareDataSource
{
    _dataDict = [[NSMutableDictionary alloc]init];
    //装修预算
    NSArray *array1 = [[NSArray alloc]initWithObjects:@"3000元以下",@"3000-6000元",@"6000-10000元",@"10000-50000元",@"50000-100000元",@"100000元以上", nil];
    //项目类型
    NSArray *array2 = [[NSArray alloc]initWithObjects:@"住宅空间", @"餐饮空间",@"办公空间",@"酒店空间",@"商业展示",@"娱乐空间",@"休闲场所",@"文化空间",@"医疗机构",@"售楼中心",@"金融机构",@"运动场所",@"教育机构",@"其他",nil];
    [_dataDict setObject:array1 forKey:@"yusuan"];
    [_dataDict setObject:array2 forKey:@"leixing"];
}
-(void)prepareTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, 320, self.view.bounds.size.height-64-49) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataDict[_sourceType] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"acell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"acell"];
    }
    cell.textLabel.text = [_dataDict[_sourceType] objectAtIndex:indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selStr = [_dataDict[_sourceType] objectAtIndex:indexPath.row];
    self.returnStrBlock(selStr);
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
