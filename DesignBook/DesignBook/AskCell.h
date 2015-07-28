//
//  AskCell.h
//  DesignBook
//
//  Created by Visitor on 14-11-13.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AskAnswer.h"
#import "SearchAnswer.h"
@interface AskCell : UITableViewCell
@property(nonatomic,strong)UIView *baseView;
-(void)setFrameWithAskAnswerItem:(AskAnswer *)as;
-(void)setFrameWithAskSearchAnswer:(SearchAnswer *)sa;
-(void)createUI;
@end
