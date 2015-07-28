//
//  HomeAskView.m
//  DesignBook
//
//  Created by Visitor on 14-11-8.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import "HomeAskView.h"
#import "AskModuleItem.h"
#import "AskItem.h"
#import "UIImageView+WebCache.h"
#import "HomeViewController.h"
#import "AppDelegate.h"
#import "AskSubViewController.h"
@implementation HomeAskView
{
    HomeViewController *_classObjcet;
    NSArray *_askArray;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //310 height
    }
    return self;
}
-(void)createAskViewWithArray:(NSArray *)array andClass:(id)classObject;
{
    _classObjcet = classObject;
    
    AskModuleItem *ami = [array objectAtIndex:0];
    _askArray = ami.ask;
    
    
    [self createLabelWithNumber:ami.askNum];
    [self createBigImageView];

    for (int i =0; i<2; i++) {
        UIView *bgView = [[UIView alloc]init];
        bgView .frame = CGRectMake(10, 150 + (5+70)*i, 300, 70);
        bgView.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
       [bgView addSubview:[self createAskCellWithAskItem:[ami.ask objectAtIndex:i] withTag:i+1]];
        [self addSubview:bgView];
    }
}
-(void)createLabelWithNumber:(NSString *)number
{
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.frame = CGRectMake(10, 0, 150, 30);
    titleLabel.text = @"有问必答";
    titleLabel.textColor = [UIColor darkGrayColor];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:titleLabel];
    
    UILabel *fontLabel = [[UILabel alloc]init];
    fontLabel = [[UILabel alloc]init];
    fontLabel.frame = CGRectMake(320-42, 15, 32, 10);
    fontLabel.text = @"个问题";
    fontLabel.font = [UIFont systemFontOfSize:10];
    fontLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:fontLabel];
    
    UILabel *numberLabel = [[UILabel alloc]init];
    CGSize numberSize = [number sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(CGFLOAT_MAX, 10) lineBreakMode:NSLineBreakByCharWrapping];
    numberLabel.frame = CGRectMake(320-42 - numberSize.width, 15, numberSize.width, 10);
    numberLabel.font = [UIFont systemFontOfSize:10];
    numberLabel.text = [NSString stringWithFormat:@"%@",number];
    numberLabel.textColor = [UIColor redColor];
    [self addSubview:numberLabel];

    UILabel *prefixLabel = [[UILabel alloc]init];
    prefixLabel.frame = CGRectMake(160, 15, 320-42-numberSize.width-32, 10);
    prefixLabel.text = @"已解决";
    prefixLabel.font = [UIFont systemFontOfSize:10];
    prefixLabel.textColor = [UIColor darkGrayColor];
    prefixLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:prefixLabel];
    
}
-(void)createBigImageView;
{
    UIButton *bigImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bigImageBtn.frame = CGRectMake(10, 30, 300, 115);
    [bigImageBtn setBackgroundImage:[UIImage imageNamed:@"ad1.png"] forState:UIControlStateNormal];
    
    [bigImageBtn addTarget:[UIApplication sharedApplication].delegate action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    bigImageBtn.tag = 6;
    [self addSubview:bigImageBtn];
}
-(UIButton *)createAskCellWithAskItem:(AskItem *)item withTag:(int)btnTag;
{
    UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
    view.frame = CGRectMake(1, 1, 300-2, 70-2);
    view.tag = btnTag;
    
    [view addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *headImageView = [[UIImageView alloc]init];
    headImageView.frame = CGRectMake(5, 7, 75, 68-14);
    [headImageView setImageWithURL:[NSURL URLWithString:item.image_src] placeholderImage:[UIImage imageNamed:@""]];
    [view addSubview:headImageView];
    
    UILabel *askLabel = [[UILabel alloc]init];
    askLabel.frame = CGRectMake(90, 5, 22, 20);
    askLabel.text = @"问:";
    askLabel.textColor = [UIColor redColor];
    askLabel.font = [UIFont systemFontOfSize:14];
    [view addSubview:askLabel];
    
    UILabel *textLB = [[UILabel alloc]init];
    NSString *textStr = [NSString stringWithFormat:@"  %@..",item.title];
    CGSize titleSize = [textStr sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(182, 40) lineBreakMode:NSLineBreakByCharWrapping];
    textLB.frame = CGRectMake(100, 7, titleSize.width, titleSize.height);
    textLB.numberOfLines = 0;
    textLB.text = textStr;
    textLB.font = [UIFont systemFontOfSize:14];
    textLB.textColor = [UIColor darkGrayColor];
    [view addSubview:textLB];
    
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.frame = CGRectMake(90, 48, 60, 12);
    timeLabel.font = [UIFont systemFontOfSize:10];
    timeLabel.textColor = [UIColor lightGrayColor];
    timeLabel.text = item.last_acttime;
    [view addSubview:timeLabel];
    
    UIImageView *eyeImageView = [[UIImageView alloc]init];
    UIImage *eyeImage = [UIImage imageNamed:@"icon_15.png"];
    eyeImageView.frame = CGRectMake(190, 47, eyeImage.size.width, eyeImage.size.height);
    eyeImageView.image = eyeImage;
    [view addSubview:eyeImageView];
    
    UILabel *eyeLabel = [[UILabel alloc]init];
    NSString *eyeString = [NSString stringWithFormat:@"%@次",item.view_nums];
    eyeLabel.frame = CGRectMake(CGRectGetMaxX(eyeImageView.frame), 48, 40, 12);
    eyeLabel.text = eyeString;
    eyeLabel.font = [UIFont systemFontOfSize:10];
    eyeLabel.textColor = [UIColor lightGrayColor];
    [view addSubview:eyeLabel];
    
    UIImageView *commentImageView = [[UIImageView alloc]init];
    UIImage *commentImage = [UIImage imageNamed:@"icon_16.png"];
    commentImageView.frame = CGRectMake(CGRectGetMaxX(eyeLabel.frame), 47, commentImage.size.width, commentImage.size.height);
    commentImageView.image = commentImage;
    [view addSubview:commentImageView];
    
    UILabel *commentLabel = [[UILabel alloc]init];
    commentLabel.frame = CGRectMake(CGRectGetMaxX(commentImageView.frame), 48, 30, 12);
    commentLabel.font = [UIFont systemFontOfSize:10];
    commentLabel.textColor = [UIColor lightGrayColor];
    commentLabel.text = [NSString stringWithFormat:@"%@条",item.comment_nums];
    [view addSubview:commentLabel];
    
    return view;
}
-(void)btnClick:(UIButton *)btn
{
    if(btn.tag == 1)
    {
        AskSubViewController *asvc = [[AskSubViewController alloc]init];
        AskItem *ai = [_askArray objectAtIndex:0];
        asvc.idStr = ai.uid;
        [_classObjcet.navigationController pushViewController:asvc animated:YES];
    }
    else if(btn.tag == 2)
    {
        AskSubViewController *asvc = [[AskSubViewController alloc]init];
        AskItem *ai = [_askArray objectAtIndex:1];
        asvc.idStr = ai.uid;
        [_classObjcet.navigationController pushViewController:asvc animated:YES];
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
