//
//  PCHeaderView.h
//  ExpandedList
//
//  Created by MacBook Pro on 14-8-25.
//  Copyright (c) 2014年 MacBook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCHeaderView : UIView
@property (nonatomic,strong) UILabel *title;
@property (nonatomic,strong) UIImageView *details;
@property (nonatomic,assign) NSInteger section;
@property (nonatomic,assign) BOOL isTapped;

- (void)headerTitle:(NSString *) title section:(NSInteger) section;

@end
