//
//  DesignCase.m
//  DesignBook
//
//  Created by Visitor on 14-11-11.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import "DesignCase.h"

@implementation DesignCase
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.uid = value;
    }
}
@end
