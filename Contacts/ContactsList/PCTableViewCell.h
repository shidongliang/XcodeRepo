//
//  PCTableViewCell.h
//  Contacts
//
//  Created by MacBook Pro on 14-8-25.
//  Copyright (c) 2014年 MacBook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCTableViewCell : UITableViewCell
@property (strong,nonatomic) UILabel *name;
@property (strong,nonatomic) UILabel *duty;
@property (strong,nonatomic) UIImageView *avatar;
@property (strong,nonatomic) UIButton *star;
@property (strong,nonatomic) UIButton *phoneCall;
@property (strong,nonatomic) UIView *subView;

- (void)setUpCell:(NSDictionary *) info;
@end
