//
//  UIButton+Addition.m
//  Soouya
//
//  Created by hetao on 1/21/15.
//  Copyright (c) 2015 Soouya. All rights reserved.
//

#import "UIButton+Addition.h"
#import "UIImage+ImageWithColor.h"

@implementation UIButton (Addition)

- (void)actionStyle
{
    self.backgroundColor = MainColor;
//    self.titleLabel.font = Font(18.0);

    [self setTitleColor:WhiteColor];

    // 设置点击和禁用状态背景色
    [self setBackgroundImage:[UIImage imageWithColor:ClickColor] forState:UIControlStateHighlighted];
    [self setBackgroundImage:[UIImage imageWithColor:CCCColor] forState:UIControlStateDisabled];

    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = kCornerRadius;
}

- (void)actionTransparentStyle
{
    self.backgroundColor = ClearColor;
    self.titleLabel.font = Font(18.0);

    [self setTitleColor:MainColor forState:UIControlStateNormal];
    [self setTitleColor:TextColor forState:UIControlStateDisabled];
    [self setBackgroundImage:[UIImage imageWithColor:ColorHex(@"9e9e9e")] forState:UIControlStateHighlighted];

    self.layer.borderColor = MainColor.CGColor;
    self.layer.borderWidth = OnePixelHeight;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = kCornerRadius;
}

- (void)textStyle
{
    self.backgroundColor = ClearColor;
    self.titleLabel.font = NormalTextFont;

    [self setTitleColor:TextColor forState:UIControlStateNormal];
}

- (void)textSencondStyle
{
    self.backgroundColor = ClearColor;
    self.titleLabel.font = NormalTextFont;

    [self setTitleColor:SecondColor forState:UIControlStateNormal];
}

- (void)radioStyle
{
    [self setImage:Image(@"all_radio_select") forState:UIControlStateSelected];
    [self setImage:Image(@"all_radio_unselect") forState:UIControlStateNormal];
}

- (void)sy_setImage:(UIImage *)image
{
    [self setImage:image forState:UIControlStateNormal];
    [self setImage:image forState:UIControlStateHighlighted];
    [self setImage:image forState:UIControlStateSelected];
}

- (void)sy_setBackgroundImage:(UIImage *)image
{
    [self setBackgroundImage:image forState:UIControlStateNormal];
    [self setBackgroundImage:image forState:UIControlStateHighlighted];
    [self setBackgroundImage:image forState:UIControlStateSelected];
}

- (void)setTitle:(NSString *)title
{
    [UIView performWithoutAnimation:^{
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitle:title forState:UIControlStateSelected];
        [self setTitle:title forState:UIControlStateHighlighted];
        
        [self layoutIfNeeded];
    }];
}

- (void)setTitleColor:(UIColor *)color
{
    [self setTitleColor:color forState:UIControlStateNormal];
    [self setTitleColor:color forState:UIControlStateSelected];
    [self setTitleColor:color forState:UIControlStateHighlighted];
}

@end
