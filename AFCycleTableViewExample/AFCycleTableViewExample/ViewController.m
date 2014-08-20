//
//  ViewController.m
//  AFCycleTableViewExample
//
//  Created by 阿凡树( http://blog.afantree.com ) on 14-8-20.
//  Copyright (c) 2014年 ManGang. All rights reserved.
//

#import "ViewController.h"
#import "MyCell.h"
@interface ViewController ()

@end

@implementation ViewController
-(void)reloadDataTheView
{
    AFCycleTableView* view=(AFCycleTableView*)[self.view viewWithTag:100];
    [view reloadDataWithMessageArray:array];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    cur=0;
    array=[[NSMutableArray alloc] init];
    for (int i=0; i<6; i++) {
        //NSDictionary* dict=[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d",i] forKey:@"label"];
        NSDictionary* dict=[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",i],@"label",[NSString stringWithFormat:@"image%d.jpg",i],@"image", nil];
        [array addObject:dict];
    }
	// Do any additional setup after loading the view.
    AFCycleTableView* view=[[AFCycleTableView alloc] initWithFrame:CGRectMake(0, 220, 200, 210) andDelegate:self cycleDirection:CycleDirectionPortait messageArray:array];
    view.tag=100;
    [self.view addSubview:view];
    
    [view reloadDataWithMessageArray:nil];
    [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(reloadDataTheView) userInfo:nil repeats:NO];
    
    AFCycleTableView* view1=[[AFCycleTableView alloc] initWithFrame:CGRectMake(0, 0, 320, 200) andDelegate:self cycleDirection:CycleDirectionLandscape messageArray:array];
    view1.tag=200;
    [self.view addSubview:view1];
    view1.autoScrollDuration=1.0f;
    [view1 startAutoScrollTheCycle];
    
    UIButton* button=[UIButton buttonWithType:UIButtonTypeContactAdd];
    button.frame=CGRectMake(220, 220, 30, 30);
    [button addTarget:self action:@selector(bp) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
-(void)bp
{
    cur = (cur + 4)%6;
    AFCycleTableView* view=(AFCycleTableView*)[self.view viewWithTag:100];
    view.currentRow=cur;
    view=(AFCycleTableView*)[self.view viewWithTag:200];
    view.currentRow=cur;
}
#pragma mark - AFCycleTableViewDelegate
-(AFCycleTableViewCell*)cycleTableViewPlaceholderView:(AFCycleTableView *)cycleTableView
{
    MyCell* cell=[[MyCell alloc] initWithFrame:cycleTableView.bounds];
    return cell;
}
-(AFCycleTableViewCell*)cycleTableView:(AFCycleTableView *)cycleTableView
{
    MyCell* cell=[[MyCell alloc] initWithFrame:cycleTableView.bounds];
    return cell;
}
-(void)cycleTableView:(AFCycleTableView *)cycleTableView didSelectRow:(NSInteger)indexRow
{
    switch (cycleTableView.tag) {
        case 100:
            NSLog(@"SelectPortait:%ld",(long)indexRow);
            break;
        case 200:
            NSLog(@"SelectLandscape:%ld",(long)indexRow);
            break;
        default:
            break;
    }
}
-(void)cycleTableView:(AFCycleTableView *)cycleTableView didChangeRow:(NSInteger)indexRow
{
    switch (cycleTableView.tag) {
        case 100:
            NSLog(@"ChangePortait:%ld",(long)indexRow);
            break;
        case 200:
            NSLog(@"ChangeLandscape:%ld",(long)indexRow);
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
