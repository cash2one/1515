//
//  MyTabBar.h
//  LimiteDemo
//
//  Created by Visitor on 14-10-13.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTabBar : UIView
+(MyTabBar *)sharedMyTabBar;
- (void)createMyTabBarWithBgImageName:(NSString *)bgImageName andViewControllerPlistName:(NSString *)plistName andClass:(id)classObject andSEL:(SEL)sel;
@end
