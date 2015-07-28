//
//  Question.m
//  DesignBook
//
//  Created by Visitor on 14-11-13.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import "Question.h"

@implementation Question
- (id)init
{
    self = [super init];
    if (self) {
        _total_pic = [[NSMutableArray alloc]init];
    }
    return self;
}
@end
