//
//  ViewController.h
//  AFCycleTableViewExample
//
//  Created by 阿凡树( http://blog.afantree.com ) on 14-8-20.
//  Copyright (c) 2014年 ManGang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFCycleTableView.h"
@interface ViewController : UIViewController<AFCycleTableViewDelegate>
{
    int     cur;
    NSMutableArray* array;
}
@end
