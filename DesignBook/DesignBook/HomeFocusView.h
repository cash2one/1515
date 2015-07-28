//
//  HomeFocusView.h
//  DesignBook
//
//  Created by Visitor on 14-11-6.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeFocusView : UIView<UIScrollViewDelegate>
-(void)createFocusViewWithHotImgArr:(NSArray *)hotArr andClass:(id)classObject;
@end
