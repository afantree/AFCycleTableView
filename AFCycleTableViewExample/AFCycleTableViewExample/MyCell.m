//
//  MyCell.m
//  AFCustom
//
//  Created by 阿凡树( http://blog.afantree.com ) on 13-3-3.
//  Copyright (c) 2013年 ManGang. All rights reserved.
//

#import "MyCell.h"

@implementation MyCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        iv=[[UIImageView alloc] initWithFrame:frame];
        [self addSubview:iv];
        
        l=[[UILabel alloc] initWithFrame:CGRectMake(0,0,100, 100)];
        l.font=[UIFont boldSystemFontOfSize:60.0f];
        l.textColor=[UIColor redColor];
        l.backgroundColor=[UIColor clearColor];
        [self addSubview:l];
    }
    return self;
}
-(void)setMessageDictionary:(NSDictionary *)messageDictionary
{
    [super setMessageDictionary:messageDictionary];
    
    l.text=[_messageDictionary objectForKey:@"label"];
    iv.image=[UIImage imageNamed:[_messageDictionary objectForKey:@"image"]];
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
