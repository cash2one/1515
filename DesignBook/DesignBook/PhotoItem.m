//
//  PhotoItem.m
//  DesignBook
//
//  Created by Visitor on 14-11-9.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import "PhotoItem.h"

@implementation PhotoItem
- (id)init
{
    self = [super init];
    if (self) {
        _data = [[NSMutableArray alloc]init];
    }
    return self;
}
@end
