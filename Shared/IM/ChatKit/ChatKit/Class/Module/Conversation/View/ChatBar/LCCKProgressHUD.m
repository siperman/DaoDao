//
//  LCCKProgressHUD.m
//  LCCKChatBarExample
//
//  v0.7.20 Created by ElonChan (微信向我报BUG:chenyilong1010) ( https://github.com/leancloud/ChatKit-OC ) on 15/8/17.
//  Copyright (c) 2015年 https://LeanCloud.cn . All rights reserved.
//

#import "LCCKProgressHUD.h"
#import "UIImage+LCCKExtension.h"

#define kVoiceRecordPauseString @"手指上滑，取消发送"
#define kVoiceRecordResaueString @"松开手指，取消发送"

@interface LCCKProgressHUD ()

@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) LCCKProgressState progressState;
@property (assign, nonatomic) NSTimeInterval seconds;
@property (nonatomic, strong) UIImageView *microPhoneImageView;
@property (nonatomic, strong) UIImageView *cancelRecordImageView;
@property (nonatomic, strong) UIImageView *recordingHUDImageView;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UILabel *centerLabel;
@property (nonatomic, strong) UIView *centerBackView;

@property (nonatomic, strong, readonly) UIWindow *overlayWindow;

@property (nonatomic) BOOL recording;
@property (nonatomic) BOOL countdowning;
@end

@implementation LCCKProgressHUD
@synthesize overlayWindow = _overlayWindow;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup{
    [self addSubview:self.centerBackView];
    [self.centerBackView addSubview:self.subTitleLabel];
    [self.centerBackView addSubview:self.centerLabel];

    [self.centerBackView addSubview:self.microPhoneImageView];
    [self.centerBackView addSubview:self.recordingHUDImageView];
    [self.centerBackView addSubview:self.cancelRecordImageView];
}

#pragma mark - Private Methods

- (void)show {
    self.seconds = 0;
    self.subTitleLabel.text = kVoiceRecordPauseString;
    self.centerLabel.hidden = YES;
    self.countdowning = NO;
    [self configRecoding:YES];

    [self timer];
    dispatch_async(dispatch_get_main_queue(), ^{
        if(!self.superview)
            [self.overlayWindow addSubview:self];
        [UIView animateWithDuration:.5 animations:^{
                self.alpha = 1;
        } completion:nil];
        [self setNeedsDisplay];
    });
}

- (void)timerAction {
    self.seconds ++ ;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.09];
    UIView.AnimationRepeatAutoreverses = YES;
    float second = 60 - self.seconds;
    if (second <= 9.0f) {
        _countdowning = YES;
        self.centerLabel.hidden = !_recording;
        self.microPhoneImageView.hidden = _countdowning;
        self.recordingHUDImageView.hidden = _countdowning;
    } else {
        self.centerLabel.hidden = YES;
    }
    self.centerLabel.text = [NSString stringWithFormat:@"%1.0f",second];
    [UIView commitAnimations];
}

- (void)setSubTitle:(NSString *)subTitle {
    self.subTitleLabel.text = subTitle;
}

- (void)pauseRecord {
    [self configRecoding:YES];
    self.subTitleLabel.backgroundColor = [UIColor clearColor];
    self.subTitleLabel.text = kVoiceRecordPauseString;
}

- (void)resaueRecord {
    [self configRecoding:NO];
    self.subTitleLabel.backgroundColor = [UIColor colorWithRed:1.000 green:0.000 blue:0.000 alpha:0.630];
    self.subTitleLabel.text = kVoiceRecordResaueString;
}

- (void)configRecoding:(BOOL)recording {
    _recording = recording;
    self.microPhoneImageView.hidden = _countdowning || !recording;
    self.recordingHUDImageView.hidden = _countdowning || !recording;
    self.centerLabel.hidden = !_countdowning || !recording;
    self.cancelRecordImageView.hidden = recording;
}

- (void)dismiss{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_timer) {
            [_timer invalidate];
            _timer = nil;
        }
        self.subTitleLabel.text = nil;

        CGFloat timeLonger;
        if (self.progressState == LCCKProgressShort) {
            timeLonger = 1;
        } else {
            timeLonger = 0.6;
        }
        [UIView animateWithDuration:timeLonger
                              delay:0
                            options:UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             self.alpha = 0;
                         }
                         completion:^(BOOL finished){
                             if(self.alpha == 0) {
                                 [self pauseRecord];
                                 [self removeFromSuperview];
                             }
                         }];
    });
}


#pragma mark - Setters

- (void)setProgressState:(LCCKProgressState)progressState {
    switch (progressState) {
        case LCCKProgressSuccess:
            self.subTitleLabel.text = @"录音成功";
            break;
        case LCCKProgressShort:
            self.subTitleLabel.text = @"时间太短,请重试";
            break;
        case LCCKProgressError:
            self.subTitleLabel.text = @"录音失败";
            break;
        case LCCKProgressMessage:
            break;
    }
}

