//
//  AskItem.m
//  DesignBook
//
//  Created by Visitor on 14-11-7.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import "AskItem.h"

@implementation AskItem
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.uid = value;
    }
}
@end
