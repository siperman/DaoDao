//
//  UIColor+Addition.m
//  DaoDao
//
//  Created by hetao on 16/9/6.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "UIColor+Addition.h"

@implementation UIColor (Addition)

+ (UIColor *)seperatorColor
{
    return [UIColor colorWithR:198 g:202 b:202 a:0.5];
}

+ (UIColor *)colorWithOneNum:(CGFloat)num
{
    return [UIColor colorWithRed:(num/255.0) green:(num/255.0) blue:(num/255.0) alpha:1];
}

+ (UIColor *)colorWithR:(CGFloat)r g:(CGFloat)g b:(CGFloat)b a:(CGFloat)a
{
    return [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:a];
}

+ (UIColor *) colorFromHexRGB:(NSString *) inColorString alpha:(CGFloat)alpha
{
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;

    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:alpha];
    return result;
}

@end
