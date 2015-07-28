//
//  PhotoDataItem.h
//  DesignBook
//
//  Created by Visitor on 14-11-9.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoDataItem : NSObject
@property(nonatomic,strong)NSString *added_by;
@property(nonatomic,strong)NSNumber *collection;
@property(nonatomic,strong)NSString *uid;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *nb_image;
@property(nonatomic,strong)NSString *path;
@property(nonatomic,strong)NSString *path_s;
@property(nonatomic,strong)NSString *question_num;
@property(nonatomic,strong)NSString *sjs_name;
@property(nonatomic,strong)NSString *uploadtype;

@end
