//
//  DDRegisterStepOneViewController.m
//  DaoDao
//
//  Created by hetao on 16/9/14.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDRegisterStepOneViewController.h"
#import "DDRegisterStepTwoViewController.h"

@interface DDRegisterStepOneViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtCode;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UIButton *btnForget;

@property (nonatomic, strong) NSString *inviteCode;
@end

@implementation DDRegisterStepOneViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"注册道道";
    [self.btnNext actionStyle];
    [self.btnForget textStyle];
    self.txtCode.layer.cornerRadius = kCornerRadius;
    self.txtCode.backgroundColor = BackgroundColor;

    self.txtCode.delegate = self;
    RAC(self, inviteCode) = self.txtCode.rac_textSignal;
    RAC(self.btnNext, enabled) = [RACSignal combineLatest:@[RACObserve(self, inviteCode)] reduce:^(NSString *inviteCode){
        return @(inviteCode.length > 0);
    }];
}

- (IBAction)next:(UIButton *)sender
{
    [self showLoadingHUD];
    [SYRequestEngine requestUserWithId:self.inviteCode callback:^(BOOL success, id response) {
        [self hideAllHUD];
        if (success) {
            DDUser *user = [DDUser fromDict:response[kObjKey]];
            DDRegisterStepTwoViewController *vc = [DDRegisterStepTwoViewController viewController];
            vc.user = user;
            vc.inviteCode = self.inviteCode;

            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [self showRequestNotice:response];
        }
    }];
}

- (IBAction)forgetCode:(UIButton *)sender
{
    RIButtonItem *cancel = [RIButtonItem itemWithLabel:@"取消"];
    RIButtonItem *call = [RIButtonItem itemWithLabel:@"拨号" action:^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", kServiceCall]]];
    }];

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请拨打道道客服电话找回邀请码"
                                                    message:kServiceCall
                                           cancelButtonItem:cancel
                                           otherButtonItems:call, nil];
    [alert show];
}

#pragma UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

@end
