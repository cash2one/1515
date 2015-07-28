//
//  HomeBtnView.m
//  DesignBook
//
//  Created by Visitor on 14-11-7.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import "HomeBtnView.h"
#import "AppDelegate.h"
#import "MyButton.h"
@implementation HomeBtnView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)createBtnViewWithClass:(id)classObject andSEL :(SEL)sel
{
    for (int i = 0; i<4; i++) {
        MyButton *btn = [MyButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((self.bounds.size.width-75*4)/5 + (75 +(self.bounds.size.width-75*4)/5)*i, 0, 75, 75);
        NSString *string = [NSString stringWithFormat:@"btn_%.2d",i+7];
        NSLog(@"%@",string);
        [btn setImage:[UIImage imageNamed:string] forState:UIControlStateNormal];
        [btn addTarget:classObject action:sel forControlEvents:UIControlEventTouchUpInside];
       
        if (i==0) {
            btn.tag = 8;
        }
        if (i==1) {
            btn.tag = 7;
            btn.enterType = 0;
        }
        if (i==2) {
            btn.tag = 5;
        }
        if (i==3) {
            btn.tag = 7;
            btn.enterType = 2;
        }
        [self addSubview:btn];
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
