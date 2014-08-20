//
//  AFCycleTableView.m
//  AFCustom
//
//  Created by 阿凡树( http://blog.afantree.com ) on 13-3-3.
//  Copyright (c) 2013年 ManGang. All rights reserved.
//

#import "AFCycleTableView.h"



@interface AFCycleTableView ()
{
    //旋转用
    UIScrollView         *_scrollView;
    NSArray              *_messageArray;
    NSInteger             _totalRows;
    NSMutableArray       *_subViewsArray;
    //自动滚动
    NSTimer              *_autoScrollTimer;
    CycleAutoScrollType   _cycleAutoScrollType;
}
@end
@implementation AFCycleTableView
@synthesize delegate=_delegate;
@synthesize direction=_direction;
@synthesize currentRow=_currentRow;

-(void)dealloc
{
    if ([_autoScrollTimer isValid]) {
        [_autoScrollTimer invalidate];
    }
    _autoScrollTimer = nil;
}
-(void)setCurrentRow:(NSInteger)currentRow
{
    _currentRow=currentRow;
    
    switch (_direction) {
        case CycleDirectionLandscape:
            [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width*2, 0) animated:YES];
            break;
        case CycleDirectionPortait:
            [_scrollView setContentOffset:CGPointMake(0,_scrollView.frame.size.height*2) animated:YES];
            break;
        default:
            break;
    }
    for (int i=0,j=-1; i<_subViewsArray.count; i++,j++) {
        AFCycleTableViewCell* cell=[_subViewsArray objectAtIndex:i];
        [cell setMessageDictionary:[_messageArray objectAtIndex:(( _currentRow +j + _totalRows) % _totalRows)]];
    }
}
- (id)initWithFrame:(CGRect)frame andDelegate:(id<AFCycleTableViewDelegate>)delegate cycleDirection:(CycleDirection)direction messageArray:(NSArray *)dictArray;
{
    self=[super initWithFrame:frame];
    if (self) {
        //数据初始化
        _direction=direction;
        _delegate=delegate;
        _subViewsArray=[[NSMutableArray alloc] init];
        //初始化滚动时间
        _autoScrollDuration=5.0f;
        _cycleAutoScrollType=CycleAutoScrollTypeRight;
        
        [self makeViewWith:dictArray];
    }
    return self;
}
-(void)makeViewWith:(NSArray *)dictArray
{
    if (![dictArray isKindOfClass:[NSArray class]]) {
        return;
    }
    _currentRow=0;
    _messageArray=dictArray;
    [_subViewsArray removeAllObjects];
    
    //铺上scrollView
    if (_scrollView != nil) {
        [_scrollView removeFromSuperview];
        //[_scrollView release];
    }
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    //CGFloat decelerationRate = 0.1f*UIScrollViewDecelerationRateNormal;
    //[_scrollView setValue:[NSValue valueWithCGSize:CGSizeMake(decelerationRate,decelerationRate)] forKey:@"_decelerationFactor"];
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    
    if (_messageArray != nil) {
        _totalRows=_messageArray.count;
        
        switch (_direction) {
            case CycleDirectionLandscape:
                _scrollView.contentSize=CGSizeMake(_scrollView.bounds.size.width * 3,_scrollView.bounds.size.height);
                for (int i=-1; i<2; i++) {
                    AFCycleTableViewCell* view=[self.delegate cycleTableView:self];
                    view.frame=CGRectMake(_scrollView.bounds.size.width*(i+1), 0, _scrollView.bounds.size.width, _scrollView.bounds.size.height);
                    NSDictionary* dict=[_messageArray objectAtIndex:((i+_totalRows)%_totalRows)];
                    //NSLog(@"%@",dict);
                    [view setMessageDictionary:dict];
                    [_subViewsArray addObject:view];
                    [_scrollView addSubview:view];
                }
                //设置scrollView中间
                _scrollView.contentOffset=CGPointMake(_scrollView.bounds.size.width, 0);
                //NSLog(@"%@",NSStringFromCGPoint(_scrollView.contentOffset));
                break;
            case CycleDirectionPortait:
                _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width,_scrollView.bounds.size.height * 3);
                for (int i=-1; i<2; i++) {
                    AFCycleTableViewCell* view=[self.delegate cycleTableView:self];
                    view.frame=CGRectMake(0, _scrollView.bounds.size.height*(i+1), _scrollView.bounds.size.width, _scrollView.bounds.size.height);
                    [view setMessageDictionary:[_messageArray objectAtIndex:((i+_totalRows)%_totalRows)]];
                    [_subViewsArray addObject:view];
                    [_scrollView addSubview:view];
                }
                //设置scrollView中间
                _scrollView.contentOffset=CGPointMake(0, _scrollView.bounds.size.height);
                break;
            default:
                break;
        }
        
        //添加单击的手势
        for (AFCycleTableViewCell* cell in _subViewsArray) {
            UITapGestureRecognizer* tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
            [cell addGestureRecognizer:tapGesture];
        }
    }
    else{ //如果为空的话有两种状态，一种自定义的视图，一种是默认的
        _scrollView.contentSize=self.bounds.size;
        if ([self.delegate respondsToSelector:@selector(cycleTableViewPlaceholderView:)]) {
            AFCycleTableViewCell* view=[self.delegate cycleTableView:self];
            view.frame=_scrollView.bounds;
            [_scrollView addSubview:view];
        } else {
            UIView* view=[[UIView alloc] initWithFrame:_scrollView.bounds];
            view.backgroundColor=[UIColor redColor];
            [_scrollView addSubview:view];
        }
    }
    
    [self addSubview:_scrollView];
}
#pragma mark - 调用的代理
-(void)tap:(UITapGestureRecognizer*)gesture
{
    if ([_delegate respondsToSelector:@selector(cycleTableView:didSelectRow:)]) {
        [_delegate cycleTableView:self didSelectRow:_currentRow];
    }
}
-(void)changeTheRow
{
    if ([_delegate respondsToSelector:@selector(cycleTableView:didChangeRow:)]) {
        [_delegate cycleTableView:self didChangeRow:_currentRow];
    }
}
#pragma mark - custom
- (void)startAutoScrollTheCycle
{
    [self startAutoScrollTheCycleWithType:CycleAutoScrollTypeRight];
}
- (void)startAutoScrollTheCycleWithType:(CycleAutoScrollType)cycleAutoScrollType
{
    if (_messageArray != nil) {
        _cycleAutoScrollType=cycleAutoScrollType;
        _autoScrollTimer=[NSTimer scheduledTimerWithTimeInterval:_autoScrollDuration target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
    }
}
- (void)stopAutoScrollTheCycle
{
    if (_autoScrollTimer) {
        [_autoScrollTimer invalidate];
        _autoScrollTimer=nil;
    }
}
-(void)autoScroll
{
    switch (_cycleAutoScrollType) {
        case CycleAutoScrollTypeRight:
            [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width*2, 0) animated:YES];
            break;
        case CycleAutoScrollTypeDown:
            [_scrollView setContentOffset:CGPointMake(0,_scrollView.frame.size.height*2) animated:YES];
            break;
        case CycleAutoScrollTypeLeft:
            [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            break;
        case CycleAutoScrollTypeUp:[_scrollView setContentOffset:CGPointMake(0,0) animated:YES];
            break;
        default:
            break;
    }
}
- (void)reloadDataWithMessageArray:(NSArray *)dictArray
{
    [self makeViewWith:dictArray];
}
#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    switch (_direction) {
        case CycleDirectionLandscape:
            if (scrollView.contentOffset.x <= 0) { //向右
                //移动cell
                for (int i=0; i<_subViewsArray.count; i++) {
                    AFCycleTableViewCell* cell=[_subViewsArray objectAtIndex:i];
                    cell.frame=CGRectMake(cell.frame.origin.x + _scrollView.frame.size.width * ((i == 2)?(-2):(1)), cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
                }
                //自减currentRow
                _currentRow = ( _currentRow - 1 + _totalRows) % _totalRows;
                [self changeTheRow];
                //替换cell的内容
                [[_subViewsArray objectAtIndex:2] setMessageDictionary:[_messageArray objectAtIndex:(( _currentRow - 1 + _totalRows) % _totalRows)]];
                
                //array移动  0 1 2  ==>  2 0 1
                //0 1 2 ==> 2 1 0
                [_subViewsArray exchangeObjectAtIndex:0 withObjectAtIndex:2];
                //2 1 0 ==> 2 0 1
                [_subViewsArray exchangeObjectAtIndex:2 withObjectAtIndex:1];
                
                //把scroolView恢复原状
                _scrollView.contentOffset=CGPointMake(_scrollView.frame.size.width, 0);
            }
            else if (scrollView.contentOffset.x >= _scrollView.frame.size.width*2)
            {
              //移动cell
              for (int i=0; i<_subViewsArray.count; i++) {
                  AFCycleTableViewCell* cell=[_subViewsArray objectAtIndex:i];
                  cell.frame=CGRectMake(cell.frame.origin.x - _scrollView.frame.size.width * ((i == 0)?(-2):(1)), cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
              }
              //自增currentRow
              _currentRow = ( _currentRow + 1 ) % _totalRows;
              [self changeTheRow];
              //替换cell的内容
              [[_subViewsArray objectAtIndex:0] setMessageDictionary:[_messageArray objectAtIndex:((_currentRow+1)%_totalRows)]];
              
              //array移动  0 1 2  ==>  1 2 0
              //0 1 2 ==> 2 1 0
              [_subViewsArray exchangeObjectAtIndex:0 withObjectAtIndex:2];
              //2 1 0 ==> 1 2 0
              [_subViewsArray exchangeObjectAtIndex:0 withObjectAtIndex:1];
              
              //把scroolView恢复原状
              _scrollView.contentOffset=CGPointMake(_scrollView.frame.size.width, 0);
            }
            break;
        case CycleDirectionPortait:
            if (scrollView.contentOffset.y <= 0) { //向下
                //移动cell
                for (int i=0; i<_subViewsArray.count; i++) {
                    AFCycleTableViewCell* cell=[_subViewsArray objectAtIndex:i];
                    cell.frame=CGRectMake(cell.frame.origin.x , cell.frame.origin.y+ _scrollView.frame.size.height * ((i == 2)?(-2):(1)), cell.frame.size.width, cell.frame.size.height);
                }
                //自减currentRow
                _currentRow = ( _currentRow - 1 + _totalRows) % _totalRows;
                [self changeTheRow];
                //替换cell的内容
                [[_subViewsArray objectAtIndex:2] setMessageDictionary:[_messageArray objectAtIndex:(( _currentRow - 1 + _totalRows) % _totalRows)]];
                
                //array移动  0 1 2  ==>  2 0 1
                //0 1 2 ==> 2 1 0
                [_subViewsArray exchangeObjectAtIndex:0 withObjectAtIndex:2];
                //2 1 0 ==> 2 0 1
                [_subViewsArray exchangeObjectAtIndex:2 withObjectAtIndex:1];
                
                //把scroolView恢复原状
                _scrollView.contentOffset=CGPointMake(0, _scrollView.frame.size.height);
            }
            else if (scrollView.contentOffset.y >= _scrollView.frame.size.height*2)
              {
                //移动cell
                for (int i=0; i<_subViewsArray.count; i++) {
                    AFCycleTableViewCell* cell=[_subViewsArray objectAtIndex:i];
                    cell.frame=CGRectMake(cell.frame.origin.x , cell.frame.origin.y- _scrollView.frame.size.height * ((i == 0)?(-2):(1)), cell.frame.size.width, cell.frame.size.height);
                }
                //自增currentRow
                _currentRow = ( _currentRow + 1 ) % _totalRows;
                [self changeTheRow];
                //替换cell的内容
                [[_subViewsArray objectAtIndex:0] setMessageDictionary:[_messageArray objectAtIndex:((_currentRow+1)%_totalRows)]];
                
                //array移动  0 1 2  ==>  1 2 0
                //0 1 2 ==> 2 1 0
                [_subViewsArray exchangeObjectAtIndex:0 withObjectAtIndex:2];
                //2 1 0 ==> 1 2 0
                [_subViewsArray exchangeObjectAtIndex:0 withObjectAtIndex:1];
                
                //把scroolView恢复原状
                _scrollView.contentOffset=CGPointMake(0, _scrollView.frame.size.height);
              }
            break;
        default:
            break;
    }
}
@end
