//
//  FamousSjsItem.h
//  DesignBook
//
//  Created by Visitor on 14-11-7.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BigItem.h"

@interface FamousSjsItem : NSObject
@property(nonatomic,strong)BigItem *big;
@property(nonatomic,strong)NSString *famousSjsNum;
@property(nonatomic,strong)NSMutableArray *sjs;
@end
