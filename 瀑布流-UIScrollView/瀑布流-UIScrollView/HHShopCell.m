//
//  HHShopCell.m
//  瀑布流-UIScrollView
//
//  Created by HCL黄 on 16/11/4.
//  Copyright © 2016年 HCL黄. All rights reserved.
//

#import "HHShopCell.h"
#import "HHWaterFlowView.h"
#import "HHShop.h"
#import "UIImageView+WebCache.h"

@interface HHShopCell ()
/** 图片 */
@property (nonatomic, weak) UIImageView *imageView;
/** 价格 */
@property (nonatomic, weak) UILabel *priceLabel;
@end

@implementation HHShopCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [self addSubview:imageView];
        self.imageView = imageView;
        
        UILabel *priceLabel = [[UILabel alloc] init];
        priceLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        priceLabel.textAlignment = NSTextAlignmentCenter;
        priceLabel.textColor = [UIColor whiteColor];
        priceLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:priceLabel];
        self.priceLabel = priceLabel;
    }
    return self;
}

+ (instancetype)cellWithWaterflowView:(HHWaterFlowView *)waterflowView
{
    static NSString *ID = @"shop";
    HHShopCell *cell = [waterflowView dequeueReusableCellWithIdentifiter:ID];
    if (cell == nil) {
        cell = [[HHShopCell alloc] init];
        cell.identifier = ID;
    }
    return cell;
}
- (void)setShop:(HHShop *)shop
{
    _shop = shop;
    self.priceLabel.text = shop.price;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:shop.img] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
    
    CGFloat priceX = 0;
    CGFloat priceH = 25;
    CGFloat priceY = self.bounds.size.height - priceH;
    CGFloat priceW = self.bounds.size.width;
    self.priceLabel.frame = CGRectMake(priceX, priceY, priceW, priceH);
}
@end
