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


#define RandomColor [UIColor colorWithRed:arc4random_uniform(256/255.0) green:arc4random_uniform(256/255.0) blue:arc4random_uniform(256/255.0) alpha:1.0]

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
    return 20;
}
- (NSUInteger)numberOfColumnsInWaterflowView:(HHWaterFlowView *)waterFlowView
{
    return 3;
}
- (HHWaterFlowViewCell *)waterflowView:(HHWaterFlowView *)waterFlowView cellAtIndex:(NSUInteger)index
{
    HHWaterFlowViewCell *cell = [[HHWaterFlowViewCell alloc] init];
    cell.backgroundColor = RandomColor;
    return cell;
}
#pragma mark - 代理
- (CGFloat)waterflowView:(HHWaterFlowView *)waterFlowView heightAtIndex:(NSUInteger)index
{
    return 100;
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
