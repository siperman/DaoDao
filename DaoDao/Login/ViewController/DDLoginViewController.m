//
//  DDLoginViewController.m
//  DaoDao
//
//  Created by hetao on 16/9/8.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDLoginViewController.h"
#import "NSTimer+Addition.h"
#import "NSString+MD5Addition.h"
#import "LoginViewModel.h"

@interface DDLoginViewController ()
@property (weak, nonatomic) IBOutlet UIView *bigView;
@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
@property (weak, nonatomic) IBOutlet UITextField *txtAuthCode;
@property (weak, nonatomic) IBOutlet UIButton *btnAuthCode;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;

@property (nonatomic, strong) NSTimer *countDownTimer;
@property (nonatomic) NSInteger leftTime;
@property (nonatomic, strong) LoginViewModel *viewModel;
@end

@implementation DDLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录道道";

    [self.txtPhone normalStyle];
    [self.txtAuthCode normalStyle];
    [self.bigView shadowStyle];
    [self.btnLogin actionStyle];
    [self.btnAuthCode.titleLabel setFont:BigTextFont];

    self.viewModel = [[LoginViewModel alloc] init];

    // 监听输入框
    RAC(self.viewModel, phone) = self.txtPhone.rac_textSignal;
    RAC(self.viewModel, code) = self.txtAuthCode.rac_textSignal;
    RAC(self.btnLogin, enabled) = self.viewModel.enableLoginSignal;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - Data

- (IBAction)requestAuthCode:(id)sender
{
    if (self.leftTime <= 1) {
        [self startCoundDown];
    }

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
    self.btnAuthCode.enabled = NO;

    [self.btnAuthCode.titleLabel setFont:BigTextFont];

    self.leftTime = kVerifyCodeWaitingDuration;

    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];

    [self.countDownTimer resumeTimer];
}

- (void)updateTime
{
    if (self.leftTime > 1) {

        self.leftTime--;

        [UIView performWithoutAnimation:^{
            [self.btnAuthCode setTitle:[NSString stringWithFormat:@"%@s", @(self.leftTime)]];
            [self.btnAuthCode layoutIfNeeded];
        }];
    } else {
        [self resetTimer];
    }
}

- (void)resetTimer
{
    [self.countDownTimer pauseTimer];

    [UIView performWithoutAnimation:^{
        self.btnAuthCode.enabled = YES;
        [self.btnAuthCode.titleLabel setFont:SmallTextFont];
        [self.btnAuthCode setTitle:@"重新获取验证码"];
        [self.btnAuthCode layoutIfNeeded];
    }];
}

- (IBAction)login:(UIButton *)sender
{
    NSLog(@"login");
//    [self showLoadingHUD];
//
//    sleep(1000);
//    [self hideAllHUD];
//    DDUser *user = [[DDUser alloc] init];
//    user.nickname = @"nickname";
//    user.uid = @"123456";
//    [DDUserManager manager].user = user;
//    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
