//
//  HHShop.h
//  瀑布流-UIScrollView
//
//  Created by HCL黄 on 16/11/4.
//  Copyright © 2016年 HCL黄. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHShop : NSObject

/** 价格 */
@property (nonatomic, copy) NSString *price;
/** 图片 */
@property (nonatomic, copy) NSString *img;
/** 高度 */
@property (nonatomic, assign) CGFloat h;
/** 宽度 */
@property (nonatomic, assign) CGFloat w;
@end
