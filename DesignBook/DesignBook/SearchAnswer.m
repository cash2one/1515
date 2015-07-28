//
//  SearchAnswer.m
//  DesignBook
//
//  Created by Visitor on 14-11-14.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import "SearchAnswer.h"

@implementation SearchAnswer
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.aid = value;
    }
}
@end
