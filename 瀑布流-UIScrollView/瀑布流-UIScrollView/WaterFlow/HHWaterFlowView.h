//
//  HHWaterFlowView.h
//  瀑布流-UIScrollView
//
//  Created by HCL黄 on 16/11/4.
//  Copyright © 2016年 HCL黄. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    HHWaterFlowViewMarginTypeTop,
    HHWaterFlowViewMarginTypeBottom,
    HHWaterFlowViewMarginTypeLeft,
    HHWaterFlowViewMarginTypeRight,
    HHWaterFlowViewMarginTypeColumn, // 每一列
    HHWaterFlowViewMarginTypeRow // 每一行
} HHWaterFlowViewMarginType;

@class HHWaterFlowView, HHWaterFlowViewCell;

@protocol HHWaterFlowViewDataSource <NSObject>
@required
/** 一共有多少个数据 */
- (NSUInteger)numberOfCellsInWaterflowView:(HHWaterFlowView *)waterFlowView;
/** 返回index位置对应的cell */
- (HHWaterFlowViewCell *)waterflowView:(HHWaterFlowView *)waterFlowView cellAtIndex:(NSUInteger)index;

@optional
/** 一共有多少列 */
- (NSUInteger)numberOfColumnsInWaterflowView:(HHWaterFlowView *)waterFlowView;
@end

@protocol HHWaterFlowViewDelegate <UIScrollViewDelegate>

@optional
/** 第index位置cell对应的高度 */
- (CGFloat)waterflowView:(HHWaterFlowView *)waterFlowView heightAtIndex:(NSUInteger)index;
/** 选中第index位置的cell */
- (void)waterflowView:(HHWaterFlowView *)waterFlowView didSelectAtIndex:(NSUInteger)index;
/** 返回间距 */
- (CGFloat)waterflowView:(HHWaterFlowView *)waterFlowView marginForType:(HHWaterFlowViewMarginType)type;
@end

@interface HHWaterFlowView : UIScrollView

/** 数据源 */
@property (nonatomic, weak) id<HHWaterFlowViewDataSource> dataSource;
/** 代理 */
@property (nonatomic, weak) id<HHWaterFlowViewDelegate> delegate;

/** 刷新数据 */
- (void)reloadData;
- (id)dequeueReusableCellWithIdentifiter:(NSString *)identifiter;
@end
