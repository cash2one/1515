//
//  RankBtnView.m
//  DesignBook
//
//  Created by Visitor on 14-11-8.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import "RankBtnView.h"

@implementation RankBtnView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.93f alpha:1.00f];
    }
    return self;
}
-(void)createRankBtnViewWithClass:(id)classObject andSEL:(SEL)sel
{
    CGFloat marginX = (self.bounds.size.width - 2*150)/3;
    CGFloat marginY = (self.bounds.size.height - 3*73)/4;
    
    for (int i = 0 ; i<6; i++) {
        int x = i%2;
        int y = i/2;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(marginX + (150 +marginX)*x, marginY + (marginY + 73)*y, 150, 73);
        NSString *nameStr = [NSString stringWithFormat:@"rank_btn%d.png",i+1];
        [btn setImage:[UIImage imageNamed:nameStr] forState:UIControlStateNormal];
        [btn addTarget:classObject action:sel forControlEvents:UIControlEventTouchUpInside];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [self addSubview:btn];
    }
}
-(void)btnClick:(UIButton *)btn
{
    NSLog(@"rankBtnClick = %d",btn.tag);
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
