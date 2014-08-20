//
//  AFCycleTableView.h
//  AFCustom
//
//  Created by 阿凡树( http://blog.afantree.com ) on 13-3-3.
//  Copyright (c) 2013年 ManGang. All rights reserved.
//
//说明,本类用于轮播
#import <UIKit/UIKit.h>
#import "AFCycleTableViewCell.h"

@class AFCycleTableView,AFCycleTableViewCell;
@protocol AFCycleTableViewDelegate;

typedef enum {
    CycleDirectionPortait,          // 垂直滚动
    CycleDirectionLandscape,        // 水平滚动
}CycleDirection;
typedef enum {
    CycleAutoScrollTypeRight,          
    CycleAutoScrollTypeLeft,        
    CycleAutoScrollTypeDown,
    CycleAutoScrollTypeUp,
}CycleAutoScrollType;
@protocol AFCycleTableViewDelegate <NSObject>
@required
/**
 返回cell的视图,类似于UITableViewCell,这里不用复用
 */
-(AFCycleTableViewCell*)cycleTableView:(AFCycleTableView *)cycleTableView;

@optional
/**
 返回当没有数据时候的视图
 */
-(AFCycleTableViewCell*)cycleTableViewPlaceholderView:(AFCycleTableView *)cycleTableView;
/**
 点击的时候被调用 单手势单点击
 */
- (void)cycleTableView:(AFCycleTableView *)cycleTableView didSelectRow:(NSInteger)indexRow;
/**
 当页面的当前页页数改变时,被调用
 */
- (void)cycleTableView:(AFCycleTableView *)cycleTableView didChangeRow:(NSInteger)indexRow;
@end

@interface AFCycleTableView : UIView<UIScrollViewDelegate>
{
    CycleDirection                    _direction;
    NSInteger                         _currentRow;
    NSInteger                         _autoScrollDuration;
}
@property (nonatomic, readwrite, assign) id<AFCycleTableViewDelegate> delegate;
@property (nonatomic, readonly,  assign) CycleDirection direction;
@property (nonatomic, readwrite, assign) NSInteger currentRow;
//自动滚动的时间 Default is 5s.
@property (nonatomic, readwrite, assign) NSInteger autoScrollDuration;
/**
 唯一的初始化方法,
 每个数组的项是一个字典,该字典包含着一个cell的所有信息
 @param frame,代理,轮播的方向,一个包含字典信息的数组
 @returns id
 */
- (id)initWithFrame:(CGRect)frame andDelegate:(id<AFCycleTableViewDelegate>)delegate cycleDirection:(CycleDirection)direction messageArray:(NSArray *)dictArray;
/**
 开始自动的滚动，还有滚动的方向。
 */
- (void)startAutoScrollTheCycleWithType:(CycleAutoScrollType)cycleAutoScrollType;
- (void)startAutoScrollTheCycle;
/**
 停止滚动
 */
- (void)stopAutoScrollTheCycle;
/**
 刷新数据
 */
- (void)reloadDataWithMessageArray:(NSArray *)dictArray;
@end
