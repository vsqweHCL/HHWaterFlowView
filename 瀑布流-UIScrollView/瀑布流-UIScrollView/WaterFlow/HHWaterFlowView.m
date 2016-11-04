//
//  HHWaterFlowView.m
//  瀑布流-UIScrollView
//
//  Created by HCL黄 on 16/11/4.
//  Copyright © 2016年 HCL黄. All rights reserved.
//

#import "HHWaterFlowView.h"
#import "HHWaterFlowViewCell.h"

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
    
    // 用一个C语言数组存放所有列的最大Y值
    CGFloat maxYOfColumns[numberOfColumns];
    for (NSInteger i = 0; i < numberOfColumns; i++) {
        maxYOfColumns[i] = 0.0;
    }
    
    // 计算所有cell的frame
    for (NSUInteger i = 0; i < numberOfCells; i++) {
        // cell处在第几列,最短的一列
        NSUInteger cellColumn = 0;
        // cell所处那列的最大Y值，最短那一列的最大Y值
        CGFloat maxYOfCellColumn = maxYOfColumns[cellColumn];
        
        for (NSInteger j = 1; j < numberOfColumns; j++) {
            if (maxYOfColumns[j] < maxYOfCellColumn) {
                cellColumn = j;
                maxYOfCellColumn = maxYOfColumns[j];
            }
        }
        
        // 询问代理i位置的高度
        CGFloat cellH = [self heightAtIndex:i];
        
        CGFloat cellX = leftM + cellColumn * (cellW + columnM);
        CGFloat cellY = 0;
        if (maxYOfCellColumn == 0.0) { // 首行
            cellY = topM;
        }
        else {
            cellY = maxYOfCellColumn + rowM;
        }
        
        // 添加到frme数组中
        CGRect cellFrame = CGRectMake(cellX, cellY, cellW, cellH);
        [self.cellFrames addObject:[NSValue valueWithCGRect:cellFrame]];
        
        // 更新最短那一列的最大Y值
        maxYOfColumns[cellColumn] = CGRectGetMaxY(cellFrame);
        
        // 显示cell
        HHWaterFlowViewCell *cell = [self.dataSource waterflowView:self cellAtIndex:i];
        cell.frame = cellFrame;
        [self addSubview:cell];
    }
    
    // 设置contentSize
    CGFloat contentH = maxYOfColumns[0];
    for (NSInteger i = 0; i < numberOfColumns; i++) {
        if (maxYOfColumns[i] > contentH) {
            contentH = maxYOfColumns[i];
        }
    }
    contentH += bottomM;
    self.contentSize = CGSizeMake(0, contentH);
}

#pragma mark - 私有方法
/** 返回间距 */
- (CGFloat)marginForType:(HHWaterFlowViewMarginType)type
{
    if ([self.delegate respondsToSelector:@selector(waterflowView:marginForType:)]) {
        return [self.delegate waterflowView:self marginForType:type];
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
