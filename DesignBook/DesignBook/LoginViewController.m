




//
//  LoginViewController.m
//  DesignBook
//
//  Created by Visitor on 14-11-17.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import "LoginViewController.h"
#import "MyNavigationBar.h"
//#import "UMSocial.h"
#import "INTERFACE.h"


@interface LoginViewController ()<UITextFieldDelegate,NSURLConnectionDataDelegate>

@end

@implementation LoginViewController
{
    NSMutableData *_data;
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
    self.view.backgroundColor = [UIColor blackColor];
    [self createNavigationBar];
    [self createUI];
}
-(void)createUI;
{
    UIView *backView = [[UIView alloc]init];
    backView.frame = CGRectMake(0, 64, 320, self.view.bounds.size.height-64);
    backView.backgroundColor = [UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1.00f];
    [self.view addSubview:backView];
    
    UIView *textBaseView = [[UIView alloc]init];
    textBaseView.frame = CGRectMake(10, 10, 300, 110);
    textBaseView.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.93f alpha:1.00f];
    [backView addSubview:textBaseView];
    
    UIView *leftView = [[UIView alloc]init];
    leftView.frame = CGRectMake(0, 0, 10, 40);
    leftView.backgroundColor = [UIColor whiteColor];
    UIView *leftView1 = [[UIView alloc]init];
    leftView1.frame = CGRectMake(0, 0, 10, 40);
    leftView1.backgroundColor = [UIColor whiteColor];
    
    UITextField *nameTextField = [[UITextField alloc]init];
    nameTextField.frame = CGRectMake(10, 10, 280, 40);
    nameTextField.clearButtonMode = UITextFieldViewModeAlways;
    nameTextField.borderStyle = UITextBorderStyleNone;
    nameTextField.backgroundColor = [UIColor whiteColor];
    nameTextField.placeholder = @"   请输入Email/用户名";
    nameTextField.font = [UIFont systemFontOfSize:15];
    nameTextField.leftView = leftView;
    nameTextField.delegate = self;
    nameTextField.leftViewMode = UITextFieldViewModeAlways;
    [textBaseView addSubview:nameTextField];
    
    UITextField *passWordTF = [[UITextField alloc]init];
    passWordTF.frame = CGRectMake(10, 60, 280, 40);
    passWordTF.borderStyle = UITextBorderStyleNone;
    passWordTF.backgroundColor = [UIColor whiteColor];
    passWordTF.placeholder = @"   请输入密码";
    passWordTF.secureTextEntry = YES;
    passWordTF.font = [UIFont systemFontOfSize:15];
    passWordTF.leftView = leftView1;
    passWordTF.delegate = self;
    passWordTF.leftViewMode = UITextFieldViewModeAlways;
    passWordTF.clearButtonMode = UITextFieldViewModeAlways;
    [textBaseView addSubview:passWordTF];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(10, 130, 300, 40);
    btn.backgroundColor = [UIColor colorWithRed:0.86f green:0.22f blue:0.21f alpha:1.00f];
    [btn setTitle:@"登陆" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [backView addSubview:btn];
    
    for (int i = 0 ; i< 12; i++) {
        UIView *view = [[UIView alloc]init];
        view.frame = CGRectMake(12+(3+2)*i, 200, 3, 1);
        view.backgroundColor = [UIColor lightGrayColor];
        [backView addSubview:view];
    }
    for (int i = 0 ; i< 12; i++) {
        UIView *view = [[UIView alloc]init];
        view.frame = CGRectMake(250+(3+2)*i, 200, 3, 1);
        view.backgroundColor = [UIColor lightGrayColor];
        [backView addSubview:view];
    }
    
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake((320-150)/2, 190, 150, 15);
    label.text = @"使用第三方账号登陆";
    label.textColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15];
    [backView addSubview:label];
    
    
    UIButton *sinaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sinaBtn.frame = CGRectMake(10, 220, 300, 40);
    sinaBtn.tag = 1;
    sinaBtn.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.93f alpha:1.00f];
    [sinaBtn addTarget:self action:@selector(thirdBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:sinaBtn];
    
    UIImageView *sinaImageView = [[UIImageView alloc]init];
    sinaImageView.frame = CGRectMake(5, 2, 36, 36);
    sinaImageView.image = [UIImage imageNamed:@"sina.png"];
    [sinaBtn addSubview:sinaImageView];
    UILabel *sinaLabel = [[UILabel alloc]init];
    sinaLabel.frame = CGRectMake(50, 0, 100, 40);
    sinaLabel.textColor = [UIColor lightGrayColor];
    sinaLabel.font = [UIFont systemFontOfSize:15];
    sinaLabel.text = @"新浪微博";
    [sinaBtn addSubview:sinaLabel];
    UIImage *arrowImage = [UIImage imageNamed:@"table_arrow.png"];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:arrowImage];
    imageView.frame = CGRectMake(280, 15, 7, 13);
    [sinaBtn addSubview:imageView];
    
    
    
    UIButton *qqBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    qqBtn.frame = CGRectMake(10, 270, 300, 40);
    qqBtn.tag = 2;
    qqBtn.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.93f alpha:1.00f];
    [qqBtn addTarget:self action:@selector(thirdBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:qqBtn];
    
    UIImageView *qqImageView = [[UIImageView alloc]init];
    qqImageView.frame = CGRectMake(5, 2, 36, 36);
    qqImageView.image = [UIImage imageNamed:@"qq.png"];
    [qqBtn addSubview:qqImageView];
    UILabel *qqLabel = [[UILabel alloc]init];
    qqLabel.frame = CGRectMake(50, 0, 100, 40);
    qqLabel.textColor = [UIColor lightGrayColor];
    qqLabel.font = [UIFont systemFontOfSize:15];
    qqLabel.text = @"QQ";
    [qqBtn addSubview:qqLabel];
    
    UIImageView *imageView2 = [[UIImageView alloc]initWithImage:arrowImage];
    imageView2.frame = CGRectMake(280, 15, 7, 13);
    [qqBtn addSubview:imageView2];
}
-(void)thirdBtnClick:(UIButton *)btn
{
    if (btn.tag == 1) {
        NSLog(@"新浪登陆");
//        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
//        
//        snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
//            NSLog(@"response");
//        });
//        //设置回调对象
//        [UMSocialControllerService defaultControllerService].socialUIDelegate = self;
//
    }
    else{
        NSLog(@"qq登陆");
    }
}

