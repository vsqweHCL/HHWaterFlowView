//
//  HHWaterFlowView.m
//  瀑布流-UIScrollView
//
//  Created by HCL黄 on 16/11/4.
//  Copyright © 2016年 HCL黄. All rights reserved.
//

#import "HHWaterFlowView.h"

#define HHWaterFlowViewDefaultCellH 70
#define HHWaterFlowViewDefaultMargin 8
#define HHWaterFlowViewDefaultNumberOfColumns 3

@interface HHWaterFlowView ()
/** cell的Frame */
@property (nonatomic, strong) NSMutableArray *cellFrames;
@end

@implementation HHWaterFlowView
#pragma mark - 初始化
/** 懒加载 */
- (NSMutableArray *)cellFrames
{
    if (_cellFrames == nil) {
        _cellFrames = [NSMutableArray array];
    }
    return _cellFrames;
}

#pragma mark - 公共接口
/** 
 * 刷新数据
 * 1.计算每一个cell的frame
 */
- (void)reloadData
{
    // cell的总数
    NSUInteger numberOfCells = [self.dataSource numberOfCellsInWaterflowView:self];
    
    // 总列数
    NSUInteger numberOfColumns = [self numberOfColumns];
    
    // 间距
    CGFloat topM = [self marginForType:HHWaterFlowViewMarginTypeTop];
    CGFloat bottomM = [self marginForType:HHWaterFlowViewMarginTypeBottom];
    CGFloat leftM = [self marginForType:HHWaterFlowViewMarginTypeLeft];
    CGFloat rightM = [self marginForType:HHWaterFlowViewMarginTypeRight];
    CGFloat rowM = [self marginForType:HHWaterFlowViewMarginTypeRow];
    CGFloat columnM = [self marginForType:HHWaterFlowViewMarginTypeColumn];
    
    // cell的宽度
    CGFloat cellW = (self.frame.size.width - leftM - rightM - (numberOfColumns - 1) * columnM) / numberOfColumns;
    
    for (NSUInteger i = 0; i < numberOfCells; i++) {
        // 询问代理i位置的高度
        CGFloat cellH = [self heightAtIndex:i];
        
    }
}

#pragma mark - 私有方法
/** 返回间距 */
- (CGFloat)marginForType:(HHWaterFlowViewMarginType)type
{
    if ([self.delegate respondsToSelector:@selector(waterflowView:marginForType:)]) {
        [self.delegate waterflowView:self marginForType:type];
    }
    else {
        return HHWaterFlowViewDefaultMargin;
    }
}

/** 返回多少列 */
- (NSUInteger)numberOfColumns
{
    if ([self.dataSource respondsToSelector:@selector(numberOfColumnsInWaterflowView:)]) {
        return [self.dataSource numberOfColumnsInWaterflowView:self];
    }
    else {
        return HHWaterFlowViewDefaultNumberOfColumns;
    }
}
/** 返回index的高度 */
- (CGFloat)heightAtIndex:(NSUInteger)index
{
    if ([self.delegate respondsToSelector:@selector(waterflowView:heightAtIndex:)]) {
        return [self.delegate waterflowView:self heightAtIndex:index];
    }
    else {
        return HHWaterFlowViewDefaultCellH;
    }
}
@end
