//
//  AskSubCell.h
//  DesignBook
//
//  Created by Visitor on 14-11-13.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Answer.h"

@interface AskSubCell : UITableViewCell
@property(nonatomic,strong)UIView *baseView;
-(void)createUI;
-(void)setFrameWith:(Answer *)as andClass:(id)classObjcet;
@end
