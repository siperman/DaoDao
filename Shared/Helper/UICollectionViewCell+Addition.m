//
//  UICollectionViewCell+Addition.m
//  Soouya
//
//  Created by hetao on 2/29/16.
//  Copyright © 2016 Soouya. All rights reserved.
//

#import "UICollectionViewCell+Addition.h"

@implementation UICollectionViewCell (Addition)

+ (NSString *)defaultReuseIdentifier
{
    return NSStringFromClass(self);
}

+ (NSString *)defaultNibName
{
    return NSStringFromClass(self);
}

@end
