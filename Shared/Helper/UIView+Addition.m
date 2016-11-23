//
//  UIView+Addition.m
//  DaoDao
//
//  Created by hetao on 16/9/12.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "UIView+Addition.h"

@implementation UIView (Addition)


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)left {
    return self.frame.origin.x;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)top {
    return self.frame.origin.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)right {
    return self.left + self.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setRight:(CGFloat)right {
    if(right == self.right){
        return;
    }
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)bottom {
    return self.top + self.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setBottom:(CGFloat)bottom {
    if(bottom == self.bottom){
        return;
    }

    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerX {
    return self.center.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerY {
    return self.center.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)width {
    return self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)height {
    return self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setHeight:(CGFloat)height {
    if(height == self.height){
        return;
    }

    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGPoint)origin {
    return self.frame.origin;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGSize)size {
    return self.frame.size;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*)descendantOrSelfWithClass:(Class)cls {
    if ([self isKindOfClass:cls])
        return self;

    for (UIView* child in self.subviews) {
        UIView* it = [child descendantOrSelfWithClass:cls];
        if (it)
            return it;
    }

    return nil;
}

- (id)subviewWithTag:(NSInteger)tag{
    for(UIView *view in [self subviews]){
        if(view.tag == tag){
            return view;
        }
    }

    return nil;
}

- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

+ (void)animateWithDuration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options animations:(void (^)(void))animations {
    [self animateWithDuration:duration
                        delay:0
                      options:options
                   animations:animations
                   completion:nil];
}

- (id)findFirstResponder
{
    if (self.isFirstResponder) {
        return self;
    }
    for (UIView *subView in self.subviews) {
        id responder = [subView findFirstResponder];
        if (responder) return responder;
    }
    return nil;
}

- (UIImage *)imageByCroppingtoRect:(CGRect)rect
{
    CGSize pageSize = rect.size;
    UIGraphicsBeginImageContext(pageSize);

    CGContextRef resizedContext = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:resizedContext];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return image;
}

- (void)shadowStyle
{
    self.layer.shadowColor = [UIColor blackColor].CGColor;

    self.layer.shadowOffset = CGSizeMake(0, 1);

    self.layer.shadowOpacity = 0.2;

    self.layer.shadowRadius = kShadowRadius;

    self.layer.cornerRadius = kCornerRadius;

    self.clipsToBounds = NO;
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation UIView (ScreenShot)

static BOOL _supportDrawViewHierarchyInRect;

+ (void)load {
    if ([self instancesRespondToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        _supportDrawViewHierarchyInRect = YES;
    } else {
        _supportDrawViewHierarchyInRect = NO;
    }
}

- (UIImage *)toImage {
    CGFloat scale = [UIScreen mainScreen].scale;
    return [self toImageWithScale:scale];}

- (UIImage *)toImageWithScale:(CGFloat)scale {
    UIImage *copied = [self toImageWithScale:scale legacy:NO];
    return copied;
}

- (UIImage *)toImageWithScale:(CGFloat)scale legacy:(BOOL)legacy {
    // If scale is 0, it'll follows the screen scale for creating the bounds
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.bounds.size.width * scale, self.bounds.size.height * scale), NO, 0);

    if (legacy || ! _supportDrawViewHierarchyInRect) {
        // - [CALayer renderInContext:] also renders subviews
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    } else {
        [self drawViewHierarchyInRect:CGRectMake(0, 0, self.bounds.size.width * scale, self.bounds.size.height * scale)
                   afterScreenUpdates:YES];
    }

    // Get the image out of the context
    UIImage *copied = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    // Return the result
    return copied;
}

@end
