//
//  UIView+Addition.h
//  DaoDao
//
//  Created by hetao on 16/9/12.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Addition)


/**
 * Shortcut for frame.origin.x.
 *
 * Sets frame.origin.x = left
 */
@property (nonatomic) CGFloat left;

/**
 * Shortcut for frame.origin.y
 *
 * Sets frame.origin.y = top
 */
@property (nonatomic) CGFloat top;

/**
 * Shortcut for frame.origin.x + frame.size.width
 *
 * Sets frame.origin.x = right - frame.size.width
 */
@property (nonatomic) CGFloat right;

/**
 * Shortcut for frame.origin.y + frame.size.height
 *
 * Sets frame.origin.y = bottom - frame.size.height
 */
@property (nonatomic) CGFloat bottom;

/**
 * Shortcut for frame.size.width
 *
 * Sets frame.size.width = width
 */
@property (nonatomic) CGFloat width;

/**
 * Shortcut for frame.size.height
 *
 * Sets frame.size.height = height
 */
@property (nonatomic) CGFloat height;

/**
 * Shortcut for frame.origin
 */
@property (nonatomic) CGPoint origin;

/**
 * Shortcut for frame.size
 */
@property (nonatomic) CGSize size;

@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;

- (id)subviewWithTag:(NSInteger)tag;

- (UIViewController*)viewController;

+ (void)animateWithDuration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options animations:(void (^)(void))animations;

- (id)findFirstResponder;

- (UIImage *)imageByCroppingtoRect:(CGRect)rect;

- (void)shadowStyle;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface UIView (ScreenShot)

// - [UIImage toImage]
//
// Follow device screen scaling. If your view is sized 320 * 480,
// it renders 320 * 480 on non-retina display devices,
// and 640 * 960 on retina display devices
// Use this option for making high resolution view elements snapshots to display on retina devices
- (UIImage *)toImage;

// - [UIImage toImageWithScale]
//
// Force rendering in a given scale. Commonly used will be "1".
// Good for output or saving a static image with the exact size of the view element.
- (UIImage *)toImageWithScale:(CGFloat)scale;

// - [UIImage toImageWithScale:legacy:]
//
// Set legacy to YES to force use the old API instead of
// iOS 7's drawViewHierarchyInRect:afterScreenUpdates: API
- (UIImage *)toImageWithScale:(CGFloat)scale legacy:(BOOL)legacy;


@end