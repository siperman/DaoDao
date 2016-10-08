//
//  UIViewController+NIDropDown.m
//  Soouya
//
//  Created by hetao on 15/6/22.
//  Copyright (c) 2015年 Soouya. All rights reserved.
//

#import "UIViewController+NIDropDown.h"
#import "NIDropDown.h"

@interface UIViewController () <UIViewControllerNIDropDownProtocol, NIDropDownDelegate>

@end

@implementation UIViewController (NIDropDown)

- (void)chooseUnit:(UIButton *)sender
{
    [self.view endEditing:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self chooseUnit:sender selections:@[ @"元/米", @"元/码", @"元/千克" ]];
    });
}

- (void)chooseQuantityUnit:(UIButton *)sender
{
    [self.view endEditing:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self chooseUnit:sender selections:@[@"米", @"码", @"千克"]];
    });
}

- (void)chooseUnit:(UIButton *)sender selections:(NSArray *)selections
{
    if (sender) {
        if(self.dropDown == nil) {
            CGFloat f = sender.height * 4;
            self.dropDown = [[NIDropDown alloc] showDropDown:sender
                                                      height:&f
                                                         arr:selections
                                                      imgArr:nil
                                                   direction:@"down"];
            self.dropDown.delegate = self;
        } else {
            [self.dropDown hideDropDown:sender];
            self.dropDown = nil;
        }
    }
}

@end
