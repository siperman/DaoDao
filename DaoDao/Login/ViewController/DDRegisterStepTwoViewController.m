//
//  DDRegisterStepTwoViewController.m
//  DaoDao
//
//  Created by hetao on 16/9/14.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDRegisterStepTwoViewController.h"
#import "DDRegisterStepThreeViewController.h"
#import "NSTimer+Addition.h"
#import "DDMajorGradePickerView.h"
#import "DDConfig.h"

@interface DDRegisterStepTwoViewController () <UITextFieldDelegate, DDMajorGradePickerProtocol>

@property (weak, nonatomic) IBOutlet UIView *bigView;
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtSchool;
@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
@property (weak, nonatomic) IBOutlet UITextField *txtAuthCode;

@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UILabel *labSchool;
@property (weak, nonatomic) IBOutlet UILabel *labPhone;
@property (weak, nonatomic) IBOutlet UILabel *labCode;

@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UIButton *btnAuthCode;

@property (nonatomic, strong) NSTimer *countDownTimer;
@property (nonatomic) NSInteger leftTime;

@end

@implementation DDRegisterStepTwoViewController

+ (instancetype)viewController
{
    DDRegisterStepTwoViewController *vc = [[SYStoryboardManager manager].loginSB instantiateViewControllerWithIdentifier:@"DDRegisterStepTwoViewController"];

    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"注册道道";
    self.view.backgroundColor = BackgroundColor;
    [@[self.labName, self.labSchool, self.labPhone, self.labCode]
     enumerateObjectsUsingBlock:^(UILabel *lab, NSUInteger idx, BOOL * _Nonnull stop) {
         [lab bigSecondStyle];
     }];

    [@[self.txtName, self.txtSchool, self.txtPhone, self.txtAuthCode]
     enumerateObjectsUsingBlock:^(UITextField *obj, NSUInteger idx, BOOL * _Nonnull stop) {
         [obj normalStyle];
         obj.delegate = self;
     }];


    [self.bigView shadowStyle];
    [self.btnNext actionStyle];

    if (_user) {
//        self.txtName.text = _user.realName;
//        self.txtSchool.text = MajorGrade(_user.major, _user.grade);
    } else {
        _user = [[DDUser alloc] init];
    }

    RAC(self.user, realName) = self.txtName.rac_textSignal;
    RAC(self.user, mobilePhone) = self.txtPhone.rac_textSignal;
    RAC(self.btnNext, enabled) =  [RACSignal combineLatest:@[self.txtName.rac_textSignal,
                                                             self.txtSchool.rac_textSignal,
                                                             self.txtPhone.rac_textSignal,
                                                             self.txtAuthCode.rac_textSignal]
                                                    reduce:^id(NSString *name,NSString *school,NSString *phone,NSString *code){
        return @(name.length && school.length && phone.length && code.length);
    }];

    [self checkConfig];
}

- (IBAction)next:(UIButton *)sender
{
    [self.view endEditing:YES];
    if (self.txtName.text.length > 4) {
        [self showNotice:@"姓名最多输入4个汉字喔！"];
        return;
    }

    [self.navigationController showLoadingHUD];
    [SYRequestEngine checkVerifyCode:self.txtPhone.text code:self.txtAuthCode.text callback:^(BOOL success, id response) {
        [self.navigationController hideAllHUD];
        if (success) {
            DDRegisterStepThreeViewController *vc = [DDRegisterStepThreeViewController viewController];
            vc.inviteCode = self.inviteCode;
            vc.user = self.user;
            vc.authCode = self.txtAuthCode.text;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [self.navigationController showRequestNotice:response];
        }
    }];
}

#pragma mark - Data

- (IBAction)requestAuthCode:(id)sender
{
    if (self.leftTime <= 1) {
        if ([self checkInput:self.txtPhone.text valueForType:kPhoneKey]) {

            [self.navigationController showLoadingHUD];

            [SYRequestEngine requestVerifyCodeWithParams:@{
                                                           @"inviteCode" : self.inviteCode,
                                                           @"mobilePhone" : self.txtPhone.text,
                                                           @"key" : [self.txtPhone.text stringFromMD5],
                                                           @"type" : @"sms",
                                                           }
                                                callback:^(BOOL success, id response) {
                                                    if (success) {
                                                        [self startCoundDown];
                                                    }

                                                    [self.navigationController showRequestNotice:response];
                                                }];
        }
    }
}

- (void)checkConfig
{
    if ([DDConfig configDict]) {
        return;
    }
    [self showLoadingHUD];
    [SYRequestEngine requestConfigCallback:^(BOOL success, id response) {
        [self hideAllHUD];
        if (success) {
            [DDConfig saveConfigDict:response[kObjKey]];
        } else {
            [self showNotice:response];
        }
    }];
}

#pragma mark - SMS verify

- (void)startCoundDown
{
    [self.btnAuthCode.titleLabel setFont:BigTextFont];

    self.leftTime = kVerifyCodeWaitingDuration;

    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];

    [self.countDownTimer resumeTimer];
}

- (void)updateTime
{
    if (self.leftTime > 1) {
        [self.btnAuthCode setTitleColor:TextColor];
        self.leftTime--;

        [UIView performWithoutAnimation:^{
            [self.btnAuthCode setTitle:[NSString stringWithFormat:@"%@s", @(self.leftTime)]];
            [self.btnAuthCode layoutIfNeeded];
        }];
    } else {
        [self.btnAuthCode setTitleColor:SecondColor];
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

#pragma mark UITextFiledDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.txtSchool) {
        DDMajorGradePickerView *pv = [DDMajorGradePickerView majorGradePickerWithDelegate:self];
        textField.inputView = pv;
        if (textField.text.length > 0) {
            [pv pickedMajor:_user.major grade:_user.grade];
        }
        textField.tintColor = ClearColor;
        return YES;
    }

    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.txtName) {
        /*
         * 在iOS9.3.5上，中文联想输入不进入此函数
         */
        NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
        return text.length <= 4 || text.length < textField.text.length;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

#pragma mark DDMajorGradePickerProtocol

- (void)pickedMajor:(NSString *)major grade:(NSNumber *)grade
{
    _user.major = major;
    _user.grade = grade;
    self.txtSchool.text = MajorGrade(_user.major, _user.grade);
    [self.txtSchool endEditing:YES];
}

@end
