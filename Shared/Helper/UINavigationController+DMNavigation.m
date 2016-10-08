////
////  UINavigationController.m
////  Soouya
////
////  Created by hetao on 16/5/19.
////  Copyright © 2016年 Soouya. All rights reserved.
////
//
//#include <objc/runtime.h>
//#import "UINavigationController+DMNavigation.h"
//
//@implementation UINavigationController (DMNavigation)
//
//+ (void)load
//{
//    Method popToRootViewControllerAnimatedOriginal = class_getInstanceMethod(self, @selector(popToRootViewControllerAnimated:));
//    Method popToRootViewControllerAnimatedCustom = class_getInstanceMethod(self, @selector(cus_popToRootViewControllerAnimated:));
//    method_exchangeImplementations(popToRootViewControllerAnimatedOriginal, popToRootViewControllerAnimatedCustom);
//    
//    Method pushViewControllerAnimatedOriginal = class_getInstanceMethod(self, @selector(pushViewController:animated:));
//    Method pushViewControllerAnimatedCustom = class_getInstanceMethod(self, @selector(cus_pushViewController:animated:));
//    method_exchangeImplementations(pushViewControllerAnimatedOriginal, pushViewControllerAnimatedCustom);
//    
//    Method popToViewControllerAnimatedOriginal = class_getInstanceMethod(self, @selector(popToViewController:animated:));
//    Method popToViewControllerAnimatedCustom = class_getInstanceMethod(self, @selector(cus_popToViewController:animated:));
//    method_exchangeImplementations(popToViewControllerAnimatedOriginal, popToViewControllerAnimatedCustom);
//}
//
//
//
//-(NSArray*)cus_popToRootViewControllerAnimated:(BOOL)animated {
//    if ( self.canPushOrPop ) {
//        return [self cus_popToRootViewControllerAnimated:animated];
//    }
//    else {
//        return @[];
//    }
//}
//
//-(void)cus_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    if ( self.canPushOrPop ) {
//        [self cus_pushViewController:viewController animated:animated];
//    }
//}
//
//-(NSArray*)cus_popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    if ( self.canPushOrPop ) {
//        return [self cus_popToViewController:viewController animated:animated];
//    }
//    else {
//        return @[];
//    }
//}
//
//#pragma mark PUBLIC PROPERTIES
//
//-(BOOL)canPushOrPop {
//    id navLock = self.navLock;
//    id topVC = self.topViewController;
//    
//    return ( (! navLock) || (navLock == topVC) );
//}
//
//-(id)navLock {
//    return self.topViewController;
//}
//
//@end
