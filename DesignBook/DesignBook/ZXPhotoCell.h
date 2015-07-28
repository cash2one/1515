//
//  ZXPhotoCell.h
//  DesignBook
//
//  Created by Visitor on 14-11-12.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXPhotoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftPhotoImageView;
@property (weak, nonatomic) IBOutlet UILabel *leftTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftCollectionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightPhotoImageView;
@property (weak, nonatomic) IBOutlet UILabel *rightTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightCollectionLabel;

@end
