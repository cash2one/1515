//
//  RankCell.h
//  DesignBook
//
//  Created by Visitor on 14-11-13.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RankList.h"
@interface RankCell : UITableViewCell
-(void)createUI;
-(void)setFrameWithRankList:(RankList *)rl andClass:(id)classObjcet;
@end
