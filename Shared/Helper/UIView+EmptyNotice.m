//
//  UIView+EmptyNotice.m
//  Soouya
//
//  Created by hetao on 15/12/4.
//  Copyright © 2015年 Soouya. All rights reserved.
//

#import "UIView+EmptyNotice.h"
#import <objc/runtime.h>
#import <Masonry/Masonry.h>

static char kNoticeViewKey;

@implementation UIView (EmptyNotice)

- (NSString *)noticeImageNameForType:(SYEmptyNoticeType)type
{
    return @[
             @"img_network_error",
             @"img_empty_product",
             @"img_empty_free_call",
             @"img_empty_order",
             @"img_empty_demand",
             @"img_empty_search_result",
             @"img_empty_message",
             @"img_empty_following_stores",
             @"img_empty_faved_pattern",
             @"img_empty_product",
             @"img_product_sold_out",
             @"img_empty_search_result",
             @"img_empty_demand",
             @"img_empty_order"
             ][type];
}

- (NSString *)noticeTextForType:(SYEmptyNoticeType)type
{
    return @[
             @"哎呀，网络加载失败",
             @"店主还没有上传商品呢",
             @"暂无匿名呼叫记录",
             @"您还没有订单",
             @"暂无待支付订单",
             @"抱歉，没有找到符合条件的商品",
             @"您还没有发过消息",
             @"您还没有关注店铺",
             @"您还没有收藏花型",
             @"您还没有收藏面辅料",
             @"抱歉，商品已下架",
             @"抱歉，没有找到符合条件的店铺",
             @"您还没有相关的采购",
             @"您还没有相关的订单"
             ][type];
}

- (void)showEmptyNotice:(SYEmptyNoticeType)type
{
    UIView *noticeView = objc_getAssociatedObject(self, &kNoticeViewKey);
    if (!noticeView) {
        CGRect rect = self.frame;
        rect.origin = CGPointZero;
        noticeView = [[UIView alloc] initWithFrame:rect];
        noticeView.backgroundColor = ClearColor;
        
        objc_setAssociatedObject(self, &kNoticeViewKey, noticeView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        // imgNotice
        CGFloat imgWidth = 90.0;
        CGFloat imgOffset = (type != SYEmptyNoticeTypeEmptyProduct ? -imgWidth : (184.0 - imgWidth) / 2.0);  // 184.0 is preview header cell height
        UIImageView *imgNotice = [[UIImageView alloc] init];
        imgNotice.image = Image([self noticeImageNameForType:type]);
        
        [noticeView addSubview:imgNotice];
        
        [imgNotice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(imgWidth);
            make.height.mas_equalTo(imgWidth);
            make.center.equalTo(noticeView).centerOffset(CGPointMake(0, imgOffset));
        }];
        
        // labNotice
        UILabel *labNotice = [[UILabel alloc] init];
        labNotice.textAlignment = NSTextAlignmentCenter;
        labNotice.numberOfLines = 0;
        labNotice.textColor = TextColor;
        labNotice.font = Font(14);
        labNotice.text = [self noticeTextForType:type];
        
        [noticeView addSubview:labNotice];
        
        [labNotice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10.0);
            make.right.mas_equalTo(-10.0);
            make.top.equalTo(imgNotice.mas_bottom).with.offset(10.0);
        }];


        if (type != SYEmptyNoticeTypeProductSoldOut) {
            [self insertSubview:noticeView atIndex:0];
        } else {
            noticeView.backgroundColor = BackgroundColor;

            [self addSubview:noticeView];
        }
    }else{
        //更新文案
        UILabel *labNotice = [noticeView subviews][1];
        labNotice.text = [ self noticeTextForType:type];
    }
//    [self bringSubviewToFront:noticeView]; 会导致tableview不能下拉刷新
}

- (void)removeEmptyNotice
{
    UIView *noticeView = objc_getAssociatedObject(self, &kNoticeViewKey);
    if (noticeView) {
        [noticeView removeFromSuperview];
        
        objc_setAssociatedObject(self, &kNoticeViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)configureEmptyNoticeForDataSource:(NSArray *)dataSource type:(SYEmptyNoticeType)type
{
    if ([dataSource isKindOfClass:[NSArray class]]) {
        if (dataSource.count > 0) {
            [self removeEmptyNotice];
        } else {
            [self showEmptyNotice:type];
        }
    }
}

@end
