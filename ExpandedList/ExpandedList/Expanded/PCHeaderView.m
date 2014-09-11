//
//  PCHeaderView.m
//  ExpandedList
//
//  Created by MacBook Pro on 14-8-25.
//  Copyright (c) 2014年 MacBook Pro. All rights reserved.
//

#import "PCHeaderView.h"

@implementation PCHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _title = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, 100, 30)];
        [self addSubview:_title];
        
        _details = [[UIImageView alloc] initWithFrame:CGRectMake(250, 7, 30, 30)];
        _details.backgroundColor = [UIColor redColor];
        [self addSubview:_details];
        
        _isTapped = NO;
    }
    return self;
}

- (void)headerTitle:(NSString *) title section:(NSInteger) section
{
    self.title.text = title;
    self.title.font = [UIFont systemFontOfSize:14];
    self.section = section;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
