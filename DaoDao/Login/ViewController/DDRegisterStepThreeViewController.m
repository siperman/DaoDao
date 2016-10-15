//
//  DDRegisterStepThreeViewController.m
//  DaoDao
//
//  Created by hetao on 16/9/14.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDRegisterStepThreeViewController.h"
#import "DDChooseFavGoodViewController.h"
#import "DDFillJobIndustryViewController.h"
#import "SYCameraManager.h"

@interface DDRegisterStepThreeViewController () <UITextFieldDelegate, DDChooseFavGoodViewControllerProtocol>

@property (weak, nonatomic) IBOutlet UIButton *btnAvatar;
@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UIView *bigView;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;

@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtJob;
@property (weak, nonatomic) IBOutlet UITextField *txtIndustry;
@property (weak, nonatomic) IBOutlet UITextField *txtYear;

@property (nonatomic, strong) NSString *topic; // 感兴趣话题
@property (nonatomic, strong) NSString *expert; // 擅长领域
@end

@implementation DDRegisterStepThreeViewController

+ (instancetype)viewController
{
    DDRegisterStepThreeViewController *vc = [[SYStoryboardManager manager].loginSB instantiateViewControllerWithIdentifier:@"DDRegisterStepThreeViewController"];

    return vc;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"注册道道";
    [self.labName normalTextStyle];
    [self.bigView shadowStyle];
    [self.btnNext actionStyle];

    [@[self.txtName, self.txtJob, self.txtIndustry, self.txtYear] enumerateObjectsUsingBlock:^(UITextField *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj normalStyle];
        obj.delegate = self;
    }];

    RAC(self.user, nickName) = self.txtName.rac_textSignal;
    RAC(self.user, year) = self.txtYear.rac_textSignal;
    RAC(self.btnNext, enabled) =  [RACSignal combineLatest:@[self.txtName.rac_textSignal,
                                                             RACObserve(self.txtJob, text),
                                                             RACObserve(self.txtIndustry, text),
                                                             self.txtYear.rac_textSignal]
                                                    reduce:^id(NSString *name,NSString *job,NSString *industry,NSString *year){
                                                        return @(name.length && job.length && industry.length && year.length);
                                                    }];
}

- (IBAction)next:(UIButton *)sender
{
    DDChooseFavGoodViewController *vc = [DDChooseFavGoodViewController GoodVC];

    vc.delegete = self;

    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)showWeb:(UIButton *)sender
{
}

#pragma mark - Avatar
- (IBAction)changeAvatar:(UIButton *)sender 
{
    [[SYCameraManager sharedInstance] getAvatarInViewController:self callback:^(NSArray *photos) {
        [self.btnAvatar setImage:photos.lastObject forState:UIControlStateNormal];
    }];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.txtJob ||
        textField == self.txtIndustry) {
        [self.view endEditing:YES];
        DDFillJobIndustryViewController *vc = [DDFillJobIndustryViewController viewController];
        vc.isFillJob = (textField == self.txtJob);
        vc.callback = ^(NSString *str) {
            textField.text = str;
        };
        [self.navigationController pushViewController:vc animated:YES];
        return NO;
    }

    return YES;
}

#pragma DDChooseFavGoodViewControllerProtocol
- (void)chooseFavGood:(DDChooseFavGoodViewController *)vc
{
    if (vc.isChooseFav) {
        self.topic = vc.chooseValues;
        // 开启道道
        [self.navigationController showLoadingHUD];
        id params = @{ kPhoneKey : _user.mobilePhone,
                       kCodeKey : _authCode,
                       kInviteCodeKey : _inviteCode,
                       kJobKey : _txtJob.text,
                       kIndustryKey : _txtIndustry.text,
                       kYearKey : _user.year,
                       kExpertKey : _expert,
                       kTopicKey : _topic,
                       kRealnameKey : _user.realName,
                       kNicknameKey : _user.nickName,
                       kMajorKey : _user.major,
                       kGradeKey : _user.grade};

        [SYRequestEngine registerNewUserWithParams:params
                                 avatar:self.btnAvatar.imageView.image
                               callback:^(BOOL success, id response) {
                                   debugLog(@"reponse %@", response);

                                   [self.navigationController hideAllHUD];
                                   if (success) {
                                       DDUser *user = [DDUser fromDict:response[kObjKey]];
                                       [DDUserManager manager].user = user;
                                       [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                                   } else {
                                       [self.navigationController showRequestNotice:response];
                                   }
                               }];
    } else {
        self.expert = vc.chooseValues;

        DDChooseFavGoodViewController *vc = [DDChooseFavGoodViewController FavVC];

        vc.delegete = self;

        [self.navigationController pushViewController:vc animated:YES];

    }
}




@end
