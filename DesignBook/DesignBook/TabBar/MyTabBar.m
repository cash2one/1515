//
//  MyTabBar.m
//  LimiteDemo
//
//  Created by Visitor on 14-10-13.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import "MyTabBar.h"

@implementation MyTabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
+(MyTabBar *)sharedMyTabBar
{
    static MyTabBar *_myTabBar;
    if (!_myTabBar) {
        _myTabBar = [[MyTabBar alloc]init];
    }
    return _myTabBar;
}
- (void)createMyTabBarWithBgImageName:(NSString *)bgImageName andViewControllerPlistName:(NSString *)plistName andClass:(id)classObject andSEL:(SEL)sel
{
    //1背景图
    [self createBgImageViewWithImageName:bgImageName];
    //2 读取plist文件
    NSArray *plistArray = [self loadPlistDataWithPlistName:plistName];
    //3创建item
    int n = 0;
    for (NSDictionary *itemDict in plistArray) {
        
        [self createItemWithItemDict:itemDict andClass:classObject andSEL:sel andIndex:n andCount:plistArray.count];
    n++;
    }
    
}
-(void)createItemWithItemDict:(NSDictionary *)itemDict andClass:(id)classObject andSEL:(SEL)sel andIndex:(int)index andCount:(int)count
{
    UIView *baseView = [[UIView alloc]initWithFrame:CGRectMake(self.bounds.size.width/count * index, 0, self.bounds.size.width/count, self.bounds.size.height)];
    [self addSubview:baseView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, baseView.bounds.size.width, baseView.bounds.size.height);
    [btn setImage:[[UIImage imageNamed:[itemDict objectForKey:@"image"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  forState:UIControlStateNormal];
    [btn setImage:[[UIImage imageNamed:[itemDict objectForKey:@"selectimage"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];

    if (index == 2) {
        btn.selected = YES;
    }
    [btn addTarget:classObject action:sel forControlEvents:UIControlEventTouchUpInside];
    btn.tag = index;
    [baseView addSubview:btn];
    
}
-(void)createBgImageViewWithImageName:(NSString *)imageName
{
    UIImageView *imageView= [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    imageView.frame  = self.bounds;
    [self addSubview:imageView];
}

-(NSArray *)loadPlistDataWithPlistName:(NSString *)plistName
{
    NSString *path = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath],plistName ];
    NSArray *plistArray = [[NSArray alloc] initWithContentsOfFile:path];
    return plistArray;
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
