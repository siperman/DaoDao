//
//  UILabel+Addition.m
//  DaoDao
//
//  Created by hetao on 16/9/14.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "UILabel+Addition.h"

@implementation UILabel (Addition)

- (void)bigSecondStyle
{
    self.textColor = SecondColor;
    self.font = BigTextFont;
}

- (void)bigMainStyle
{
    self.textColor = SecondColor;
    self.font = BigTextFont;
}

- (void)normalTextStyle
{
    self.textColor = TextColor;
    self.font = NormalTextFont;
}

@end
