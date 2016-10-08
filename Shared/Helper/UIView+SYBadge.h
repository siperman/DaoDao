//
//  UIView+SYBadge.h
//  Soouya
//
//  Created by hetao on 3/17/15.
//  Copyright (c) 2015 Soouya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SYBadge)

- (void)displayBadgeAt:(CGPoint)point;

- (void)hideBadge;

- (CALayer *)badgeDisplayAt:(CGPoint)point;

- (UIView *)badgeViewDisplayAt:(CGPoint)point;

@end
