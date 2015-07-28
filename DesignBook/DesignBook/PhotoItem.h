//
//  PhotoItem.h
//  DesignBook
//
//  Created by Visitor on 14-11-9.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoItem : NSObject
@property(nonatomic,strong)NSMutableArray *data;
@property(nonatomic,strong)NSNumber *rank;
@property(nonatomic,strong)NSNumber *totalnum;
@property(nonatomic,strong)NSString *userId;
@end
