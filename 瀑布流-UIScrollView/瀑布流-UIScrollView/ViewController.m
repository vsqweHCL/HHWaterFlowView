//
//  ViewController.m
//  瀑布流-UIScrollView
//
//  Created by HCL黄 on 16/11/4.
//  Copyright © 2016年 HCL黄. All rights reserved.
//

#import "ViewController.h"
#import "HHWaterFlowView.h"
#import "HHShopCell.h"
#import "HHShop.h"
#import "MJExtension.h"

@interface ViewController () <HHWaterFlowViewDelegate,HHWaterFlowViewDataSource>

/** 数据 */
@property (nonatomic, strong) NSMutableArray *datas;
@end


#define RandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]

@implementation ViewController
/** 懒加载 */
- (NSMutableArray *)datas
{
    if (_datas == nil) {
        NSArray *shops = [HHShop objectArrayWithFilename:@"product.plist"];
        _datas = [NSMutableArray array];
        [_datas addObjectsFromArray:shops];
    }
    return _datas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    HHWaterFlowView *waterflowView = [[HHWaterFlowView alloc] init];
    waterflowView.frame = self.view.bounds;
    waterflowView.dataSource = self;
    waterflowView.delegate = self;
    [self.view addSubview:waterflowView];
    
}

#pragma mark - 数据源
- (NSInteger)numberOfCellsInWaterflowView:(HHWaterFlowView *)waterFlowView
{
    return self.datas.count;
}
- (NSInteger)numberOfColumnsInWaterflowView:(HHWaterFlowView *)waterFlowView
{
    return 4;
}
- (HHWaterFlowViewCell *)waterflowView:(HHWaterFlowView *)waterFlowView cellAtIndex:(NSInteger)index
{
    HHShopCell *cell = [HHShopCell cellWithWaterflowView:waterFlowView];
    cell.shop = self.datas[index];
//    NSLog(@"%ld %p",index,cell);
    return cell;
}
#pragma mark - 代理
- (CGFloat)waterflowView:(HHWaterFlowView *)waterFlowView heightAtIndex:(NSInteger)index
{
    HHShop *shop = self.datas[index];
    return waterFlowView.cellWidth * shop.h / shop.w;
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
- (void)waterflowView:(HHWaterFlowView *)waterFlowView didSelectAtIndex:(NSInteger)index
{
    NSLog(@"点击了第%ld个cell",index);
}
@end
