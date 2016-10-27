//
//  UIViewController+Analytics.m
//  Soouya
//
//  Created by hetao on 15/11/28.
//  Copyright © 2015年 Soouya. All rights reserved.
//

#import "UIViewController+Analytics.h"
#import <objc/runtime.h>

@implementation UIViewController (Analytics)

+ (void)load
{
    swizzleMethod([self class], @selector(viewDidAppear:), @selector(soouya_viewDidAppear:));
    swizzleMethod([self class], @selector(viewDidDisappear:), @selector(soouya_viewDidDisappear:));
#if DEBUG
    swizzleMethod([self class], @selector(viewDidLoad), @selector(soouya_viewDidLoad));
#endif
}

void swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector)
{
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (BOOL)shouldLogPageView:(NSString *)className
{
    if ([className hasPrefix:@"UI"] ||
        [className hasPrefix:@"_UI"] ||
        [className hasPrefix:@"BI"]) {
        
        return NO;
    }

    return YES;
}

- (void)soouya_viewDidLoad
{
    [self soouya_viewDidLoad];

    NSString *className = NSStringFromClass([self class]);
    debugLog(@"=========[%@] viewDidLoad", className);
}

- (void)soouya_viewDidAppear:(BOOL)animated
{
    [self soouya_viewDidAppear:animated];
    
    NSString *className = NSStringFromClass([self class]);
    debugLog(@"=========[%@] viewDidAppear", className);
    
//    if ([self shouldLogPageView:className]) {
//        [MobClick beginLogPageView:className];
//    }
}

- (void)soouya_viewDidDisappear:(BOOL)animated
{
    [self soouya_viewDidDisappear:animated];
    
    NSString *className = NSStringFromClass([self class]);
    debugLog(@"=========[%@] viewDidDisappear", className);

//    if ([self shouldLogPageView:className]) {
//        [MobClick endLogPageView:className];
//    }
}


@end
