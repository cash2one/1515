//
//  PublicCell.m
//  DesignBook
//
//  Created by Visitor on 14-11-9.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import "PublicCell.h"

@implementation PublicCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
