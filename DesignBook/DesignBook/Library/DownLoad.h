//
//  DownLoad.h
//  CarDemo
//
//  Created by Visitor on 14-11-5.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DownLoad;
@protocol DownLoadDelegate <NSObject>

-(void)downLoadFinishWithClass:(DownLoad *)dl;

@end

@interface DownLoad : NSObject<NSURLConnectionDataDelegate>

@property(nonatomic,strong)NSString *downLoadString;
@property(nonatomic,assign)int downLoadType;
@property(nonatomic,assign)BOOL downLoadIsRefresh;
@property(nonatomic,assign)int downLoadPage;
@property(nonatomic,strong)NSMutableData *downLoadData;
@property(nonatomic,weak)__weak id<DownLoadDelegate> delegate;

-(void)downLoad;
@end
