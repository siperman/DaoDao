//
//  NSString+SYAddition.m
//  Soouya
//
//  Created by hetao on 1/22/15.
//  Copyright (c) 2015 Soouya. All rights reserved.
//

#import "NSString+SYAddition.h"

@implementation NSString (SYAddition)

static NSDateFormatter *dateFormatter = nil;
+ (NSString *)randomTimestamp
{
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyyMMddhhmmss";
    }
    
    return [NSString stringWithFormat:@"%@%05d", [dateFormatter stringFromDate:[NSDate date]], arc4random() % 10000];
}

- (NSString *)thumbnailUrl
{
    if (self.length > 0) {
        if ([self rangeOfString:@"_thumbnail.jpg"].location != NSNotFound) {
            return self;
        } else if ([self rangeOfString:@".jpg"].location != NSNotFound) {
            return [self stringByReplacingOccurrencesOfString:@".jpg" withString:@"_thumbnail.jpg"];
        }
    }
    return self;
}

- (NSString *)originUrl
{
    if ([self rangeOfString:@"_thumbnail.jpg"].location != NSNotFound) {
        return [self stringByReplacingOccurrencesOfString:@"_thumbnail.jpg"
                                               withString:@".jpg"];
    }
    return self;
}

- (BOOL)containsUTF8Errors
{
    // Check for byte order marks
    // http://en.wikipedia.org/wiki/Byte_order_mark
    if ( [self rangeOfString:@"Ôªø"].location != NSNotFound )
    {
        return true;
    }
    // Now check for weird character patterns like
    // Ã„ Ã¤ Ã– Ã¶ Ãœ Ã¼ ÃŸ
    // We basically check the Basic Latin Unicode page, so
    // U+0000 to U+00FF.
    for ( int index = 0; index < [self length]; ++index )
    {
        unichar const charInput = [self characterAtIndex:index];
        if ( ( charInput == 0xC2 ) && ( index + 1 < [self length] ) )
        {
            // Check for degree character and similar that are UTF8 but have incorrectly
            // been translated as Latin1 (ISO 8859-1) or ASCII.
            unichar const char2Input = [self characterAtIndex:index+1];
            if ( ( char2Input >= 0xa0 ) && ( char2Input <= 0xbf ) )
            {
                return true;
            }
        }
        if ( ( charInput == 0xC3 ) && ( index + 1 < [self length] ) )
        {
            // Check for german umlauts and french accents that are UTF8 but have incorrectly
            // been translated as Latin1 (ISO 8859-1) or ASCII.
            unichar const char2Input = [self characterAtIndex:index+1];
            if ( ( char2Input >= 0x80 ) && ( char2Input <= 0xbf ) )
            {
                return true;
            }
        }
    }
    return false;
}

- (BOOL)stringContainsEmoji
{
    __block BOOL returnValue = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    
    return returnValue;
}

- (NSArray *)sy_componentsSeparatedByString:(NSString *)sperator
{
    if (self.length > 0) {
        return [self componentsSeparatedByString:sperator];
    } else {
        return [NSArray array];
    }
}

- (NSString *)validString
{
    return [self length] > 0 ? self : @"";
}

- (NSString *)stringValue
{
    return self;
}

- (NSString *)decodeUrl
{
    NSString *result = [(NSString *)self stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return result;
}

+ (NSString *)validString:(NSString *)str
{
    if (!str || [str isKindOfClass:[NSNull class]]) {
        return @"";
    }
    return str.length > 0 ? str : @"";
}

+ (bool)isNumeric:(NSString *)checkText
{
    return [[NSScanner scannerWithString:checkText] scanFloat:NULL];
}

+ (NSString *)privateTel:(NSString *)tel
{
    if (tel.length > 4) {
        return [tel stringByReplacingCharactersInRange:NSMakeRange(tel.length - 4, 4) withString:@"****"];
    } else {
        return @"****";
    }
}

/**
 *  临时方案：
 *  Model中定义的数组字段，如果后台未传该字段，Mantle默认会转换成NSString, 给NSString 加上一个count放置crash
 *
 *  @return 0
 */
-(NSInteger) count
{
    return 0;
}

- (CGFloat)textHeightWithFontSize:(CGFloat) fontSize ViewWidth:(CGFloat) width
{
    if (self.length == 0) return 0;
    NSAttributedString *line = [[NSAttributedString alloc] initWithString:self
                                                               attributes:@{
                                                                            NSFontAttributeName: Font(fontSize)
                                                                            }];
    CGRect rect = [line boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                                                   options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                   context:nil];
    return ceil(rect.size.height);
}

- (CGFloat) textWidthWithFontsSize:(CGFloat)fontSize
{
    if (self.length == 0) return 0;
    NSAttributedString *line = [[NSAttributedString alloc] initWithString:self
                                                               attributes:@{
                                                                            NSFontAttributeName: Font(fontSize)
                                                                            }];
    CGRect rect = [line boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                     context:nil];
    return ceil(rect.size.width);
}

- (NSMutableAttributedString *)attributedStringWithLineSpacing:(CGFloat) spacing
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:spacing];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self length])];
    return attributedString;
}

- (NSMutableAttributedString *)attributedStringWithLineSpacing:(CGFloat) spacing Alignment:(NSTextAlignment) alignment
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:spacing];
    [paragraphStyle setAlignment:alignment];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self length])];
    return attributedString;
}

@end
