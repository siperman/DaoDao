//
//  SYScrollViewDelegateWrapper.m
//  Soouya
//
//  Created by hetao on 2/25/16.
//  Copyright © 2016 Soouya. All rights reserved.
//

#import "SYScrollViewDelegateWrapper.h"
#import <objc/runtime.h>

@interface MethodsHooker : NSObject

@end

@implementation MethodsHooker

+ (void)hookMethedClass:(Class)class hookSEL:(SEL)hookSEL originalSEL:(SEL)originalSEL myselfSEL:(SEL)mySelfSEL
{
    Method hookMethod = class_getInstanceMethod(class, hookSEL);
    Method mySelfMethod = class_getInstanceMethod([MethodsHooker class], mySelfSEL);
    
    IMP hookMethodIMP = method_getImplementation(hookMethod);
    class_addMethod(class, originalSEL, hookMethodIMP, method_getTypeEncoding(hookMethod));
    
    IMP hookMethodMySelfIMP = method_getImplementation(mySelfMethod);
    class_replaceMethod(class, hookSEL, hookMethodMySelfIMP, method_getTypeEncoding(hookMethod));
}

- (void)myselfScrollViewSetDelegate:(id)delegate
{
    SYScrollViewDelegateWrapper *weakDelegateObject = [[SYScrollViewDelegateWrapper alloc] init];
    weakDelegateObject.delegate = delegate;
    
    objc_setAssociatedObject(self, "weak_delegate_handler", weakDelegateObject, OBJC_ASSOCIATION_RETAIN);
    
    [self originalScrollViewSetDelegate:weakDelegateObject];
}

- (void)originalScrollViewSetDelegate:(id)delegate
{
    
}

@end

@implementation SYScrollViewDelegateWrapper

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if (!_delegate) {
        //NSLog(@"no delegate...");
        return NO;
    }
    NSLog(@"method Name: %s", sel_getName(aSelector));
    BOOL responds = [_delegate respondsToSelector:aSelector];
    //NSLog(@"delegate class:%@ ,responds = %d", [_delegate className], responds);
    return responds;
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    if (_delegate) {
        return _delegate;
    }
    return [super forwardingTargetForSelector:aSelector];
}

+ (void)hookUIScrollViewSetDelegate
{
    [MethodsHooker hookMethedClass:[UIScrollView class]
                           hookSEL:@selector(setDelegate:)
                       originalSEL:@selector(originalScrollViewSetDelegate:)
                         myselfSEL:@selector(myselfScrollViewSetDelegate:)];
}

@end
