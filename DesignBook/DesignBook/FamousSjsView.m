//
//  FamousSjsView.m
//  DesignBook
//
//  Created by Visitor on 14-11-7.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import "FamousSjsView.h"
#import "UIImageView+WebCache.h"
#import "FamousSjsItem.h"
#import "SjsItem.h"
#import "HomeViewController.h"
#import "PersonDetailViewController.h"
#import "UIImage+ImageBlur.h"
@implementation FamousSjsView
{
    UILabel *_numPeoLabel;
    UIScrollView *_mainScrollView;
    
    NSMutableArray *_sjsArr;
    NSMutableArray *_scrollImageURLs;
    NSMutableArray *_nameArray;
    
    UIPageControl *_pageControl;
    HomeViewController *_classObject;
    
    FamousSjsItem *_fsi;
    
    
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)createFamousSjsViewWithArray:(NSArray *)array addClass:(id)classObjcet
{
    _classObject = classObjcet;
    _fsi = [array objectAtIndex:1];
    
    [self createLabelWithNumber:_fsi.famousSjsNum];
    [self createBigImageViewWith:_fsi.big];
    [self createScrollViewWithFamousSjsItemArr:_fsi.sjs];
    [self createPageControl];
}
-(void)createPageControl
{
    _pageControl = [[UIPageControl alloc]init];
    _pageControl.numberOfPages = 2;
    _pageControl.currentPage = 0;
    _pageControl.frame = CGRectMake(10, 245, 300, 30);
    _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    [self addSubview:_pageControl];
}
-(void)createLabelWithNumber:(NSString *)number
{
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.frame = CGRectMake(10, 0, 150, 30);
    titleLabel.text = @"知名设计师推荐";
    titleLabel.textColor = [UIColor darkGrayColor];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:titleLabel];
    
    UILabel *fontLabel = [[UILabel alloc]init];
    fontLabel = [[UILabel alloc]init];
    fontLabel.frame = CGRectMake(320-42, 15, 32, 10);
    fontLabel.text = @"人在线";
    fontLabel.font = [UIFont systemFontOfSize:10];
    fontLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:fontLabel];
    
    _numPeoLabel = [[UILabel alloc]init];
    _numPeoLabel.frame = CGRectMake(160, 15,160-42, 10);
    _numPeoLabel.text = [NSString stringWithFormat:@"%@",number];
    _numPeoLabel.font = [UIFont systemFontOfSize:10];
    _numPeoLabel.textColor = [UIColor redColor];
    _numPeoLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_numPeoLabel];
}
-(void)createBigImageViewWith:(BigItem *)big;
{
    UIImageView *bigImageView = [[UIImageView alloc]init];
    bigImageView.contentMode = UIViewContentModeScaleAspectFill;
    bigImageView.clipsToBounds = YES;
    NSURL *url = [NSURL URLWithString:big.path];
    //downLoadImage 进行模糊
    NSArray *array = [big.path componentsSeparatedByString:@"/"];
    NSString *name = [array lastObject];
    NSString *path = [NSString stringWithFormat:@"%@/Library/Caches/temp/%@",NSHomeDirectory(),name];

    //判断本地有没有资源 如果有就不下载
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:path]) {
        UIImage * image = [UIImage imageWithContentsOfFile:path];
        bigImageView.image = [image imageWithGaussianBlur9];
    }
    else
    {
        dispatch_queue_t myQueue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_CONCURRENT);
        dispatch_group_t myGroup = dispatch_group_create();
        dispatch_group_async(myGroup, myQueue, ^{
            NSData *data = [NSData dataWithContentsOfURL:url];
            [data writeToFile:path atomically:YES];
        });
        
        dispatch_group_notify(myGroup, myQueue, ^{
            NSLog(@"完成一个");
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage * image = [UIImage imageWithContentsOfFile:path];
                
                bigImageView.image = [image imageWithGaussianBlur9];
            });
        });
    }
    
    bigImageView.frame = CGRectMake(10, 30, 300, 115);
    [self addSubview:bigImageView];
    
    UIImageView *headBgView = [[UIImageView alloc]init];
    UIImage *image = [UIImage imageNamed:@"icon_12.png"];
    headBgView.image = image;
    headBgView.frame = CGRectMake(30+10, (bigImageView.bounds.size.height - image.size.height)/2+30, image.size.width, image.size.height);
    [self addSubview:headBgView];
    
    UIImageView *headImageView = [[UIImageView alloc]init];
    headImageView.frame = CGRectMake(5.6, 4.7, image.size.width-12, image.size.height-12);
    NSURL *headUrl = [NSURL URLWithString:big.headphoto];
    NSLog(@"photo%@",big.headphoto);
    headImageView.layer.cornerRadius = (image.size.height-12)/2.0;
    headImageView.layer.masksToBounds = YES;
    [headImageView setImageWithURL:headUrl];
    [headBgView addSubview:headImageView];
    
    UIImageView *topImageView = [[UIImageView alloc]init];
    UIImage *topImage = [UIImage imageNamed:@"icon_top.png"];
    topImageView.image = topImage;
    topImageView.frame = CGRectMake(120+10, 26+30, topImage.size.width, topImage.size.height);
    [self addSubview:topImageView];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.frame = CGRectMake(120+10, 22+topImage.size.height + 30, 300-120, 30);
    titleLabel.text = big.nick;
    titleLabel.shadowColor = [UIColor blackColor];
    titleLabel.shadowOffset = CGSizeMake(1, 1);
    
    titleLabel.font  = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = [UIColor whiteColor];
    [self addSubview:titleLabel];
    
    UILabel *countLabel = [[UILabel alloc]init];
    countLabel.frame = CGRectMake(120 + 10, 50+topImage.size.height+30, 300-120, 12);
    countLabel.font = [UIFont systemFontOfSize:12];
    countLabel.text = [NSString stringWithFormat:@"已被预约%@次",big.yuyueNum];
    countLabel.textColor = [UIColor whiteColor];
    countLabel.shadowColor = [UIColor blackColor];
    countLabel.shadowOffset = CGSizeMake(1, 1);
    [self addSubview:countLabel];
    
    UIButton *frontBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    frontBtn.frame = CGRectMake(10, 30, 300, 115);
    [frontBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:frontBtn];

}
-(void)createScrollViewWithFamousSjsItemArr:(NSArray *)famousSjss
{
    
    _mainScrollView = [[UIScrollView alloc]init];
    _mainScrollView.frame = CGRectMake(10, 147.5, 300, 245-147.5);
    _mainScrollView.delegate = self;
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.contentSize = CGSizeMake(600, 220-147.5);
    [self addSubview:_mainScrollView];
    
    
    CGFloat imageH = 220 - 147.5;
    CGFloat space = 0.0;
    
    for (int i =0 ; i<8; i++) {
        if (i>=4) {
           space =(300 - (imageH)*4)/3;
        }
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.frame = CGRectMake(( imageH + (300 - imageH*4)/3)*i - space, 0, imageH, imageH);
        NSURL *headURL = [NSURL URLWithString:((SjsItem *)(famousSjss[i])).headphoto];
        [imageView setImageWithURL:headURL placeholderImage:[UIImage imageNamed:@""]];
        [_mainScrollView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake((imageH + (300 - imageH*4)/3)*i - space, imageH, imageH, 25);
        label.text = ((SjsItem *)(famousSjss[i])).nick;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor darkGrayColor];
        [_mainScrollView addSubview:label];
        
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        imageView.tag = i;
        [imageView addGestureRecognizer:tap];
    }
}
-(void)tapAction:(UITapGestureRecognizer *)tap
{
    int index = tap.view.tag;
    
    PersonDetailViewController *pdvc = [[PersonDetailViewController alloc]init];
    pdvc.uid = ((SjsItem *)(_fsi.sjs[index])).uid;
    pdvc.nick = ((SjsItem *)(_fsi.sjs[index])).nick;
    [_classObject.navigationController pushViewController:pdvc animated:YES];

}
-(void)btnClick:(UIButton *)btn
{
    PersonDetailViewController *pdvc = [[PersonDetailViewController alloc]init];
    pdvc.uid = _fsi.big.added_by;
    pdvc.nick = _fsi.big.nick;
    [_classObject.navigationController pushViewController:pdvc animated:YES];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int index = scrollView.contentOffset.x/300;
    _pageControl.currentPage = index;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
