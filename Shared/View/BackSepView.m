//
//  BackSepView.m
//  DaoDao
//
//  Created by hetao on 2016/10/26.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "BackSepView.h"

@implementation BackSepView

- (instancetype)init
{
    self = [super init];

    self.layer.cornerRadius = kCornerRadius;
    self.backgroundColor = WhiteColor;
    _sepColor = SepColor;

    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    self.layer.cornerRadius = kCornerRadius;
    self.backgroundColor = WhiteColor;
    _sepColor = SepColor;

    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.layer.cornerRadius = kCornerRadius;
    self.backgroundColor = WhiteColor;

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

    CGContextMoveToPoint(context, 10.0f, self.height - lineWidth); //start at this point

    CGContextAddLineToPoint(context, self.width - 10.0f, self.height - lineWidth); //draw to this point

    
    // and now draw the Path!
    CGContextStrokePath(context);
}



@end