//实现授权回调
//-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
//{
//    if (response.viewControllerType == UMSViewControllerOauth) {
//        NSLog(@"didFinishOauthAndGetAccount response is %@",response);
//        
//        //UMSResponseCodeSuccess 代表授权成功
//        if (response.responseCode == UMSResponseCodeSuccess) {
//            //授权成功
//            NSLog(@"授权成功");
//        }
//        else
//        {
//            //授权失败
//            NSLog(@"授权失败%@",[response.data objectForKey:@"sina"]);
//        }
//    }
//}
//关闭授权页面调用方法
//-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType
//{//    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToSina  completion:^(UMSocialResponseEntity *response){
//        NSLog(@"获取数据  SnsInformation is %@",response.data);
//        NSLog(@"toker = %@",[response.data objectForKey:@"access_token"]);
//        
//        if ([response.data objectForKey:@"access_token"]) {
//            //登陆成功
//            //开始向服务器发送数据
//            NSLog(@"发送数据");
//            NSString *token = [response.data objectForKey:@"access_token"];
//            NSString *screen_name = [[response.data objectForKey:@"screen_name"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            NSString *uid = [response.data objectForKey:@"uid"];
//            NSString *email = [@"davefw@sohu.com" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            
//           // NSURL *url = [NSURL URLWithString:kURL_LOGIN_POST];
//            NSString *bodyString = [NSString stringWithFormat:@"email=%@&indentity=1&username=%@&token=%@&openid=%@",email,screen_name,token,uid];
//            
//            NSString *urlString = [NSString stringWithFormat:kURL_LOGIN_POST,bodyString];
//            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
////            request.HTTPMethod = @"POST";
////            NSData *data = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
////            request.HTTPBody = data;
//
//            //用post请求得到的是 -1;
//            
//           NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
//            [connection start];
//            NSLog(@"url = %@",bodyString);
//        }
//    }];

//}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"登陆 收到服务器响应");
    _data = [[NSMutableData alloc]init];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_data appendData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:_data options:NSJSONReadingMutableContainers error:nil];
    NSString *msg = [rootDict objectForKey:@"msg"];
    NSLog(@"msg = %@",msg);
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:msg forKey:@"msg"];
    [userDefault synchronize];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"登陆失败");
}

/*
 //获取accestoken以及新浪用户信息，得到的数据在回调Block对象形参respone的data属性
 [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToSina  completion:^(UMSocialResponseEntity *response){
 NSLog(@"SnsInformation is %@",response.data);
 }];
 */

-(void)loginBtnClick:(UIButton *)btn
{
    NSLog(@"登陆");
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)createNavigationBar
{
    [self.navigationController setNavigationBarHidden:YES];
    MyNavigationBar *mnb = [[MyNavigationBar alloc]init];
    mnb.frame = CGRectMake(0, 20, 320, 44);
    [mnb createMyNavigationBarWithBgImageName:nil andTitle:@"登陆" andLeftBtnImageName:@"back_arrow.png" andLeftBtnTitle:nil andRightBtnImageName:nil andRightBtnTitle:nil andClass:self andSEL:@selector(navigationBarBtnClick:)];
    self.view.backgroundColor = [UIColor colorWithRed:0.87f green:0.22f blue:0.20f alpha:1.00f];
    [self.view addSubview:mnb];
}
-(void)navigationBarBtnClick:(UIButton *)btn
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
