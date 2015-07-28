//
//  Animate.m
//  DesignBook
//
//  Created by Visitor on 14-11-16.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import "Animate.h"

@implementation Animate
+(CATransition *)addCubeAnimation
{
    CATransition *animation = [CATransition animation];
    [animation setType:@"oglFlip"];
    [animation setSubtype:kCATransitionFromRight];
    [animation setDuration:0.8f];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    return animation;
}
@end
