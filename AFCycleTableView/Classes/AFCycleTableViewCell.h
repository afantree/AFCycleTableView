//
//  AFCycleTableViewCell.h
//  AFCustom
//
//  Created by 阿凡树( http://blog.afantree.com ) on 13-3-3.
//  Copyright (c) 2013年 ManGang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AFCycleTableViewCell : UIView
{
    NSDictionary     *_messageDictionary;
}
@property (nonatomic, readwrite, retain) NSDictionary *messageDictionary;
-(void)setMessageDictionary:(NSDictionary *)messageDictionary;
@end

