//
//  NSString+SYAddition.h
//  Soouya
//
//  Created by hetao on 1/22/15.
//  Copyright (c) 2015 Soouya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SYAddition)

+ (NSString *)randomTimestamp;

- (NSString *)thumbnailUrl;

- (NSString *)originUrl;

- (BOOL)containsUTF8Errors;

- (BOOL)stringContainsEmoji;

- (NSArray *)sy_componentsSeparatedByString:(NSString *)sperator;

- (NSString *)validString;

- (NSString *)stringValue;

- (NSString *)decodeUrl;

+ (NSString *)validString:(NSString *)str;

+ (NSString *)privateTel:(NSString *)tel;

+ (bool)isNumeric:(NSString *)checkText;

- (NSInteger) count;

//根据字体大小和控件宽度计算文本高度
- (CGFloat)textHeightWithFontSize:(CGFloat) fontSize ViewWidth:(CGFloat) width;
//根据字体大小计算文本宽度
- (CGFloat)textWidthWithFontsSize:(CGFloat) fontSize;
//字符串加行间距
- (NSMutableAttributedString *)attributedStringWithLineSpacing:(CGFloat) spacing;
- (NSMutableAttributedString *)attributedStringWithLineSpacing:(CGFloat) spacing Alignment:(NSTextAlignment) alignment;

@end
