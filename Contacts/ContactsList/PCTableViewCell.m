//
//  PCTableViewCell.m
//  Contacts
//
//  Created by MacBook Pro on 14-8-25.
//  Copyright (c) 2014年 MacBook Pro. All rights reserved.
//

#import "PCTableViewCell.h"

@implementation PCTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _avatar = [[UIImageView alloc] init];
        _name = [[UILabel alloc] init];
        _duty = [[UILabel alloc] init];
        _star = [[UIButton alloc] init];
        _phoneCall = [[UIButton alloc] init];
        [self cellConstruction];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    _avatar = [[UIImageView alloc] init];
    _name = [[UILabel alloc] init];
    _duty = [[UILabel alloc] init];
    _star = [[UIButton alloc] init];
    _phoneCall = [[UIButton alloc] init];
    [self cellConstruction];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark set up Cell
- (void)cellConstruction
{
    self.avatar.frame = CGRectMake(5, 5, 50, 50);
    self.avatar.backgroundColor = [UIColor blackColor];
    [self.contentView addSubview:self.avatar];
    
    self.name.frame = CGRectMake(65, 5, 100, 25);
    self.name.font = [UIFont systemFontOfSize:13];
    self.name.text = @"name";
    [self.contentView addSubview:self.name];
    
    self.duty.frame = CGRectMake(65, 35, 100, 20);
    self.duty.font = [UIFont systemFontOfSize:11];
    self.duty.text = @"duty";
    [self.contentView addSubview:self.duty];
    
    self.star.frame = CGRectMake(200, 20, 20, 20);
    self.star.backgroundColor  = [UIColor yellowColor];
    [self.contentView addSubview:self.star];
    
    self.phoneCall.frame = CGRectMake(250, 10, 40, 40);
    self.phoneCall.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.phoneCall];
    [self.phoneCall addTarget:self action:@selector(showSubView:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setUpCell:(NSDictionary *)info
{
    self.name.text = [info objectForKey:@"name"];
    self.duty.text = [info objectForKey: @"phoneNumber"];
}

- (void)showSubView:(UIButton *)sender
{
    self.subView = [[UIView alloc] init];
    self.subView.frame = CGRectMake(10, 0, 300, 100);
    [self.contentView addSubview:self.subView];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showList" object:self.phoneCall];
}

@end
