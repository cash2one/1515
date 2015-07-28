//
//  MineIconView.m
//  DesignBook
//
//  Created by Visitor on 14-11-8.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import "MineIconView.h"

@implementation MineIconView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor  = [UIColor colorWithRed:0.94f green:0.94f blue:0.93f alpha:1.00f];
    }
    return self;
}
-(void)createMineIconView
{
    CGFloat marginX = (self.bounds.size.width - 4*74)/7;
    CGFloat marginY = (self.bounds.size.height - 3*74)/6;
    
    for (int i = 0 ; i<12; i++) {
        int x = i%4;
        int y = i/4;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(marginX*2 + (74 +marginX)*x, marginY*2 + (marginY + 74)*y, 74, 74);
        NSString *nameStr = [NSString stringWithFormat:@"my_btn%d.png",i+1];
        [btn setImage:[UIImage imageNamed:nameStr] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [self addSubview:btn];
    }
}
-(void)btnClick:(UIButton *)btn
{
    

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
