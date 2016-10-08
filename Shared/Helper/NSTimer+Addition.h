//
//  NSTimer+Addition.h
//  ifanr
//
//  Created by hetao on 5/29/14.
//  Copyright (c) 2014 hetao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Addition)

- (void)pauseTimer;
- (void)resumeTimer;
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval;

@end
