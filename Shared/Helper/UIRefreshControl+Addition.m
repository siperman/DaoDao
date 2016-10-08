//
//  UIRefreshControl+Addition.m
//  Soouya
//
//  Created by hetao on 3/3/16.
//  Copyright © 2016 Soouya. All rights reserved.
//

#import "UIRefreshControl+Addition.h"

@implementation UIRefreshControl (Addition)

- (void)endRefreshingSmoothly
{
    [self performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.1];
}

@end
