//
//  AFCycleTableViewCell.m
//  AFCustom
//
//  Created by 阿凡树( http://blog.afantree.com ) on 13-3-3.
//  Copyright (c) 2013年 ManGang. All rights reserved.
//

#import "AFCycleTableViewCell.h"

@implementation AFCycleTableViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)setMessageDictionary:(NSDictionary *)messageDictionary
{
    _messageDictionary=messageDictionary;
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
