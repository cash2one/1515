//
//  MyHeaderView.m
//  DesignBook
//
//  Created by Visitor on 14-11-9.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import "MyHeaderView.h"

@implementation MyHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)createMyHeaderViewWithNameArray:(NSArray *)nameArray andClass:(id)classObject andSEL:(SEL)sel andSelectIndex:(int)index
{
    for (int i = 0; i<nameArray.count; i++) {
        [self createBtnWithClass:classObject andSEL:sel andIndex:i andCount:nameArray.count andTitle:nameArray[i] andIndex:index];
    }
}

-(void)createBtnWithClass:(id)classObject andSEL:(SEL)sel andIndex:(int)index andCount:(int)count andTitle:(NSString *)title andIndex:(int)dex
{
    CGFloat width = self.bounds.size.width/count;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(width*index, 0, width, 45);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    [btn addTarget:classObject action:sel forControlEvents:UIControlEventTouchUpInside];
    btn.tag = index;
    [self addSubview:btn];
    if (index != 0) {
        UIView *lineView = [[UIView alloc]init];
        lineView.frame = CGRectMake(width*index, 11, 1, 45-22);
        lineView.backgroundColor = [UIColor lightGrayColor];
        lineView.alpha = 0.5;
        [self addSubview:lineView];
    }
    if (dex == index) {
        btn.selected = YES;
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
