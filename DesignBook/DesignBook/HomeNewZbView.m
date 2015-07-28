
//
//  HomeNewZbView.m
//  DesignBook
//
//  Created by Visitor on 14-11-8.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import "HomeNewZbView.h"
#import "NewZbItem.h"

@implementation HomeNewZbView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)createHomeNewZbViewWithArray:(NSArray *)array
{
    NewZbItem *nzi = [array objectAtIndex:3];
    [self createBigImageView];
    [self createLabelWithNumber:nzi.zbNum];
}
-(void)createLabelWithNumber:(NSString *)number
{
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.frame = CGRectMake(10, 0, 150, 30);
    titleLabel.text = @"设计本担保交易";
    titleLabel.textColor = [UIColor darkGrayColor];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:titleLabel];
    
    UILabel *fontLabel = [[UILabel alloc]init];
    fontLabel = [[UILabel alloc]init];
    fontLabel.frame = CGRectMake(320-52, 15, 42, 10);
    fontLabel.text = @"人已发布";
    fontLabel.font = [UIFont systemFontOfSize:10];
    fontLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:fontLabel];
    
    UILabel *numPeoLabel = numPeoLabel = [[UILabel alloc]init];
    numPeoLabel.frame = CGRectMake(160, 15,160-52, 10);
    numPeoLabel.text = [NSString stringWithFormat:@"%@",number];
    numPeoLabel.font = [UIFont systemFontOfSize:10];
    numPeoLabel.textColor = [UIColor redColor];
    numPeoLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:numPeoLabel];
}
-(void)createBigImageView;
{
    UIButton *bigImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bigImageBtn.frame = CGRectMake(10, 30, 300, 115);
    [bigImageBtn setBackgroundImage:[UIImage imageNamed:@"ad2.png"] forState:UIControlStateNormal];
    
    [bigImageBtn addTarget:[UIApplication sharedApplication].delegate action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    bigImageBtn.tag = 5;
    [self addSubview:bigImageBtn];
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
