//
//  PersonResult.h
//  DesignBook
//
//  Created by Visitor on 14-11-11.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersonInfo.h"
@interface PersonResult : NSObject
@property(nonatomic,strong)NSString *data;
@property(nonatomic,strong)NSNumber *follow;
@property(nonatomic,strong)PersonInfo *info;
@end
