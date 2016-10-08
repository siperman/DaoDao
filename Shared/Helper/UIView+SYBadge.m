//
//  UIView+SYBadge.m
//  Soouya
//
//  Created by hetao on 3/17/15.
//  Copyright (c) 2015 Soouya. All rights reserved.
//

#import "UIView+SYBadge.h"
#import <objc/runtime.h>

static void *kBagdeLayerKey = "kBagdeLayerKey";
static CGFloat kBagdeWidth = 6.0;

@implementation UIView (SYBadge)

- (void)displayBadgeAt:(CGPoint)point
{
    CALayer *badgeLayer = objc_getAssociatedObject(self, &kBagdeLayerKey);
    if (badgeLayer == nil) {
        badgeLayer = [[CALayer alloc] init];
        badgeLayer.cornerRadius = kBagdeWidth / 2;
        badgeLayer.masksToBounds = YES;
        objc_setAssociatedObject(self, &kBagdeLayerKey, badgeLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        badgeLayer.backgroundColor = [UIColor colorFromHexRGB:@"FE502D" alpha:1].CGColor;
    }
    badgeLayer.frame = CGRectMake(point.x, point.y, kBagdeWidth, kBagdeWidth);
    [self.layer addSublayer:badgeLayer];
}

- (void)hideBadge
{
    CALayer *badgeLayer = objc_getAssociatedObject(self, &kBagdeLayerKey);
    if (badgeLayer) {
        [badgeLayer removeFromSuperlayer];
    }
}

- (CALayer *)badgeDisplayAt:(CGPoint)point
{
    CALayer *badgeLayer = [[CALayer alloc] init];
    badgeLayer.cornerRadius = kBagdeWidth / 2;
    badgeLayer.masksToBounds = YES;
    badgeLayer.backgroundColor = [UIColor colorFromHexRGB:@"FE502D" alpha:1].CGColor;
    badgeLayer.frame = CGRectMake(point.x, point.y, kBagdeWidth, kBagdeWidth);
    [self.layer addSublayer:badgeLayer];
    
    return badgeLayer;
}

- (UIView *)badgeViewDisplayAt:(CGPoint)point
{
    UIView *badgeView = [[UIView alloc] init];
    badgeView.layer.cornerRadius = kBagdeWidth / 2;
    badgeView.layer.masksToBounds = YES;
    badgeView.backgroundColor = [UIColor colorFromHexRGB:@"FE502D" alpha:1];
    badgeView.frame = CGRectMake(point.x, point.y, kBagdeWidth, kBagdeWidth);
    [self addSubview:badgeView];
    
    return badgeView;
}

@end
