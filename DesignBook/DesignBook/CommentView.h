//
//  CommentView.h
//  DesignBook
//
//  Created by Visitor on 14-11-12.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentView : UIView
@property (weak, nonatomic) IBOutlet UILabel *koubeiLabel;
@property (weak, nonatomic) IBOutlet UILabel *haopingLabel;
@property (weak, nonatomic) IBOutlet UILabel *numhaopingLabel;
@property (weak, nonatomic) IBOutlet UILabel *chapingLabel;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@end
