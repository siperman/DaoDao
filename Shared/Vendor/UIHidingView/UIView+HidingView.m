//
//  UIView+HidingView.m
//  UIHidingView
//
//  Created by Roman Barzyczak on 20.07.2013.
//  Copyright (c) 2013 yoman07. All rights reserved.
//

#import "UIView+HidingView.h"
#import <objc/runtime.h>

#define ANIMATION_HIDE_BUTTONS_TIME 0.2

static char const * const ObjectTagKeyLastContentOffset = "lastContentOffset";
static char const * const ObjectTagKeyStartContentOffset = "startContentOffset";

typedef enum ScrollDirection {
    ScrollDirectionUp,
    ScrollDirectionDown
} ScrollDirection;

@implementation UIView (HidingView)

@dynamic startContentOffset;
@dynamic lastContentOffset;

- (void)hv_scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.startContentOffset = self.lastContentOffset = scrollView.contentOffset.y;
}

- (void)hv_scrollViewDidScroll:(UIScrollView *)scrollView {
    __block BOOL wasAnimated = NO;
    ScrollDirection scrollDirection = ScrollDirectionDown;
    
    if (self.lastContentOffset > scrollView.contentOffset.y)
        scrollDirection = ScrollDirectionUp;
    
    else {
        scrollDirection = ScrollDirectionDown;
    }
    
    CGFloat currentOffset = scrollView.contentOffset.y;
    CGFloat differenceFromLast = self.lastContentOffset - currentOffset;
    self.lastContentOffset = currentOffset;
    
    if(scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.height)) {
//        UIEdgeInsets inset = scrollView.contentInset;
//        inset.bottom = self.height;
//        scrollView.contentInset = inset;
//        [UIView animateWithDuration:ANIMATION_HIDE_BUTTONS_TIME
//                         animations:^{
//                             self.frame = CGRectMake(self.frame.origin.x,
//                                                     self.superview.height - self.height,
//                                                     self.bounds.size.width,
//                                                     self.bounds.size.height);
//                         }];
//        scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.superview.height - self.height);
//        self.frame = CGRectMake(0, self.superview.bottom - self.height, self.width, self.height);
//        wasAnimated = YES;
    } else if(scrollView.contentOffset.y > 0 && scrollView.height == self.superview.height){
//        scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.superview.height);
    }
    
    if((fabs(differenceFromLast) > 1) && scrollView.isTracking && !wasAnimated ) {
        if(scrollDirection == ScrollDirectionDown) {    // Hide
            
            [UIView animateWithDuration:ANIMATION_HIDE_BUTTONS_TIME
                             animations:^{
                                 self.top = scrollView.bottom;
                             }];
        } else {
            self.alpha = 1.0;
            [UIView animateWithDuration:ANIMATION_HIDE_BUTTONS_TIME // Show
                             animations:^{
                                 self.frame = CGRectMake(self.frame.origin.x,
                                                         self.superview.height - self.height,
                                                         self.bounds.size.width,
                                                         self.bounds.size.height);
                             }];
        }
    }
}

- (NSInteger)startContentOffset {
    return [objc_getAssociatedObject(self, ObjectTagKeyStartContentOffset) integerValue];
}

- (void)setStartContentOffset:(NSInteger)newObjectTag {
    objc_setAssociatedObject(self, ObjectTagKeyStartContentOffset, @(newObjectTag), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)lastContentOffset {
    return [objc_getAssociatedObject(self, ObjectTagKeyLastContentOffset) integerValue];
}

- (void)setLastContentOffset:(NSInteger)newObjectTag {
    objc_setAssociatedObject(self, ObjectTagKeyLastContentOffset, @(newObjectTag), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
