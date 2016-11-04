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

/** 存放所有正在展示的cell */
@property (nonatomic, strong) NSMutableDictionary *displayingCells;

/** 缓存池（用Set，存放离开屏幕的cell） */
@property (nonatomic, strong) NSMutableSet *reusableCells;
@end

@implementation HHWaterFlowView
#pragma mark - 初始化
/** 懒加载 */
- (NSMutableSet *)reusableCells
{
    if (_reusableCells == nil) {
        _reusableCells = [NSMutableSet set];
    }
    return _reusableCells;
}
/** 懒加载 */
- (NSMutableArray *)cellFrames
{
    if (_cellFrames == nil) {
        _cellFrames = [NSMutableArray array];
    }
    return _cellFrames;
}
/** 懒加载 */
- (NSMutableDictionary *)displayingCells
{
    if (_displayingCells == nil) {
        _displayingCells = [NSMutableDictionary dictionary];
    }
    return _displayingCells;
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
//        HHWaterFlowViewCell *cell = [self.dataSource waterflowView:self cellAtIndex:i];
//        cell.frame = cellFrame;
//        [self addSubview:cell];
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
/** 当UIScrollV滚动的时候也会调用这个方法 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 向数据源索要对应位置的cell
    NSUInteger numberOfCells = self.cellFrames.count;
    for (NSInteger i = 0; i < numberOfCells; i++) {
        // 取出i位置的frame
        CGRect cellFrame = [self.cellFrames[i] CGRectValue];
        
        // 优先从字典中取出i位置的cell
        HHWaterFlowViewCell *cell =  self.displayingCells[@(i)];
        
        // 判断i位置对应的frame在不在屏幕上
        if ([self isInScreen:cellFrame]) { // 在屏幕上
            
            if (cell == nil) {
                cell = [self.dataSource waterflowView:self cellAtIndex:i];
                cell.frame = cellFrame;
                [self addSubview:cell];
                
                // 存放到字典中
                self.displayingCells[@(i)] = cell;
            }
        }
        else { // 不在屏幕上
            if (cell) {
                // 从UIScrollView和字典中移除
                [cell removeFromSuperview];
                [self.displayingCells removeObjectForKey:@(i)];
                
                // 存放进缓存池
                [self.reusableCells addObject:cell];
            }
        }
    }
    
//    NSLog(@"%ld",self.subviews.count); 
}
- (id)dequeueReusableCellWithIdentifiter:(NSString *)identifiter
{
    __block HHWaterFlowViewCell *reusableCell = nil;
    [self.reusableCells enumerateObjectsUsingBlock:^(HHWaterFlowViewCell *cell, BOOL * _Nonnull stop) {
        if ([cell.identifier isEqualToString:identifiter]) {
            reusableCell = cell;
            *stop = YES;
        }
    }];
    
    if (reusableCell) { // 从缓存中移除
        [self.reusableCells removeObject:reusableCell];
    }
    return reusableCell;
}

#pragma mark - 私有方法
/** 判断一个frame有无显示在屏幕上 */
- (BOOL)isInScreen:(CGRect)frame
{
    return (CGRectGetMaxY(frame) > self.contentOffset.y &&
            CGRectGetMidY(frame) < self.contentOffset.y + self.bounds.size.height);
}

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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (![self.delegate respondsToSelector:@selector(waterflowView:didSelectAtIndex:)]) return;
        
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    __block NSNumber *selectedIndex = nil;
    [self.displayingCells enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, HHWaterFlowViewCell  *cell, BOOL * _Nonnull stop) {
        if (CGRectContainsPoint(cell.frame, point)) {
            selectedIndex = key;
            *stop = YES;
        }
    }];
    
    if (selectedIndex) {
        [self.delegate waterflowView:self didSelectAtIndex:selectedIndex.unsignedIntegerValue];
    }
}
@end
