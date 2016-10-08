//
//  DDForgetCodeNoticeView.m
//  DaoDao
//
//  Created by hetao on 16/9/18.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDForgetCodeNoticeView.h"
#import "NSTimer+Addition.h"

@interface DDForgetCodeNoticeView ()

@property (weak, nonatomic) IBOutlet UILabel *labContent;
@property (weak, nonatomic) IBOutlet UITextField *txtCode;
@property (weak, nonatomic) IBOutlet UIButton *btnSend;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnDone;

@property (nonatomic, strong) NSTimer *countDownTimer;
@property (nonatomic) NSInteger leftTime;

@end

@implementation DDForgetCodeNoticeView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.labContent bigMainStyle];
    [self.txtCode normalStyle];
    [self.btnSend actionTransparentStyle];
    [self.btnCancel textStyle];
    [self.btnDone textSencondStyle];
}

#pragma mark - Data

- (IBAction)requestAuthCode:(id)sender
{
    [self startCoundDown];

    //    if ([self checkInput:self.txtPhone.text valueForType:kUserName]) {
    //
    //        [self.navigationController showLoadingHUD];
    //
    //        [SYRequestEngine requestVerifyCodeWithParams:@{
    //                                                       @"mobilePhone" : self.txtPhone.text,
    //                                                       @"key" : [self.txtPhone.text stringFromMD5],
    //                                                       @"type" : @"sms",
    //                                                       }
    //                                            callback:^(BOOL success, NSInteger httpCode, id response) {
    //                                                if (success) {
    //                                                    [self startCoundDown];
    //                                                }
    //
    //                                                [self.navigationController showRequestNotice:response];
    //                                            }];
    //    }
}

#pragma mark - SMS verify

- (void)startCoundDown
{
    self.btnSend.enabled = NO;

    [self.btnSend.titleLabel setFont:BigTextFont];

    self.leftTime = kVerifyCodeWaitingDuration;

    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];

    [self.countDownTimer resumeTimer];
}

- (void)updateTime
{
    if (self.leftTime > 1) {

        self.leftTime--;

        [UIView performWithoutAnimation:^{
            [self.btnSend setTitle:[NSString stringWithFormat:@"%@s", @(self.leftTime)]];
            [self.btnSend layoutIfNeeded];
        }];
    } else {
        [self resetTimer];
    }
}

- (void)resetTimer
{
    [self.countDownTimer pauseTimer];

    [UIView performWithoutAnimation:^{
        self.btnSend.enabled = YES;
        [self.btnSend.titleLabel setFont:SmallTextFont];
        [self.btnSend setTitle:@"获取验证码"];
        [self.btnSend layoutIfNeeded];
    }];
}

- (void)show
{
    self.bounds = SCREEN_BOUNDS;
    self.top = 0.0;
    self.left = 0.0;

    [self layoutIfNeeded];

    [APP_DELEGATE.window addSubview:self];

    [UIView animateWithDuration:kAnimationDuration
                     animations:^{
                         self.backgroundColor = Color(0, 0, 0, 0.8);
                         [self layoutIfNeeded];
                     }];
}

@end
