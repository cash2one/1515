//
//  Question.h
//  DesignBook
//
//  Created by Visitor on 14-11-13.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Question : NSObject
@property(nonatomic,strong)NSString *comment_nums;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *createtime;
@property(nonatomic,strong)NSString *aid;
@property(nonatomic,strong)NSString *head_photo;
@property(nonatomic,strong)NSNumber *image_id;
@property(nonatomic,strong)NSString *nick;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSMutableArray *total_pic;
@property(nonatomic,strong)NSString *uid;
@property(nonatomic,strong)NSString *view_nums;

@end
