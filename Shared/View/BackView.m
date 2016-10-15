//
//  BackView.m
//  DaoDao
//
//  Created by hetao on 2016/10/8.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "BackView.h"

@implementation BackView

- (instancetype)init
{
    self = [super init];

    [self shadowStyle];

    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    [self shadowStyle];

    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    [self shadowStyle];
}

@end
