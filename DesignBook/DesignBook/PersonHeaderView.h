//
//  PersonHeaderView.h
//  DesignBook
//
//  Created by Visitor on 14-11-11.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *focusLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansLabel;
@property (weak, nonatomic) IBOutlet UILabel *designLabel;
@property (weak, nonatomic) IBOutlet UILabel *signLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodLabel;
@property (weak, nonatomic) IBOutlet UILabel *longLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *yuyueLabel;
@property (weak, nonatomic) IBOutlet UIImageView *starImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *starImageView2;
@property (weak, nonatomic) IBOutlet UIButton *yuyueBtn;

@end
