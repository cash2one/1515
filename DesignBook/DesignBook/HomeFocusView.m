//
//  HomeFocusView.m
//  DesignBook
//
//  Created by Visitor on 14-11-6.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import "HomeFocusView.h"
#import "UIImageView+WebCache.h"
#import "HotImgArrItem.h"
#import "ShowPhotoViewController.h"
#import "HomeViewController.h"
@implementation HomeFocusView
{
    NSMutableArray *_titleArray;
    NSMutableArray *_collectionArray;
    NSMutableArray *_imageURLArray;
    NSMutableArray *_idStrs;
    NSMutableArray *_uidStrs;
    
    UIScrollView *_mainScrollView;
    int _currentIndex;
    UIPageControl *_pageControl;
    UILabel *_collectionLabel;
    UILabel *_titleLabel;
    HomeViewController *_classObject;
    
    NSTimer *_timer;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _titleArray = [[NSMutableArray alloc]init];
        _collectionArray = [[NSMutableArray alloc]init];
        _imageURLArray = [[NSMutableArray alloc]init];
        _idStrs = [[NSMutableArray alloc]init];
        _uidStrs = [[NSMutableArray alloc]init];
        _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    }
    return self;
}
-(void)timerAction
{
    [_mainScrollView setContentOffset:CGPointMake(640, 0) animated:YES];
}
-(void)createFocusViewWithHotImgArr:(NSArray *)hotArr andClass:(id)classObject;
{
    _classObject = classObject;
    NSArray *hotArray = [hotArr objectAtIndex:2];
    
    for (HotImgArrItem *item in hotArray) {
        [_titleArray addObject:item.title];
        NSURL *url =[NSURL URLWithString:item.img];
        [_imageURLArray addObject:url];
        [_collectionArray addObject:item.col_num];
        [_idStrs addObject:item.uid];
        [_uidStrs addObject:item.category];
    }
    _currentIndex = 0;
    [self reloadLayout];
}
-(void)reloadLayout
{
    _mainScrollView = [[UIScrollView alloc]init];
    _mainScrollView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    _mainScrollView.contentSize = CGSizeMake(320*3, self.bounds.size.height);
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.delegate = self;
    self.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:_mainScrollView];

    //设置pageControl
    UIImage *image = [UIImage imageNamed:@"page_bg.png"];
    UIImageView *pageImageView = [[UIImageView alloc]init];
    pageImageView.image = image;
    pageImageView.frame = CGRectMake(self.frame.size.width-12-image.size.width, self.frame.size.height - 20, image.size.width, image.size.height);
    [self addSubview:pageImageView];

    _pageControl = [[UIPageControl alloc]init];
    _pageControl.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    _pageControl.numberOfPages = _imageURLArray.count;
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    _pageControl.pageIndicatorTintColor = [UIColor darkGrayColor];
    [pageImageView addSubview:_pageControl];
    
    UIView *sideBaseView = [[UIView alloc]init];
    sideBaseView.frame = CGRectMake(0, 0, 117, self.bounds.size.height);
    sideBaseView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [self addSubview:sideBaseView];
    
    for (int i = 0; i< 19 ; i++) {
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.8];
        line.frame = CGRectMake(10 + 5*i, 62, 3, 1.3);
        [self addSubview:line];
    }
    
    UIImage *starImage = [UIImage imageNamed:@"collect_star.png"];
    UIImageView *starImageView = [[UIImageView alloc]initWithImage:starImage];
    starImageView.frame = CGRectMake(10, 28, starImage.size.width, starImage.size.height);
    [self addSubview:starImageView];
    
    _collectionLabel = [[UILabel alloc]init];
    _collectionLabel.frame =CGRectMake(starImageView.bounds.size.width +5, 43, 80, 12);
    _collectionLabel.font = [UIFont systemFontOfSize:10];
    _collectionLabel.textColor = [UIColor whiteColor];
    _collectionLabel.text = [NSString stringWithFormat:@"今日%@人收藏",[_collectionArray firstObject]];
    [self addSubview:_collectionLabel];
    

    _titleLabel = [[UILabel alloc]init];
    _titleLabel.frame =CGRectMake(10, 62, 97, self.bounds.size.height - 62);
    _titleLabel.numberOfLines = 0;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:12];
    _titleLabel.text = [_titleArray firstObject];
    [self addSubview:_titleLabel];

    [self loadPage];

    
}




-(void)loadPage
{
    for (UIView *view in _mainScrollView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    _pageControl.currentPage = _currentIndex;
    _mainScrollView.contentOffset = CGPointMake(320, 0);
    UIImageView *curImageView = [[UIImageView alloc]init];
    curImageView.frame = CGRectMake(320, 0, self.bounds.size.width, self.bounds.size.height);
    [curImageView setImageWithURL:_imageURLArray[_currentIndex] placeholderImage:[UIImage imageNamed:@""]];
    [_mainScrollView addSubview:curImageView];
    //图片点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageClick:)];
    curImageView.userInteractionEnabled = YES;
    [curImageView addGestureRecognizer:tap];
    
    UIImageView *preImageView = [[UIImageView alloc]init];
    preImageView.frame = CGRectMake(0, 0, 320, self.bounds.size.height);
    int preIndex = _currentIndex - 1<0 ? _imageURLArray.count - 1:_currentIndex - 1;
    [preImageView setImageWithURL:_imageURLArray[preIndex] placeholderImage:[UIImage imageNamed:@""]];
    [_mainScrollView addSubview:preImageView];
    
    UIImageView *nextImageView = [[UIImageView alloc]init];
    nextImageView.frame = CGRectMake(640, 0, self.bounds.size.width, self.bounds.size.height);
    int nextIndex = _currentIndex + 1 >=_imageURLArray.count?0:_currentIndex +1;
    [nextImageView setImageWithURL:_imageURLArray[nextIndex] placeholderImage:[UIImage imageNamed:@""]];
    [_mainScrollView addSubview:nextImageView];
    
    _titleLabel.text = [_titleArray objectAtIndex:_currentIndex];
    _collectionLabel.text = [NSString stringWithFormat:@"今日%@人收藏",[_collectionArray objectAtIndex:_currentIndex]];

}

-(void)imageClick:(UITapGestureRecognizer *)tap
{
    NSLog(@"dianji");
    //imageUrlArray
    ShowPhotoViewController *svc = [[ShowPhotoViewController alloc]init];
    svc.idStr = _idStrs[_currentIndex];
    svc.uidStr = _uidStrs[_currentIndex];
    [_classObject.navigationController pushViewController:svc animated:YES];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"gundong");
    int index = scrollView.contentOffset.x/320;
    if (index>1) {
        _currentIndex = _currentIndex + 1>=_imageURLArray.count? 0 :_currentIndex + 1;
        [self loadPage];
    }
    else if(index < 1){
        _currentIndex = _currentIndex - 1<0?_imageURLArray.count-1:_currentIndex - 1;
        [self loadPage];
    }
    else
    {
        NSLog(@"没有滚动动作,没做任何操作");
    }
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSLog(@"gundong");
    int index = scrollView.contentOffset.x/320;
    if (index>1) {
        _currentIndex = _currentIndex + 1>=_imageURLArray.count? 0 :_currentIndex + 1;
        [self loadPage];
    }
    else if(index < 1){
        _currentIndex = _currentIndex - 1<0?_imageURLArray.count-1:_currentIndex - 1;
        [self loadPage];
    }
    else
    {
        NSLog(@"没有滚动动作,没做任何操作");
    }
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
