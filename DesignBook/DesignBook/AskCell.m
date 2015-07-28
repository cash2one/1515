//
//  AskCell.m
//  DesignBook
//
//  Created by Visitor on 14-11-13.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import "AskCell.h"
#import "UIImageView+WebCache.h"

@implementation AskCell
{
    UIImageView *_picImageView;
    
    UILabel *_askTitleLabel;
    
    UIImageView *_timeImageView;
    UILabel *_timeLabel;
    
    UIImageView *_eyeImageView;
    UILabel *_eyeLabel;
    
    UIImageView *_commentImageView;
    UILabel *_commentLabel;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
-(void)createUI
{
    _baseView = [[UIView alloc]init];
    _baseView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_baseView];
    
    _picImageView = [[UIImageView alloc]init];
    [_baseView addSubview:_picImageView];
    
    _askTitleLabel = [[UILabel alloc]init];
    _askTitleLabel.font = [UIFont systemFontOfSize:13];
    _askTitleLabel.textColor = [UIColor darkGrayColor];
    _askTitleLabel.numberOfLines = 0;
    
    [_baseView addSubview:_askTitleLabel];
    
    _timeImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ask_icon1.png"]];
    [_baseView addSubview:_timeImageView];
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.textColor = [UIColor lightGrayColor];
    _timeLabel.font = [UIFont systemFontOfSize:10];
    [_baseView addSubview:_timeLabel];
    
    _eyeImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ask_icon3.png"]];
    [_baseView addSubview:_eyeImageView];
    _eyeLabel = [[UILabel alloc]init];
    _eyeLabel.textColor = [UIColor lightGrayColor];
    _eyeLabel.font = [UIFont systemFontOfSize:10];
    [_baseView addSubview:_eyeLabel];
    
    _commentImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ask_icon2.png"]];
    [_baseView addSubview:_commentImageView];
    _commentLabel = [[UILabel alloc]init];
    _commentLabel.font = [UIFont systemFontOfSize:10];
    _commentLabel.textColor = [UIColor lightGrayColor];
    [_baseView addSubview:_commentLabel];
}
-(void)setFrameWithAskAnswerItem:(AskAnswer *)as
{
    //baseView 高 110; 宽 310
    if (as.pic.length>0) {
        _picImageView.frame = CGRectMake(10, 10, 100, 85);
        [_picImageView setImageWithURL:[NSURL URLWithString:as.pic]];
        
        CGSize titleSize = [as.title sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(375/2, 140) lineBreakMode:NSLineBreakByCharWrapping];
        _askTitleLabel.frame = CGRectMake(115, 10, titleSize.width,titleSize.height);
        _askTitleLabel.text = as.title;
        
        _timeImageView.frame = CGRectMake(115, 84, 17, 17);
        _timeLabel.frame = CGRectMake(115+18, 84, 50, 17);
        _timeLabel.text = as.time_span;
        
        _eyeImageView.frame = CGRectMake(210, 84, 17, 17);
        _eyeLabel.frame = CGRectMake(210+18, 84, 30, 17);
        _eyeLabel.text = as.view_nums;
        
        _commentImageView.frame = CGRectMake(260, 84, 17, 17);
        _commentLabel.frame = CGRectMake(260+18, 84, 25, 17);
        _commentLabel.text = as.comment_nums;
        
        _baseView.frame = CGRectMake(5, 5, 310, 110);
        
    }
    else{
        
        CGSize titleSize = [as.title sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(300, 35) lineBreakMode:NSLineBreakByCharWrapping];
        _askTitleLabel.frame = CGRectMake(5, 10, titleSize.width,titleSize.height);
        _askTitleLabel.text = as.title;
        
        
        _timeImageView.frame = CGRectMake(5, CGRectGetMaxY(_askTitleLabel.frame)+5, 17, 17);
        _timeLabel.frame = CGRectMake(5+18, CGRectGetMaxY(_askTitleLabel.frame)+5, 50, 17);
        _timeLabel.text = as.time_span;
        
        _eyeImageView.frame = CGRectMake(210, CGRectGetMaxY(_askTitleLabel.frame)+5, 17, 17);
        _eyeLabel.frame = CGRectMake(210+18, CGRectGetMaxY(_askTitleLabel.frame)+5, 30, 17);
        _eyeLabel.text = as.view_nums;
        
        _commentImageView.frame = CGRectMake(260, CGRectGetMaxY(_askTitleLabel.frame)+5, 17, 17);
        _commentLabel.frame = CGRectMake(260+18, CGRectGetMaxY(_askTitleLabel.frame)+5, 25, 17);
        _commentLabel.text = as.comment_nums;
        
        _baseView.frame = CGRectMake(5, 5, 310, CGRectGetMaxY(_timeLabel.frame)+10);
    }

}

-(void)setFrameWithAskSearchAnswer:(SearchAnswer *)sa
{
    //baseView 高 110; 宽 310
    if (sa.pic.length>0) {
        _picImageView.frame = CGRectMake(10, 10, 100, 85);
        [_picImageView setImageWithURL:[NSURL URLWithString:sa.pic]];
        
        CGSize titleSize = [sa.title sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(375/2, 140) lineBreakMode:NSLineBreakByCharWrapping];
        _askTitleLabel.frame = CGRectMake(115, 10, titleSize.width,titleSize.height);
        _askTitleLabel.text = sa.title;
        
        _timeImageView.frame = CGRectMake(115, 84, 17, 17);
        _timeLabel.frame = CGRectMake(115+18, 84, 50, 17);
        _timeLabel.text = sa.time_span;
        
        _eyeImageView.frame = CGRectMake(210, 84, 17, 17);
        _eyeLabel.frame = CGRectMake(210+18, 84, 30, 17);
        _eyeLabel.text = sa.view_nums;
        
        _commentImageView.frame = CGRectMake(260, 84, 17, 17);
        _commentLabel.frame = CGRectMake(260+18, 84, 25, 17);
        _commentLabel.text = sa.comment_nums.stringValue;
        
        _baseView.frame = CGRectMake(5, 5, 310, 110);
        
    }
    else{
        
        CGSize titleSize = [sa.title sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(300, 35) lineBreakMode:NSLineBreakByCharWrapping];
        _askTitleLabel.frame = CGRectMake(5, 10, titleSize.width,titleSize.height);
        _askTitleLabel.text = sa.title;
        
        
        _timeImageView.frame = CGRectMake(5, CGRectGetMaxY(_askTitleLabel.frame)+5, 17, 17);
        _timeLabel.frame = CGRectMake(5+18, CGRectGetMaxY(_askTitleLabel.frame)+5, 50, 17);
        _timeLabel.text = sa.time_span;
        
        _eyeImageView.frame = CGRectMake(210, CGRectGetMaxY(_askTitleLabel.frame)+5, 17, 17);
        _eyeLabel.frame = CGRectMake(210+18, CGRectGetMaxY(_askTitleLabel.frame)+5, 30, 17);
        _eyeLabel.text = sa.view_nums;
        
        _commentImageView.frame = CGRectMake(260, CGRectGetMaxY(_askTitleLabel.frame)+5, 17, 17);
        _commentLabel.frame = CGRectMake(260+18, CGRectGetMaxY(_askTitleLabel.frame)+5, 25, 17);
        _commentLabel.text = [NSString stringWithFormat:@"%@",sa.comment_nums];
        
        _baseView.frame = CGRectMake(5, 5, 310, CGRectGetMaxY(_timeLabel.frame)+10);
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