- (void)configRecordingHUDImageWithPeakPower:(CGFloat)peakPower {
    NSString *imageName = @"RecordingSignal00";
    if (peakPower >= 0 && peakPower <= 0.1) {
        imageName = [imageName stringByAppendingString:@"1"];
    } else if (peakPower > 0.1 && peakPower <= 0.2) {
        imageName = [imageName stringByAppendingString:@"2"];
    } else if (peakPower > 0.3 && peakPower <= 0.4) {
        imageName = [imageName stringByAppendingString:@"3"];
    } else if (peakPower > 0.4 && peakPower <= 0.5) {
        imageName = [imageName stringByAppendingString:@"4"];
    } else if (peakPower > 0.5 && peakPower <= 0.6) {
        imageName = [imageName stringByAppendingString:@"5"];
    } else if (peakPower > 0.7 && peakPower <= 0.8) {
        imageName = [imageName stringByAppendingString:@"6"];
    } else if (peakPower > 0.8 && peakPower <= 0.9) {
        imageName = [imageName stringByAppendingString:@"7"];
    } else if (peakPower > 0.9 && peakPower <= 1.0) {
        imageName = [imageName stringByAppendingString:@"8"];
    }
    self.recordingHUDImageView.image = [UIImage imageNamed:imageName];
}

#pragma mark - Getters

- (NSTimer *)timer{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:1
                                               target:self
                                             selector:@selector(timerAction)
                                             userInfo:nil
                                              repeats:YES];
    return _timer;
}

- (UILabel *)subTitleLabel{
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 120.0, 130.0, 20.0)];
        _subTitleLabel.text = kVoiceRecordPauseString;
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        _subTitleLabel.font = [UIFont boldSystemFontOfSize:13];
        _subTitleLabel.textColor = [UIColor whiteColor];
        _subTitleLabel.clipsToBounds = YES;
        _subTitleLabel.layer.cornerRadius = kCornerRadius;
    }
    return _subTitleLabel;
}

- (UILabel *)centerLabel{
    if (!_centerLabel) {
        _centerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20.0, 130.0, 90.0)];
        _centerLabel.text = @"9";
        _centerLabel.textAlignment = NSTextAlignmentCenter;
        _centerLabel.font = [UIFont boldSystemFontOfSize:90];
        _centerLabel.textColor = [UIColor whiteColor];
        _centerLabel.backgroundColor = [UIColor clearColor];
        _centerLabel.hidden = YES;
    }
    return _centerLabel;
}

- (UIImageView *)microPhoneImageView
{
    if (!_microPhoneImageView) {
        UIImageView *microPhoneImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30.0, 15.0, 50.0, 99.0)];
        microPhoneImageView.image = [UIImage imageNamed:@"RecordingBkg"];
        microPhoneImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        microPhoneImageView.contentMode = UIViewContentModeScaleToFill;
        _microPhoneImageView = microPhoneImageView;
    }
    return _microPhoneImageView;
}

- (UIImageView *)recordingHUDImageView
{
    if (!_recordingHUDImageView) {
        UIImageView *recordHUDImageView = [[UIImageView alloc] initWithFrame:CGRectMake(90.0, 38.0, 18.0, 61.0)];
        recordHUDImageView.image = [UIImage imageNamed:@"RecordingSignal001"];
        recordHUDImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        recordHUDImageView.contentMode = UIViewContentModeScaleToFill;
        _recordingHUDImageView = recordHUDImageView;
    }
    return _recordingHUDImageView;
}

- (UIImageView *)cancelRecordImageView
{
    if (!_cancelRecordImageView) {
        UIImageView *cancelRecordImageView = [[UIImageView alloc] initWithFrame:CGRectMake(25.0, 10.0, 100.0, 100.0)];
        cancelRecordImageView.image = [UIImage imageNamed:@"RecordCancel"];
        cancelRecordImageView.hidden = YES;
        cancelRecordImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        cancelRecordImageView.contentMode = UIViewContentModeScaleToFill;
        _cancelRecordImageView = cancelRecordImageView;
    }
    return _cancelRecordImageView;
}

- (UIView *)centerBackView
{
    if (!_centerBackView) {
        _centerBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
        _centerBackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        _centerBackView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        _centerBackView.layer.cornerRadius = 6;
    }
    return _centerBackView;
}

- (UIWindow *)overlayWindow {
    return [[UIApplication sharedApplication] keyWindow];
}

#pragma mark - Class Methods

+ (LCCKProgressHUD *)sharedView {
    static dispatch_once_t once;
    static LCCKProgressHUD *sharedView;
    dispatch_once(&once, ^ {
        sharedView = [[LCCKProgressHUD alloc] initWithFrame:SCREEN_BOUNDS];
        sharedView.backgroundColor = ClearColor;
    });
    return sharedView;
}

+ (void)show {
    [[LCCKProgressHUD sharedView] show];
}

+ (void)dismissWithProgressState:(LCCKProgressState)progressState {
    [[LCCKProgressHUD sharedView] setProgressState:progressState];
    [[LCCKProgressHUD sharedView] dismiss];
}

+ (void)dismissWithMessage:(NSString *)message {
    [[LCCKProgressHUD sharedView] setProgressState:LCCKProgressMessage];
    [LCCKProgressHUD sharedView].subTitleLabel.text = message;
    [[LCCKProgressHUD sharedView] dismiss];
}

+ (void)changeSubTitle:(NSString *)str
{
    [[LCCKProgressHUD sharedView] setSubTitle:str];
}

+ (void)pauseRecord
{
    [[LCCKProgressHUD sharedView] pauseRecord];
}

+ (void)resaueRecord
{
    [[LCCKProgressHUD sharedView] resaueRecord];
}

+ (void)peakPowerForChannel:(CGFloat)power
{
    [[LCCKProgressHUD sharedView] configRecordingHUDImageWithPeakPower:power];
}

+ (NSTimeInterval)seconds{
    return [[LCCKProgressHUD sharedView] seconds];
}

@end
