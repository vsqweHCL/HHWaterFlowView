//
//  ViewController.m
//  瀑布流-UIScrollView
//
//  Created by HCL黄 on 16/11/4.
//  Copyright © 2016年 HCL黄. All rights reserved.
//

#import "ViewController.h"
#import "HHWaterFlowView.h"
#import "HHWaterFlowViewCell.h"

@interface ViewController () <HHWaterFlowViewDelegate,HHWaterFlowViewDataSource>

@end


#define RandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    HHWaterFlowView *waterflowView = [[HHWaterFlowView alloc] init];
    waterflowView.frame = self.view.bounds;
    waterflowView.dataSource = self;
    waterflowView.delegate = self;
    [self.view addSubview:waterflowView];
    
    [waterflowView reloadData];
}

#pragma mark - 数据源
- (NSUInteger)numberOfCellsInWaterflowView:(HHWaterFlowView *)waterFlowView
{
    return 50;
}
- (NSUInteger)numberOfColumnsInWaterflowView:(HHWaterFlowView *)waterFlowView
{
    return 3;
}
- (HHWaterFlowViewCell *)waterflowView:(HHWaterFlowView *)waterFlowView cellAtIndex:(NSUInteger)index
{
    static NSString *ID = @"cell";
    HHWaterFlowViewCell *cell = [waterFlowView dequeueReusableCellWithIdentifiter:ID];
    if (cell == nil) {
        cell = [[HHWaterFlowViewCell alloc] init];
        cell.identifier = ID;
        cell.backgroundColor = RandomColor;
        
        UILabel *label = [[UILabel alloc] init];
        label.tag = 10;
        label.frame = CGRectMake(0, 0, 30, 30);
        [cell addSubview:label];
    }
    UILabel *label = (UILabel *)[cell viewWithTag:10];
    label.text = [NSString stringWithFormat:@"%ld",index];
    
//    NSLog(@"%ld %p",index,cell);
    return cell;
}
#pragma mark - 代理
- (CGFloat)waterflowView:(HHWaterFlowView *)waterFlowView heightAtIndex:(NSUInteger)index
{
    switch (index % 3) {
        case 0: return 70;
        case 1: return 100;
        case 2: return 90;
        default: return 110;
    }
}
- (CGFloat)waterflowView:(HHWaterFlowView *)waterFlowView marginForType:(HHWaterFlowViewMarginType)type
{
    switch (type) {
        case HHWaterFlowViewMarginTypeTop:
        case HHWaterFlowViewMarginTypeBottom:
        case HHWaterFlowViewMarginTypeLeft:
        case HHWaterFlowViewMarginTypeRight:
        return 10;
            
        default: return 5;
    }
}
- (void)waterflowView:(HHWaterFlowView *)waterFlowView didSelectAtIndex:(NSUInteger)index
{
    NSLog(@"点击了第%ld个cell",index);
}
@end
