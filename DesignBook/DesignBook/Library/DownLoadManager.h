//
//  DownLoadManager.h
//  CarDemo
//
//  Created by Visitor on 14-11-5.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownLoad.h"

@interface DownLoadManager : NSObject<DownLoadDelegate>

+(DownLoadManager *)sharedDownLoadManager;
-(void)addDownLoadWithDownStr:(NSString *)downLoadString andDownLoadType:(int)downLoadType andIsRefresh:(BOOL)isRefresh andDownLoadPage:(int)downLoadPage;
-(NSMutableArray *)getDataWithDownLoadString:(NSString *)downLoadString;

@end
