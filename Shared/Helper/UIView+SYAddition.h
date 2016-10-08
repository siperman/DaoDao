//
//  UIView+SYAddition.h
//  Soouya
//
//  Created by hetao on 3/24/15.
//  Copyright (c) 2015 Soouya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SYAddition)

- (void)sy_round;
- (void)sy_round:(CGFloat)radius;
- (void)sy_border;

- (void)makeCall:(NSString *)tel;
- (void)makeCall:(NSString *)tel title:(NSString *)title;

//- (void)becomeFirstResponderState;
//- (void)resignFirstResponderState;

- (void)addBottomSepWithLeading:(CGFloat)leading trailing:(CGFloat)trailing;

- (NSLayoutConstraint *)findRightConstraint;

- (BOOL)isDisplayedInScreen;

@end
