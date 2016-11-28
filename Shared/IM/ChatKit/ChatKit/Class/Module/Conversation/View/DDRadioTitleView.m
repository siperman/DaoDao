//
//  DDRadioTitleView.m
//  DaoDao
//
//  Created by hetao on 2016/11/28.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDRadioTitleView.h"

@interface DDRadioTitleView ()
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation DDRadioTitleView

+ (instancetype)shareTitleView{
    static dispatch_once_t onceToken;
    static id shareInstance;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    });
    return shareInstance;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
        self.backgroundColor = MainColor;
    }
    return self;
}

- (void)setup{
    UIImageView *imgView = [[UIImageView alloc] initWithImage:Image(@"icon_erduo")];
    [imgView setSize:imgView.size];
    [self addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.leading.equalTo(self).offset(12);
    }];

    UILabel *lab = [[UILabel alloc] init];
    lab.backgroundColor = ClearColor;
    lab.text = @"当前为听筒播放模式";
    lab.textColor = WhiteColor;
    lab.font = BigTextFont;
    [self addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(imgView.mas_trailing).offset(10);
        make.centerY.equalTo(self);
    }];

    UIButton *btn = [[UIButton alloc] init];
    [btn sy_setImage:Image(@"icon_x")];
    [btn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.trailing.equalTo(self).offset(-12);
    }];
    [self timer];
}

+ (void)showIn:(UIView *)view
{
    DDRadioTitleView *titleView = [self shareTitleView];
    [titleView timer];

    if (titleView.superview == view) {
        return;
    }
    [view addSubview:titleView];
    titleView.alpha = 0;
    [UIView animateWithDuration:kAnimationDuration
                     animations:^{
                         titleView.alpha = 0.9;
                     }];
}

- (void)dismiss
{
    [UIView animateWithDuration:kAnimationDuration * 2
                          delay:0
                        options:UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
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
