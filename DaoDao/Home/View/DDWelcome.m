//
//  DDWelcome.m
//  DaoDao
//
//  Created by hetao on 2016/11/7.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDWelcome.h"

@interface DDWelcome ()

@property (strong, nonatomic) NSTimer *timer;

@end

@implementation DDWelcome

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup{
    UIImageView *imgView = [[UIImageView alloc] initWithImage:Image(@"welcome")];
    [imgView setSize:imgView.size];
    [self addSubview:imgView];
    imgView.center = self.center;

    [self addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
}


+ (void)show
{
    DDWelcome *view = [[DDWelcome alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [view display];
}

- (void)display
{
    [self timer];
    dispatch_async(dispatch_get_main_queue(), ^{
        if(!self.superview)
            [[[UIApplication sharedApplication] keyWindow] addSubview:self];
        [UIView animateWithDuration:kAnimationDuration animations:^{
            self.alpha = 1;
        } completion:nil];
        [self setNeedsDisplay];
    });
}

- (void)dismiss
{
    [UIView animateWithDuration:kAnimationDuration
                          delay:0
                        options:UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                         [DDGuide showWithGuideType:DDGuideHome];
                     }];
}

#pragma mark - Getters

- (NSTimer *)timer{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:2
                                              target:self
                                            selector:@selector(dismiss)
                                            userInfo:nil
                                             repeats:NO];
    return _timer;
}

@end
