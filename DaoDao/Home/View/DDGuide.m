//
//  DDGuide.m
//  DaoDao
//
//  Created by hetao on 2016/11/29.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDGuide.h"

@interface DDGuide ()
@property (nonatomic) DDGuideType type;
@end

@implementation DDGuide

//- (instancetype)initWithFrame:(CGRect)frame {
//    if (self = [super initWithFrame:frame]) {
//        [self setup];
//    }
//    return self;
//}

- (void)setupWithGuideType:(DDGuideType)type
{
    NSArray *imgNames = @[@"DDGuideHome",
                          @"DDGuideSettingTimeOne",
                          @"DDGuideSettingTimeTwo",
                          @"DDGuideMine",
                          @"DDGuideIM"];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:Image(imgNames[type])];
    [imgView setSize:self.size];
    [self addSubview:imgView];
    imgView.center = self.center;

    [self addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
}

+ (void)showWithGuideType:(DDGuideType)type
{
    DDGuide *view = [[DDGuide alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    view.backgroundColor = ClearColor;
    [view setupWithGuideType:type];
    [view display];
}

- (void)display
{
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
                         if (_type == DDGuideSettingTimeOne) {
                             [DDGuide showWithGuideType:DDGuideSettingTimeTwo];
                         }
                     }];
}

@end
