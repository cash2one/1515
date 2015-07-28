  //
//  PublicViewController.m
//  DesignBook
//
//  Created by Visitor on 14-11-6.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import "PublicViewController.h"
#import "PublicSubViewController.h"
@interface PublicViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@end

@implementation PublicViewController
{
    UITableView *_tableView;
    NSMutableDictionary *_dataDict;
    UIView *_sectionHeaderView;
    BOOL _isHeaderBtnClick;
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
    [self createNavigationBar];
    [self prepareDataArray];
    [self createTableView];
    [self createHeaderBtn];
}

-(void)prepareDataArray
{
    NSArray *hoders = [NSArray arrayWithObjects:@"请填写您的姓名", @"请填写您的手机号码", @"请选择装修预算", @"请选择项目类型", @"请填写您的装修房屋的面积", nil];
    NSArray *titles = [NSArray arrayWithObjects:@"称呼", @"电话", @"预算", @"类型", @"面积", nil];
    NSArray *arrows = [NSArray arrayWithObjects:[NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:YES], [NSNumber numberWithBool:YES], [NSNumber numberWithBool:NO], nil];
    NSMutableArray *textFieldArray = [[NSMutableArray alloc]init];

    _dataDict = [[NSMutableDictionary alloc]init];
    for (int i = 0; i<5; i++) {
        UITextField *textField = [self addTextFieldWithPlaceholder:hoders[i] withTag:i];
        if (i == 2|| i== 3) {
            textField.userInteractionEnabled = NO;
        }
        [textFieldArray addObject:textField];
    }
    [_dataDict setObject:textFieldArray forKey:@"textField"];
    [_dataDict setObject:titles forKey:@"title"];
    [_dataDict setObject:arrows forKey:@"arrow"];
}
-(void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, 320, self.view.bounds.size.height-64-49) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.clipsToBounds = YES;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.93f alpha:1.00f];
    [self.view addSubview:_tableView];
}
-(void)createNavigationBar
{
    [self.navigationController setNavigationBarHidden:YES];
    self.view.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.93f alpha:1.00f];
    UIView *navView = [[UIView alloc]init];
    navView.frame = CGRectMake(0, 20, 320, 44);
    navView.backgroundColor = [UIColor colorWithRed:0.87f green:0.22f blue:0.20f alpha:1.00f];
    [self.view addSubview:navView];
    UILabel *label = [[UILabel alloc]init];
    label.frame = navView.bounds;
    label.text = self.vcTitle;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = [UIColor whiteColor];
    [navView addSubview:label];
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    loginBtn.frame = CGRectMake(navView.bounds.size.width-10-50, (44-29)/2, 50, 29);
    [loginBtn setTitle:@"提交" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    loginBtn.tag = 10000;
    [loginBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:loginBtn];
    
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(0, -20, 320, 20);
    view.backgroundColor = [UIColor colorWithRed:0.87f green:0.22f blue:0.20f alpha:1.00f];
    [navView addSubview:view];
}
-(void)btnClick:(UIButton *)btn
{
    NSLog(@"btn.tag = %d",btn.tag);

    if (btn.tag == 10000) {
        //事件
    }else
    {
        for (UIView *view in btn.superview.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton *)view;
                
                if (btn.tag == button.tag) {
                    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                }
                else
                {
                    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                }
                
            }
        }
        
        UIButton *pubBtn = (UIButton *)[self.view viewWithTag:10000];
        if (btn.tag == 10) {
            //事件
            _isHeaderBtnClick = NO;
            pubBtn.hidden = NO;
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [_tableView reloadData];
        }
        else if(btn.tag == 11)
        {
            //事件
            _isHeaderBtnClick = YES;
            pubBtn.hidden = YES;
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [_tableView reloadData];
        }
        
    }
}
-(void)createHeaderBtn
{
    _sectionHeaderView = [[UIView alloc]init];
    _sectionHeaderView.frame  = CGRectMake(0, 64, 320, 65);
    _sectionHeaderView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_sectionHeaderView];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    leftBtn.frame = CGRectMake(0, 0, 160, 45);
    [leftBtn setTitle:@"我想发布设计需求" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [leftBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.tag = 10;
    [_sectionHeaderView addSubview:leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    rightBtn.frame = CGRectMake(160, 0, 160, 45);
    [rightBtn setTitle:@"担保交易" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    rightBtn.tag = 11;
    [_sectionHeaderView addSubview:rightBtn];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.frame = CGRectMake(160, 11, 1, 45-22);
    lineView.backgroundColor = [UIColor lightGrayColor];
    lineView.alpha = 0.5;
    [_sectionHeaderView addSubview:lineView];
    
    //publicLabel
    UILabel *publicLabel = [[UILabel alloc]init];
    publicLabel.frame = CGRectMake(0, 45, 320, 20);
    publicLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    publicLabel.text = @" adsfsdfas";
    [_sectionHeaderView addSubview:publicLabel];
}

-(UIView *)pubicHeaderViewWithHeaderImageNameStr:(NSString *)imageName;
{
    UIImage *titleImage = [UIImage imageNamed:imageName];
    
    UIView *bgView = [[UIView alloc]init];
    bgView.frame = CGRectMake(0, 0, 320, 5+titleImage.size.height);
    bgView.backgroundColor = [UIColor clearColor];
    
    UIImageView *titleImageView = [[UIImageView alloc]initWithImage:titleImage];
    titleImageView.frame = CGRectMake(5, 5, 310, titleImage.size.height);
    [bgView addSubview:titleImageView];
    
    return bgView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 65;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _sectionHeaderView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isHeaderBtnClick == NO) {
        return 7;
    }
    else
        return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    //白色背景
    UIView *baseView = [[UIView alloc]init];
    baseView.frame = CGRectMake(5, 0, 310, 44);
    baseView.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview:baseView];
    //横线
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(10, 43, 290, 1);
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.2;
    [baseView addSubview:view];
    if (_isHeaderBtnClick == NO) {
        if (indexPath.row == 0) {
            [baseView removeFromSuperview];
            [cell.contentView addSubview:[self pubicHeaderViewWithHeaderImageNameStr:@"publish_img1.png"]];
        }
        else if(indexPath.row <6) {
            [cell.contentView addSubview:[[_dataDict objectForKey:@"textField"] objectAtIndex:indexPath.row-1]];
            cell.textLabel.text = [[_dataDict objectForKey:@"title"] objectAtIndex:indexPath.row-1];
            if ([[[_dataDict objectForKey:@"arrow"] objectAtIndex:indexPath.row-1] boolValue]) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            if (indexPath.row == 5) {
                UILabel *sizeLabel = [[UILabel alloc]init];
                sizeLabel.frame = CGRectMake(285, 0, 20, 44);
                sizeLabel.numberOfLines = 0;
                sizeLabel.text = @"㎡";
                [baseView addSubview:sizeLabel];
            }
        }
        else{
            [view removeFromSuperview];
        }
    }
    else{
        if (indexPath.row == 0) {
            [cell.contentView addSubview:[self pubicHeaderViewWithHeaderImageNameStr:@"publish_img2.png"]];
        }
    }
    return cell;
}
-(UITextField *)addTextFieldWithPlaceholder:(NSString *)holder withTag:(int)fieldTag;
{
    UITextField *textField1 = [[UITextField alloc]init];
    textField1.frame = CGRectMake(60, 0, 220, 44);
    textField1.delegate = self;
    textField1.placeholder = holder;
    textField1.returnKeyType = UIReturnKeyDone;
    textField1.tag = fieldTag;
    [textField1 addTarget:self action:@selector(textFieldAction:) forControlEvents:UIControlEventEditingDidBegin];
    textField1.textAlignment = NSTextAlignmentRight;
    return textField1;
}
-(void)textFieldAction:(UITextField *)text
{
    NSLog(@"action");
    if (text.tag<2||text.tag>3) {
        _tableView.frame = CGRectMake(0, 64, 320, self.view.bounds.size.height-64-216);
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    _tableView.frame = CGRectMake(0, 64, 320, self.view.bounds.size.height-64-49);
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 2) {
        [textField resignFirstResponder];
        PublicSubViewController *psvc = [[PublicSubViewController alloc]init];
        psvc.subTitle = @"装修预算";
        psvc.sourceType = @"yusuan";
        psvc.returnStrBlock = ^(NSString *str)
        {
            textField.text = str;
        };
        [self.navigationController pushViewController:psvc animated:YES];
    }
    else if(textField.tag == 3)
    {
        [textField resignFirstResponder];
        PublicSubViewController *psvc = [[PublicSubViewController alloc]init];
        psvc.subTitle = @"项目类型";
        psvc.sourceType = @"leixing";
        psvc.returnStrBlock = ^(NSString *str)
        {
            textField.text = str;
        };
        [self.navigationController pushViewController:psvc animated:YES];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
     [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    for (UITableViewCell *cell in _tableView.visibleCells) {
        for (UIView *view in cell.contentView.subviews) {
            if ([view isKindOfClass:[UITextField class]]) {
                [view resignFirstResponder];
            }
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if (_isHeaderBtnClick == NO) {
            return 86;
        }
        else
            return 288;
    }
    else
        return 44;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UITextField *textField;
    for (UIView *view in cell.contentView.subviews) {
        if ([view isKindOfClass:[UITextField class]]) {
            textField = (UITextField *)view;
        }
    }
    
    if (indexPath.row == 3) {
        PublicSubViewController *psvc = [[PublicSubViewController alloc]init];
        psvc.subTitle = @"装修预算";
        psvc.sourceType = @"yusuan";
        psvc.returnStrBlock = ^(NSString *str)
        {
            textField.text = str;
        };
        [self.navigationController pushViewController:psvc animated:YES];
    }
    else if(indexPath.row == 4)
    {
        PublicSubViewController *psvc = [[PublicSubViewController alloc]init];
        psvc.subTitle = @"项目类型";
        psvc.sourceType = @"leixing";
        psvc.returnStrBlock = ^(NSString *str)
        {
            textField.text = str;
        };
        [self.navigationController pushViewController:psvc animated:YES];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
