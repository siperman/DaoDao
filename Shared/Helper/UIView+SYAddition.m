//
//  UIView+SYAddition.m
//  Soouya
//
//  Created by hetao on 3/24/15.
//  Copyright (c) 2015 Soouya. All rights reserved.
//

#import "UIView+SYAddition.h"
#import "RIButtonItem.h"
#import "UIAlertView+Blocks.h"
#import "FSBasicImage.h"
#import "FSBasicImageSource.h"
#import "FSImageViewerViewController.h"
#import "SepView.h"
#import <Masonry/Masonry.h>
#import <objc/runtime.h>

static char kSepViewKey;

@implementation UIView (SYAddition)

- (void)sy_round
{
    [self layoutIfNeeded];
    [self sy_round:self.width / 2];
}

- (void)sy_round:(CGFloat)radius
{
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}

- (void)sy_border
{
    self.layer.cornerRadius = kCornerRadius;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = MainColor.CGColor;
    self.layer.borderWidth = kBorderWidth;
}

- (void)makeCall:(NSString *)tel
{
    [self makeCall:tel title:tel];
}

- (void)makeCall:(NSString *)tel title:(NSString *)title
{
    if (tel &&
        tel.length > 0 &&
        ([tel rangeOfString:@"*"].location == NSNotFound)) {
        NSString *t = title ? title : tel;

        if ([t isEqualToString:kServiceCall]) {
            [MobClick event:DialingBtn_click];
        } else {
            [MobClick event:CallCustomerServiceBtn_click];
        }
//        RIButtonItem *btnCancle = [RIButtonItem itemWithLabel:@"取消"];
//        RIButtonItem *btnCall = [RIButtonItem itemWithLabel:@"呼叫" action:^{
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", tel]]];
//        }];
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:t
//                                                        message:nil
//                                               cancelButtonItem:btnCancle
//                                               otherButtonItems:btnCall, nil];
//        [alert show];


        UIAlertController *vc = [UIAlertController alertControllerWithTitle:t message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *call = [UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", tel]]];
        }];
        [vc addAction:cancle];
        [vc addAction:call];
        [self.viewController presentViewController:vc animated:YES completion:nil];
        
    }
}

//- (void)becomeFirstResponderState
//{
//    self.layer.borderColor = SYHightlightedBorderColor.CGColor;
//    self.layer.shadowColor = SYHightlightedBorderColor.CGColor;
//    self.layer.shadowOffset = CGSizeMake(0, 0);
//    self.layer.shadowOpacity = 0.4;
//}
//
//- (void)resignFirstResponderState
//{
//    self.layer.borderColor = SYDefaultBorderColor.CGColor;
//    self.layer.shadowOpacity = 0.0;
//}

- (void)addBottomSepWithLeading:(CGFloat)leading trailing:(CGFloat)trailing
{
    SepView *sepView = objc_getAssociatedObject(self, &kSepViewKey);
    if (!sepView) {
        sepView = [[SepView alloc] init];
        
        objc_setAssociatedObject(self, &kSepViewKey, sepView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [self addSubview:sepView];
        
        [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(leading);
            make.right.equalTo(self.mas_right).with.offset(trailing);
            make.bottom.equalTo(self.mas_bottom).with.offset(0.0);
            make.height.mas_equalTo(OnePixelHeight);
        }];
    } else {
        [sepView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(leading);
            make.right.equalTo(self.mas_right).with.offset(trailing);
        }];
    }
}

- (NSLayoutConstraint *)findRightConstraint
{
    for (NSLayoutConstraint *constraint in self.superview.constraints) {
        if ([self isRightConstraint:constraint]) {
            return constraint;
        }
    }
    
    return nil;
}

- (BOOL)isRightConstraint:(NSLayoutConstraint *)constraint
{
    return  [self firstItemMatchesRightConstraint:constraint] ||
    [self secondItemMatchesRightConstraint:constraint];
}

- (BOOL)firstItemMatchesRightConstraint:(NSLayoutConstraint *)constraint
{
    return constraint.firstItem == self &&
    (constraint.firstAttribute == NSLayoutAttributeRight ||
     constraint.firstAttribute == NSLayoutAttributeRightMargin ||
     constraint.firstAttribute == NSLayoutAttributeTrailing ||
     constraint.firstAttribute == NSLayoutAttributeTrailingMargin
     );
}

- (BOOL)secondItemMatchesRightConstraint:(NSLayoutConstraint *)constraint
{
    return constraint.secondItem == self &&
    (constraint.secondAttribute == NSLayoutAttributeRight ||
     constraint.secondAttribute == NSLayoutAttributeRightMargin ||
     constraint.secondAttribute == NSLayoutAttributeTrailing ||
     constraint.secondAttribute == NSLayoutAttributeTrailingMargin
     );
}

// 判断View是否显示在屏幕上， 大部分情况下是正确的
- (BOOL)isDisplayedInScreen
{
    if (self == nil) {
        return FALSE;
    }
    
    // 若view 隐藏
    if (self.hidden) {
        return FALSE;
    }
    
    // 若没有superview
    if (self.superview == nil) {
        return FALSE;
    }
    
    CGRect screenRect = [UIScreen mainScreen].bounds;
    
    // 转换view对应window的Rect
    CGRect rect = [self.superview convertRect:self.frame toView:nil];
    if (CGRectIsEmpty(rect) || CGRectIsNull(rect)) {
        return FALSE;
    }
    
    // 若size为CGrectZero
    if (CGSizeEqualToSize(rect.size, CGSizeZero)) {
        return  FALSE;
    }
    
    // 获取 该view与window 交叉的 Rect
    CGRect intersectionRect = CGRectIntersection(rect, screenRect);
    if (CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect)) {
        return FALSE;
    }
    
    // view 所在的viewController 可见
    UIViewController *vc = [self viewController];
    if (vc == nil) {
        return FALSE;
    }
    if (!vc.isViewLoaded || vc.view.window == nil ) {
        return FALSE;
    }
    
    
    return TRUE;
}


- (void)shake
{
    CGFloat t = 2.0;
    CGAffineTransform translateRight  = CGAffineTransformTranslate(CGAffineTransformIdentity, t, 0.0);
    CGAffineTransform translateLeft = CGAffineTransformTranslate(CGAffineTransformIdentity, -t, 0.0);

    self.transform = translateLeft;

    [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat animations:^{
        [UIView setAnimationRepeatCount:3.0];
        self.transform = translateRight;
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                self.transform = CGAffineTransformIdentity;
            } completion:NULL];
        }
    }];
}

@end
