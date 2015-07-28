//
//  PublicSubViewController.h
//  DesignBook
//
//  Created by Visitor on 14-11-9.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublicSubViewController : UIViewController
@property(nonatomic,strong)NSString *subTitle;
@property(nonatomic,assign)NSString *sourceType;
@property(nonatomic,strong)void (^returnStrBlock)(NSString *);
@end
