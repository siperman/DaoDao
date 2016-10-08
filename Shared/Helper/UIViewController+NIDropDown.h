//
//  UIViewController+NIDropDown.h
//  Soouya
//
//  Created by hetao on 15/6/22.
//  Copyright (c) 2015年 Soouya. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NIDropDown;

@protocol UIViewControllerNIDropDownProtocol <NSObject>

@property (nonatomic, strong) NIDropDown *dropDown;

@end

@interface UIViewController (NIDropDown)

- (void)chooseUnit:(UIButton *)sender;
- (void)chooseQuantityUnit:(UIButton *)sender;
- (void)chooseUnit:(UIButton *)sender selections:(NSArray *)selections;

@end
