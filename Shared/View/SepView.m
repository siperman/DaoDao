//
//  SepView.m
//  DaoDao
//
//  Created by hetao on 16/9/6.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "SepView.h"

@implementation SepView


- (instancetype)init
{
    self = [super init];

    self.backgroundColor = ClearColor;
    _sepColor = SepColor;

    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    self.backgroundColor = ClearColor;
    _sepColor = SepColor;

    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.backgroundColor = ClearColor;

    if (!self.sepColor) {
        self.sepColor = SepColor;
    }

    [self setNeedsDisplay];
}

- (void)setSepColor:(UIColor *)sepColor
{
    _sepColor = sepColor;

    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, self.sepColor.CGColor);

    // Draw them with a 2.0 stroke width so they are a bit more visible.

    CGFloat lineWidth = 1 / [UIScreen mainScreen].scale;

    CGContextSetLineWidth(context, lineWidth);

    if (self.height < self.width) {
        CGContextMoveToPoint(context, 0.0f, self.height / 2); //start at this point

        CGContextAddLineToPoint(context, self.width, self.height / 2); //draw to this point
    } else {
        CGContextMoveToPoint(context, self.width / 2, 0.0f); //start at this point

        CGContextAddLineToPoint(context, self.width / 2, self.height); //draw to this point
    }

    // and now draw the Path!
    CGContextStrokePath(context);
}


@end
