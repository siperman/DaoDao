//
//  UINavigationItem+Addition.m
//  DaoDao
//
//  Created by hetao on 2016/12/5.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "UINavigationItem+Addition.h"
#import <objc/runtime.h>

@implementation UINavigationItem (Addition)

+ (void)load
{
    swizzleMethodNavigationItem([self class], @selector(backBarButtonItem), @selector(soouya_backBarbuttonItem));
}

void swizzleMethodNavigationItem(Class class, SEL originalSelector, SEL swizzledSelector)
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

/*
 *  runtime方式替换系统导航栏后退按钮
 */
static char kCustomBackButtonKey;
- (UIBarButtonItem *)soouya_backBarbuttonItem
{
    UIBarButtonItem *item = [self soouya_backBarbuttonItem];
    if (item) {
        return item;
    }
    item = objc_getAssociatedObject(self, &kCustomBackButtonKey);
    if (!item) {
        item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:NULL];
        objc_setAssociatedObject(self, &kCustomBackButtonKey, item, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return item;
}

@end
