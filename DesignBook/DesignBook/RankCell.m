//
//  RankCell.m
//  DesignBook
//
//  Created by Visitor on 14-11-13.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import "RankCell.h"
#import "RankViewController.h"
#import "UIImageView+WebCache.h"
@implementation RankCell
{
    UIView *_baseView;
    
    UIImageView *_rankBgImageView;
    UIImageView *_headImageView;
    UILabel *_tLabel;
    UILabel *_subLabel;
    UIImageView *_arrowImageView;
    
    RankViewController *_classObject;
    RankList *_rankL;
    
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        [self createUI];
    }
    return self;
}
-(void)createUI
{
    _baseView = [[UIView alloc]init];
    _baseView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_baseView];
    
    _rankBgImageView = [[UIImageView alloc]init];
    [_baseView addSubview:_rankBgImageView];
    
    _headImageView = [[UIImageView alloc]init];
    [_baseView addSubview:_headImageView];
    
    _tLabel = [[UILabel alloc]init];
    _tLabel.font = [UIFont systemFontOfSize:14];
    _tLabel.textColor = [UIColor darkGrayColor];
    [_baseView addSubview:_tLabel];
    
    _subLabel = [[UILabel alloc]init];
    _subLabel.font = [UIFont systemFontOfSize:10];
    _subLabel.textColor = [UIColor lightGrayColor];
    [_baseView addSubview:_subLabel];
    
    _arrowImageView = [[UIImageView alloc]init];
    [_baseView addSubview:_arrowImageView];
}
-(void)setFrameWithRankList:(RankList *)rl andClass:(id)classObjcet
{
    _baseView.frame = CGRectMake(5, 5, 310, 65);
    //27 × 21
    _rankBgImageView.frame = CGRectMake(0, 22, 27, 21);
    _headImageView.frame = CGRectMake(38, 12, 35, 35);
    [_headImageView setImageWithURL:[NSURL URLWithString:rl.headphoto] placeholderImage:[UIImage imageNamed:@""]];
    _tLabel.frame = CGRectMake(82, 12, 150, 15);
    _tLabel.text = rl.nick;

    _subLabel.frame = CGRectMake(82, 37, 150, 10);
    _subLabel.text = [NSString stringWithFormat:@"回答了%@个问题",rl.num];
    
    //36 × 43
    _arrowImageView.frame = CGRectMake(310-36, 65-42, 36, 43);
    
    if ([rl.rank.stringValue isEqual:@"1"]) {
        _rankBgImageView.image = [UIImage imageNamed:@"rank_number_bg.png"];
        UIImageView *numImageView = [[UIImageView alloc]init];
        numImageView.frame = CGRectMake(17/2, 25, 10, 15);
        numImageView.image = [UIImage imageNamed:@"rank_no_1.png"];
        _arrowImageView.image = [UIImage imageNamed:@"rank_arrow1.png"];
        [_baseView addSubview:numImageView];
    }
    else
    {
        if (rl.rankValue.intValue > 0) {
             _arrowImageView.image = [UIImage imageNamed:@"rank_arrow2.png"];
        }
        else
        {
             _arrowImageView.image = [UIImage imageNamed:@"rank_arrow3.png"];
        }
       
        _rankBgImageView.image = [UIImage imageNamed:@"rank_number_bg1.png"];
        if (rl.rank.intValue <=9) {
            UIImageView *numImageView = [[UIImageView alloc]init];
            numImageView.frame = CGRectMake(17/2, 25, 10, 15);
            numImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"rank_no_%d.png",rl.rank.intValue]];
            [_baseView addSubview:numImageView];
        }
        else if (rl.rank.intValue <=99)
        {
            int x = rl.rank.intValue/10;
            int y = rl.rank.intValue%10;
            
            UIImageView *numImageView1 = [[UIImageView alloc]init];
            numImageView1.frame = CGRectMake(2, 25, 10, 15);
            numImageView1.image = [UIImage imageNamed:[NSString stringWithFormat:@"rank_no_%d.png",x]];
            [_baseView addSubview:numImageView1];
            
            UIImageView *numImageView2 = [[UIImageView alloc]init];
            numImageView2.frame = CGRectMake(12, 25, 10, 15);
            numImageView2.image = [UIImage imageNamed:[NSString stringWithFormat:@"rank_no_%d.png",y]];
            [_baseView addSubview:numImageView2];
        }
    }

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
