
//
//  SearchPhoto.m
//  DesignBook
//
//  Created by Visitor on 14-11-14.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import "SearchPhoto.h"

@implementation SearchPhoto
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.uid = value;
    }
}
@end
