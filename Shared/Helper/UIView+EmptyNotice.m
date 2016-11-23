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
             @"img_kong",
             @"img_kong",
             @"img_kong",
             @"img_kong",

             ][type];
}

- (NSString *)noticeTextForType:(SYEmptyNoticeType)type
{
    return @[
             @"哎呀，网络加载失败",
             @"暂无新的邀请",
             @"暂无新的消息",
             @"暂无发布的需求",
             @"暂无响应的需求",
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
        CGFloat imgOffset = -90.0;
        UIImageView *imgNotice = [[UIImageView alloc] init];
        imgNotice.image = Image([self noticeImageNameForType:type]);
        
        [noticeView addSubview:imgNotice];
        
        [imgNotice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(125);
            make.height.mas_equalTo(120);
            make.center.equalTo(noticeView).centerOffset(CGPointMake(0, imgOffset));
        }];
        
        // labNotice
        UILabel *labNotice = [[UILabel alloc] init];
        labNotice.textAlignment = NSTextAlignmentCenter;
        labNotice.numberOfLines = 0;
        labNotice.textColor = TextColor;
        labNotice.font = Font(24);
        labNotice.text = [self noticeTextForType:type];
        
        [noticeView addSubview:labNotice];
        
        [labNotice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10.0);
            make.right.mas_equalTo(-10.0);
            make.bottom.equalTo(imgNotice.mas_top).with.offset(-40.0);
        }];

        if (type == SYEmptyNoticeTypeEmptyMyAsk) {
            UIButton *btn = [[UIButton alloc] init];
            [btn setTitle:@"发布需求"];
            [btn actionStyle];
            btn.titleLabel.font = Font(17.0);
            [noticeView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(180);
                make.height.mas_equalTo(50);
                make.centerX.equalTo(noticeView);
                make.top.equalTo(imgNotice.mas_bottom).with.offset(50);
            }];
            [btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
        }

        noticeView.backgroundColor = BackgroundColor;

        [self addSubview:noticeView];
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

- (void)clickBtn
{
    POST_NOTIFICATION(kClickEmptyViewNotification, nil);
}

@end
