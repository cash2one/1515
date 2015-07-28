//
//  MyNavigationBar.m
//  LimiteDemo
//
//  Created by Visitor on 14-10-13.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import "MyNavigationBar.h"

@implementation MyNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)createMyNavigationBarWithBgImageName:(NSString *)bgImageName andTitle:(NSString *)title andLeftBtnImageName:(NSString *)leftBtnImageName  andLeftBtnTitle:(NSString *)leftBtnTitle andRightBtnImageName:(NSString *)rightBtnImageName andRightBtnTitle:(NSString *)rightBtnTitle andClass:(id)classObject andSEL:(SEL)sel
{
    [self createBgImageViewWithBgImageName:bgImageName];
    [self createTitleWithTitle:title];
    if (leftBtnImageName.length > 0) {
        [self createBtnWithBtnImageName:leftBtnImageName andBtnTitle:leftBtnTitle andIsLeft:YES andClass:classObject andSEL:sel];
    }
    if (rightBtnImageName.length > 0) {
        [self createBtnWithBtnImageName:rightBtnImageName andBtnTitle:rightBtnTitle andIsLeft:NO andClass:classObject andSEL:sel];
    }
}
-(void)createBgImageViewWithBgImageName:(NSString *)bgImageName
{
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:bgImageName]];
    imageView.frame = self.bounds;
    [self addSubview:imageView];
    
}

-(void)createBtnWithBtnImageName:(NSString *)btnImageName andBtnTitle:(NSString *)btnTitle andIsLeft:(BOOL)isLeft andClass:(id)classObject andSEL:(SEL)sel
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:btnImageName];
    
    btn.frame = isLeft?CGRectMake(10, (self.bounds.size.height - image.size.height)/2, image.size.width, image.size.height):CGRectMake(self.bounds.size.width - 10 - image.size.width, (self.bounds.size.height - image.size.height)/2, image.size.width, image.size.height);
    [btn setTitle:btnTitle forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    [btn addTarget:classObject action:sel forControlEvents:UIControlEventTouchUpInside];
    btn.tag = isLeft?1:2;
    [self addSubview:btn];
}

-(void)createTitleWithTitle:(NSString *)title
{
    UILabel *label = [[UILabel alloc]init];
    label.frame = self.bounds;
    label.text = title;
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
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
