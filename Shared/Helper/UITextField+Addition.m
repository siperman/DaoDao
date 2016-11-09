//
//  UITextField+Addition.m
//  DaoDao
//
//  Created by hetao on 16/9/14.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "UITextField+Addition.h"

@implementation UITextField (Addition)

- (void)normalStyle
{
    self.textColor = MainColor;
    self.font = NormalTextFont;
    self.layer.borderColor = SecondColor.CGColor;
    self.borderStyle = UITextBorderStyleNone;
}
@end
