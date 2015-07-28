//
//  MyNavigationBar.h
//  LimiteDemo
//
//  Created by Visitor on 14-10-13.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyNavigationBar : UIView
-(void)createMyNavigationBarWithBgImageName:(NSString *)bgImageName andTitle:(NSString *)title andLeftBtnImageName:(NSString *)leftBtnImageName  andLeftBtnTitle:(NSString *)leftBtnTitle andRightBtnImageName:(NSString *)rightBtnImageName andRightBtnTitle:(NSString *)rightBtnTitle andClass:(id)classObject andSEL:(SEL)sel;
@end
