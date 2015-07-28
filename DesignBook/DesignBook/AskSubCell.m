//
//  AskSubCell.m
//  DesignBook
//
//  Created by Visitor on 14-11-13.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import "AskSubCell.h"
#import "UIImageView+WebCache.h"
#import "AskSubViewController.h"
#import "PersonDetailViewController.h"
@implementation AskSubCell
{
    UIImageView *_headImageView;
    UILabel *_nameLabel;
    UILabel *_timeLabel;
    UILabel *_contentLabel;
    UIImageView *_goodImageView;
    UILabel *_goodLabel;
    UIImageView *_commentImageView;
    
    UIButton *_nameBtn1;
    UIButton *_nameBtn2;
    Answer *_as;
    AskSubViewController *_classObjcet;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self createUI];
    }
    return self;
}
-(void)createUI
{
    _baseView = [[UIView alloc]init];
    _baseView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_baseView];
    
    _headImageView = [[UIImageView alloc]init];
    _headImageView.userInteractionEnabled = YES;
    [_baseView addSubview:_headImageView];
    _headImageView.tag = 1;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [_headImageView addGestureRecognizer:tap];
    
    
    _nameBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    _nameBtn1.titleLabel.font = [UIFont systemFontOfSize:14];
    _nameBtn1.tag = 1;
    [_nameBtn1 setTitleColor:[UIColor colorWithRed:0.38f green:0.69f blue:0.91f alpha:1.00f] forState:UIControlStateNormal];
    [_nameBtn1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_baseView addSubview:_nameBtn1];

    _timeLabel = [[UILabel alloc]init];
    _timeLabel.font = [UIFont systemFontOfSize:10];
    _timeLabel.textColor = [UIColor lightGrayColor];
    [_baseView addSubview:_timeLabel];
    
    _contentLabel = [[UILabel alloc]init];
    _contentLabel.font = [UIFont systemFontOfSize:14];
    _contentLabel.textColor = [UIColor lightGrayColor];
    _contentLabel.numberOfLines = 0;
    [_baseView addSubview:_contentLabel];
    
    _goodImageView = [[UIImageView alloc]init];
    _goodImageView.image = [UIImage imageNamed:@"ask_icon8.png"];
    [_baseView addSubview:_goodImageView];
    _goodLabel = [[UILabel alloc]init];
    _goodLabel.textColor = [UIColor whiteColor];
    _goodLabel.font = [UIFont systemFontOfSize:10];
    _goodLabel.textAlignment = NSTextAlignmentCenter;
    [_baseView addSubview:_goodLabel];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    _goodImageView.userInteractionEnabled = YES;
    _goodImageView.tag = 2;
    [_goodImageView addGestureRecognizer:tap2];
    
    
    _commentImageView = [[UIImageView alloc]init];
    _commentImageView.image = [UIImage imageNamed:@"ask_icon7.png"];
    [_baseView addSubview:_commentImageView];
}
-(void)setFrameWith:(Answer *)as andClass:(id)classObjcet
{
    _as = as;
    _classObjcet = classObjcet;
    
    _headImageView.frame = CGRectMake(5, 5, 35, 35);
    [_headImageView setImageWithURL:[NSURL URLWithString:as.head_photo]];

    CGSize nameSize = [as.nick sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(CGFLOAT_MAX, 14) lineBreakMode:NSLineBreakByCharWrapping];
    [_nameBtn1 setTitle:as.nick forState:UIControlStateNormal];
    _nameBtn1.frame = CGRectMake(50, 5, nameSize.width, nameSize.height);
    
    if (as.msgto.username.length>0) {
        
        CGSize ns = [as.msgto.username sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(CGFLOAT_MAX, 14) lineBreakMode:NSLineBreakByCharWrapping];
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(CGRectGetMaxX(_nameBtn1.frame), 5, 42, 14);
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor lightGrayColor];
        label.text = @"回复了";
        [_baseView addSubview:label];
        
        _nameBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        _nameBtn2.titleLabel.font = [UIFont systemFontOfSize:14];
        [_nameBtn2 setTitleColor:[UIColor colorWithRed:0.38f green:0.69f blue:0.91f alpha:1.00f] forState:UIControlStateNormal];
        [_nameBtn2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _nameBtn2.tag = 2;
        _nameBtn2.frame = CGRectMake(CGRectGetMaxX(label.frame), 5, ns.width, ns.height);
        [_nameBtn2 setTitle:as.msgto.username forState:UIControlStateNormal];
        [_baseView addSubview:_nameBtn2];
    }
  
    _timeLabel.frame = CGRectMake(50, 28, 100, 10);
    _timeLabel.text = as.createtime;
    
    CGSize titleSize = [as.content sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(280, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    _contentLabel.frame = CGRectMake(6, 50, titleSize.width, titleSize.height);
    _contentLabel.text = as.content;
    
    _goodImageView.frame = CGRectMake(230, 5+CGRectGetMaxY(_contentLabel.frame), 40, 20);
    _goodLabel.frame = CGRectMake(245, 5+CGRectGetMaxY(_contentLabel.frame), 25, 20);
    _goodLabel.text = as.praise_num;
    
    _commentImageView.frame = CGRectMake(277, 5+CGRectGetMaxY(_contentLabel.frame), 20, 20);
    
    _baseView.frame = CGRectMake(5, 5, 310, CGRectGetMaxY(_commentImageView.frame)+10);
    
}
-(void)btnClick:(UIButton *)btn
{
    if (btn.tag == 1) {
        PersonDetailViewController *pdvc = [[PersonDetailViewController alloc]init];
        pdvc.uid = _as.answer_uid;
        pdvc.nick = _as.nick;
        [_classObjcet.navigationController pushViewController:pdvc animated:YES];
    }
    else
    {
        PersonDetailViewController *pdvc = [[PersonDetailViewController alloc]init];
        pdvc.uid = _as.msgto.uid;
        pdvc.nick = _as.msgto.username;
        [_classObjcet.navigationController pushViewController:pdvc animated:YES];
    }
}
-(void)tapAction:(UITapGestureRecognizer *)tap
{
    if (tap.view.tag == 1) {
        PersonDetailViewController *pdvc = [[PersonDetailViewController alloc]init];
        pdvc.uid = _as.answer_uid;
        pdvc.nick = _as.nick;
        [_classObjcet.navigationController pushViewController:pdvc animated:YES];
    }
    else{
        if ([_as.indentity isEqualToString:@"1"]) {
            //更改模型里的 indentity 1->0
            //和模型里的 _as.praise_num +1;
            _as.indentity = @"0";
            _as.praise_num = [NSString stringWithFormat:@"%d",_as.praise_num.intValue+1];
            _goodLabel.text = _as.praise_num;
        }
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
