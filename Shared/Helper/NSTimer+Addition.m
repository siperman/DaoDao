//
//  NSTimer+Addition.m
//  ifanr
//
//  Created by hetao on 5/29/14.
//  Copyright (c) 2014 hetao. All rights reserved.
//

#import "NSTimer+Addition.h"

@implementation NSTimer (Addition)

- (void)pauseTimer
{
    if (![self isValid]) {
        return;
    }
    [self setFireDate:[NSDate distantFuture]];
}

- (void)resumeTimer
{
    if (![self isValid]) {
        return;
    }
    [self setFireDate:[NSDate date]];
}

- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval
{
    if (![self isValid]) {
        return;
    }
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}

@end
