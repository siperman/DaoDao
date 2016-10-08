//
// Created by Shaokang Zhao on 15/1/12.
// Copyright (c) 2015 Shaokang Zhao. All rights reserved.
//

#import "SKTag.h"

@implementation SKTag

- (instancetype)initWithText:(NSString *)text
{
    self = [super init];
    if (self)
    {
        _text = text;
        _fontSize = 14;
        _textColor = [UIColor blackColor];
        _bgColor = [UIColor whiteColor];
        _enable = YES;
        
        CGFloat leftMargin = 10.0;
        CGFloat topMargin = 8.0;
        _padding = UIEdgeInsetsMake(topMargin, leftMargin, topMargin, leftMargin);
    }
    
    return self;
}

+ (instancetype)tagWithText:(NSString *)text
{
    return [[self alloc] initWithText:text];
}

@end