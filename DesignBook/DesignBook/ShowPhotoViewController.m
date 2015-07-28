//
//  ShowPhotoViewController.m
//  DesignBook
//
//  Created by Visitor on 14-11-9.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import "ShowPhotoViewController.h"
#import "MyNavigationBar.h"
#import "INTERFACE.h"
#import "DownLoadManager.h"
#import "PhotoDataItem.h"
#import "PhotoItem.h"
#import "UIImageView+WebCache.h"
//#import "UMSocial.h"

@interface ShowPhotoViewController ()<UIScrollViewDelegate>

@end

@implementation ShowPhotoViewController
{
    UIView *_bottomView;
    MyNavigationBar *_mnb;
    UIScrollView *_mainScrollView;
    DownLoadManager *_downLoadManager;
    NSMutableArray *_dataArray;
    UILabel *_indexLabel;
    UIImageView *_clickImageView;
    UITapGestureRecognizer *_tap;
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
    [self.navigationController setNavigationBarHidden:YES];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createNavigationBar];
    [self createTabBar];
    
    
    _mainScrollView = [[UIScrollView alloc]initWithFrame: CGRectMake(0, 20, 320, self.view.bounds.size.height-20)];
    _mainScrollView.backgroundColor = [UIColor blackColor];
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.delegate = self;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    
    _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [_mainScrollView addGestureRecognizer:_tap];
    
    [self.view addSubview:_mainScrollView];
    
    
    NSString *urlString = [NSString stringWithFormat:kURL_PHOTO,_idStr,_uidStr];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish:) name:urlString object:nil];
    _downLoadManager = [DownLoadManager sharedDownLoadManager];
    [_downLoadManager addDownLoadWithDownStr:urlString andDownLoadType:kTYPE_PHOTO andIsRefresh:NO andDownLoadPage:-1];
    
}
-(void)downLoadFinish:(NSNotification *)not
{
    NSLog(@"图片下载完成");
    _dataArray = [_downLoadManager getDataWithDownLoadString:not.name];
    _indexLabel.text = [NSString stringWithFormat:@"1/%@",((PhotoItem *)_dataArray[0]).totalnum];
    [self createScrollView];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)createScrollView
{
    PhotoItem *pi = _dataArray[0];
    _mainScrollView.contentSize = CGSizeMake(320*pi.totalnum.intValue, self.view.bounds.size.height-20);
    
    //清理本地资源
    /**********************************************************/
    dispatch_queue_t fileQueue = dispatch_queue_create("file", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(fileQueue, ^{
        NSString *str =[NSString stringWithFormat:@"%@/Library/Caches/temp",NSHomeDirectory()];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:str]) {
            NSLog(@"目录存在");
            
            NSArray *pathArr = [fileManager subpathsAtPath:str];
            if (pathArr.count>=200) {
                int n=0;
                for (NSString *string in pathArr) {
                    n++;
                    [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",str,string] error:nil];
                    if (n==pathArr.count/2) {
                        break;
                    }
                }
            }
        }
        else
        {
            [fileManager createDirectoryAtPath:str withIntermediateDirectories:YES attributes:nil error:nil];
        }
    });
    /************************************************************************************/

    for (int i = 0; i<pi.data.count; i++) {
        UIScrollView *scroll = [[UIScrollView alloc]init];
        scroll.showsHorizontalScrollIndicator = YES;
        scroll.showsVerticalScrollIndicator = NO;
        scroll.frame = CGRectMake(320*i, 0, 320, self.view.bounds.size.height-20);
        scroll.contentSize = CGSizeMake(320, self.view.bounds.size.height-20);
        scroll.maximumZoomScale = 3;
        scroll.minimumZoomScale = 1;
        scroll.delegate = self;
        scroll.showsHorizontalScrollIndicator = NO;
        scroll.showsVerticalScrollIndicator = NO;
        [_mainScrollView addSubview:scroll];
        
        PhotoDataItem *pdi = pi.data[i];
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.userInteractionEnabled = YES;
        imageView.tag = 100+i;
        imageView.frame = CGRectMake(0, 0, 320, self.view.bounds.size.height-20);
        /**********************************************************/
        
        NSArray *array = [pdi.path componentsSeparatedByString:@"/"];
        NSString *name = [array lastObject];
        NSString *path = [NSString stringWithFormat:@"%@/Library/Caches/temp/%@",NSHomeDirectory(),name];

        //判断本地有没有资源 如果有就不下载
        NSFileManager *fm = [NSFileManager defaultManager];
        if ([fm fileExistsAtPath:path]) {
            NSLog(@"本地资源存在");
            UIImage * image = [UIImage imageWithContentsOfFile:path];
            CGFloat scaleWidth = image.size.width/320.0;
            CGFloat scaleHeight = image.size.height/(self.view.bounds.size.height-20);
            CGFloat iwidth;
            CGFloat iheight;
            if (scaleWidth >=scaleHeight) {
                iwidth = 320;
                iheight = 320/image.size.width * image.size.height;
            }
            else
            {
                iheight = self.view.bounds.size.height - 20;
                iwidth = ((self.view.bounds.size.height - 20)/image.size.height) * image.size.width;
            }
            NSLog(@"iheight%f,iwidth%f",iheight,iwidth);
            imageView.frame = CGRectMake((self.view.bounds.size.width - iwidth)/2, (self.view.bounds.size.height -20 - iheight)/2, iwidth, iheight);
            imageView.image = image;
        }
       else
        {
            
            dispatch_queue_t myQueue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_CONCURRENT);
            dispatch_group_t myGroup = dispatch_group_create();
            dispatch_group_async(myGroup, myQueue, ^{
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:pdi.path]];
                [data writeToFile:path atomically:YES];
            });
            dispatch_group_notify(myGroup, myQueue, ^{
                NSLog(@"完成一个 %@",pdi.path);
                
                //回到主线程
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImage * image = [UIImage imageWithContentsOfFile:path];
                    
                    CGFloat imageWidth = image.size.width>0?image.size.width:1;
                    CGFloat imageHeight = image.size.height>0?image.size.height:1;
                    
                    CGFloat scaleWidth = image.size.width/320.0;
                    CGFloat scaleHeight = image.size.height/(self.view.bounds.size.height-20);
                    CGFloat iwidth;
                    CGFloat iheight;
                    if (scaleWidth >=scaleHeight) {
                        iwidth = 320;
                        iheight = 320/imageWidth * image.size.height;
                    }
                    else
                    {
                        iheight = self.view.bounds.size.height - 20;
                        iwidth = ((self.view.bounds.size.height - 20)/imageHeight) * image.size.width;
                    }
                    
                    imageView.frame = CGRectMake((self.view.bounds.size.width - iwidth)/2, (self.view.bounds.size.height -20 - iheight)/2, iwidth, iheight);
                    imageView.image = image;
                    imageView.backgroundColor = [UIColor redColor];
                });
            });
        }
         /************************************************************************************/

        [scroll addSubview:imageView];
        
        UITapGestureRecognizer *inTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        inTap.numberOfTapsRequired = 2;
        [imageView addGestureRecognizer:inTap];
        
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchAction:)];
        [imageView addGestureRecognizer:pinch];
        [_tap requireGestureRecognizerToFail:inTap];
    }
    [self.view bringSubviewToFront:_mnb];
    [self.view bringSubviewToFront:_bottomView];
}
-(void)tapAction:(UITapGestureRecognizer *)tap
{
    if(tap.numberOfTapsRequired == 2) {
        _clickImageView = (UIImageView *)tap.view;
        
        UIScrollView *scr = (UIScrollView *)_clickImageView.superview;
        
        if (scr.zoomScale >2) {
            [scr setZoomScale:1 animated:YES];
        }
        else{
            CGPoint point = [tap locationInView:_clickImageView];
            CGRect rect = CGRectMake(point.x - 50, point.y - 50, 100, 100);
            [scr zoomToRect:rect animated:YES];
        }
    }
    else if (tap.numberOfTapsRequired == 1) {
        
        if (_bottomView.alpha == 1) {
            [UIView animateWithDuration:0.2 animations:^{
                _bottomView.alpha = 0;
                _mnb.frame = CGRectMake(0, -44, 320, 44);
            }];
        }
        else{
            [UIView animateWithDuration:0.2 animations:^{
                _bottomView.alpha = 1;
                _mnb.frame = CGRectMake(0, 20, 320, 44);
            }];
        }
    }
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
//    NSLog(@"adfasdfasdfa");
//    NSLog(@"scrollView.contentSize = %f,%f",scrollView.contentSize.width,scrollView.contentSize.height);
//    NSLog(@"_clickImageView.center = %f,%f",_clickImageView.center.x,_clickImageView.center.y);
    UIImageView *imageView = [scrollView.subviews lastObject];
    
    if (scrollView.contentSize.width<=320 && scrollView.contentSize.height<=self.view.bounds.size.height - 20) {
        
         imageView.center = CGPointMake(320/2, (self.view.bounds.size.height - 20)/2);
        NSLog(@"1");
    }
    if (scrollView.contentSize.width<=320 && scrollView.contentSize.height>=self.view.bounds.size.height - 20) {
        imageView.center = CGPointMake(320/2, scrollView.contentSize.height/2);
        NSLog(@"2");
    }
    
    if (scrollView.contentSize.width>=320 && scrollView.contentSize.height<=self.view.bounds.size.height - 20) {
        imageView.center = CGPointMake(scrollView.contentSize.width/2, (self.view.bounds.size.height - 20)/2);
        NSLog(@"3");
    }
    if (scrollView.contentSize.width>=320 && scrollView.contentSize.height>=self.view.bounds.size.height - 20) {
        imageView.center = CGPointMake(scrollView.contentSize.width/2, scrollView.contentSize.height/2);
        NSLog(@"4");
    }
    
}
-(void)pinchAction:(UIPinchGestureRecognizer *)pinch
{
    UIImageView *imageView;
    if ([pinch.view isKindOfClass:[UIImageView class]]) {
        imageView = (UIImageView *)pinch.view;
    }
    imageView.transform = CGAffineTransformScale(imageView.transform, pinch.scale, pinch.scale);
    pinch.scale = 1;
}
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return [scrollView.subviews lastObject];
   // return _clickImageView;
}
-(void)createTabBar
{
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-49, 320, 49)];
    _bottomView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [self.view addSubview:_bottomView];
    for (int i =0 ; i<5; i++) {
        UIView *baseView = [[UIView alloc]initWithFrame:CGRectMake(_bottomView.bounds.size.width/5 * i, 0, _bottomView.bounds.size.width/5, _bottomView.bounds.size.height)];
        [_bottomView addSubview:baseView];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, baseView.bounds.size.width, baseView.bounds.size.height);
        NSString *str = [NSString stringWithFormat:@"tuku_bottom%d.png",i];
        [btn setImage:[[UIImage imageNamed:str] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [baseView addSubview:btn];
    }
}
-(void)btnClick:(UIButton *)btn
{
    int index = _mainScrollView.contentOffset.x/320;
    UIScrollView *scro = _mainScrollView.subviews[index];
    UIImageView *imageView = [scro.subviews lastObject];
    if (btn.tag == 2) {
        //分享
        //[UMSocialSnsService presentSnsIconSheetView:self appKey:@"54682b36fd98c509e9001066" shareText:nil shareImage:imageView.image shareToSnsNames:[NSArray arrayWithObjects:UMShareToRenren, UMShareToQzone, UMShareToSina ,UMShareToTencent,nil] delegate:nil];
    }
}
-(void)createNavigationBar
{
    _mnb = [[MyNavigationBar alloc]init];
    _mnb.frame = CGRectMake(0, 20, 320, 44);
    [_mnb createMyNavigationBarWithBgImageName:nil andTitle:nil andLeftBtnImageName:@"back_arrow.png" andLeftBtnTitle:nil andRightBtnImageName:nil andRightBtnTitle:nil andClass:self andSEL:@selector(navigationBarBtnClick:)];
    _mnb.backgroundColor = [UIColor colorWithRed:0.87f green:0.22f blue:0.20f alpha:1.00f];

    [self.view addSubview:_mnb];
    _indexLabel = [[UILabel alloc]init];
    _indexLabel.frame = CGRectMake(0, 0, 320, 44);
    _indexLabel.textAlignment = NSTextAlignmentCenter;
    _indexLabel.textColor = [UIColor whiteColor];
    
    [_mnb addSubview:_indexLabel];
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(0, -20, 320, 20);
    view.backgroundColor = [UIColor colorWithRed:0.87f green:0.22f blue:0.20f alpha:1.00f];
    [_mnb addSubview:view];
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    saveBtn.frame = CGRectMake(320-10-50, (44-29)/2, 50, 29);
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    saveBtn.tag = 0;
    [saveBtn addTarget:self action:@selector(navigationBarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_mnb addSubview:saveBtn];
    
    
    
}
-(void)navigationBarBtnClick:(UIButton *)btn
{
    if (btn.tag == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        NSLog(@"保存");
        
        int index = _mainScrollView.contentOffset.x/320;
        UIScrollView *scro = _mainScrollView.subviews[index];
        UIImageView *imageView = [scro.subviews lastObject];
        //imageView.image
        UIImageWriteToSavedPhotosAlbum(imageView.image, 0, 0, 0);
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"保存成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
   int currentIndex = _mainScrollView.contentOffset.x/320;
    _indexLabel.text = [NSString stringWithFormat:@"%d/%@",currentIndex+1,((PhotoItem *)_dataArray[0]).totalnum];
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
