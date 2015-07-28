//
//  Answer.h
//  DesignBook
//
//  Created by Visitor on 14-11-13.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MsgtoItem.h"


@interface Answer : NSObject
@property(nonatomic,strong)NSString *answer_uid;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *createtime;
@property(nonatomic,strong)NSString *f_commentid;
@property(nonatomic,strong)NSString *head_photo;
@property(nonatomic,strong)NSString *uid;
@property(nonatomic,strong)NSString *indentity;
@property(nonatomic,strong)NSString *nick;
@property(nonatomic,strong)NSString *pic;
@property(nonatomic,strong)NSNumber *praise;
@property(nonatomic,strong)NSString *praise_num;
@property(nonatomic,strong)MsgtoItem *msgto;
@end
