//
//  UITableViewCell+Addition.m
//  Soouya
//
//  Created by hetao on 1/20/16.
//  Copyright © 2016 Soouya. All rights reserved.
//

#import "UITableViewCell+Addition.h"

@implementation UITableViewCell (Addition)

+ (NSString *)defaultReuseIdentifier
{
    return NSStringFromClass(self);
}

+ (NSString *)defaultNibName
{
    return NSStringFromClass(self);
}

@end
