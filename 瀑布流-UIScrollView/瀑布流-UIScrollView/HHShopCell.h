//
//  HHShopCell.h
//  瀑布流-UIScrollView
//
//  Created by HCL黄 on 16/11/4.
//  Copyright © 2016年 HCL黄. All rights reserved.
//

#import "HHWaterFlowViewCell.h"
@class HHWaterFlowView,HHShop;

@interface HHShopCell : HHWaterFlowViewCell
+ (instancetype)cellWithWaterflowView:(HHWaterFlowView *)waterflowView;
/** 模型 */
@property (nonatomic, strong) HHShop *shop;
@end
