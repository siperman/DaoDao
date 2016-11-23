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
#import "DDWebViewController.h"
#import "DDWelcome.h"

@interface DDRegisterStepThreeViewController () <UITextFieldDelegate, DDChooseFavGoodViewControllerProtocol>

@property (weak, nonatomic) IBOutlet UIButton *btnAvatar;
@property (weak, nonatomic) IBOutlet UIButton *btnAddAvatar;
@property (weak, nonatomic) IBOutlet UIView *bigView;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;

@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtJob;
@property (weak, nonatomic) IBOutlet UITextField *txtIndustry;
@property (weak, nonatomic) IBOutlet UITextField *txtYear;

@property (nonatomic, strong) NSString *topic; // 感兴趣话题
@property (nonatomic, strong) NSString *expert; // 擅长领域
@property (nonatomic, strong) NSString *time;
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
    self.view.backgroundColor = BackgroundColor;
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
    self.time = [NSString stringWithFormat:@"%ld", [SYUtils currentTimestamp]];
}

- (IBAction)next:(UIButton *)sender
{
    [self.view endEditing:YES];

    DDChooseFavGoodViewController *vc = [DDChooseFavGoodViewController GoodVC];

    vc.delegete = self;

    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)showWeb:(UIButton *)sender
{
    [self.view endEditing:YES];

    DDWebViewController *vc = [[DDWebViewController alloc] init];
#if DEBUG
    vc.url = [NSString stringWithFormat:@"http://devadmin.daodaoclub.com/h5/company/announce.html?xx=%@", self.time];
#elif TEST
    vc.url = [NSString stringWithFormat:@"http://testadmin.daodaoclub.com/h5/company/announce.html?xx=%@", self.time];
#else
    vc.url = [NSString stringWithFormat:@"http://admin.daodaoclub.com/h5/company/announce.html?xx=%@", self.time];
#endif
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Avatar
- (IBAction)changeAvatar:(UIButton *)sender 
{
    [self.view endEditing:YES];
    [[SYCameraManager sharedInstance] getAvatarInViewController:self callback:^(NSArray *photos) {
        [self.btnAvatar setImage:photos.lastObject forState:UIControlStateNormal];
        self.btnAddAvatar.hidden = YES;
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
            [self.navigationController popViewControllerAnimated:YES];
        };
        vc.fillStr = textField.text;
        [self.navigationController pushViewController:vc animated:YES];
        return NO;
    }

//    if (textField == self.txtYear) {
//        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
//    }

    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.txtYear) {
        NSString *year = [textField.text stringByReplacingCharactersInRange:range withString:string];
        return year.integerValue <= 60;
    }
    if (textField == self.txtName) {
        NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
        return text.length <= 8;
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
                       kJobKey : [_txtJob.text stringByReplacingOccurrencesOfString:@"，" withString:@","],
                       kIndustryKey : [_txtIndustry.text stringByReplacingOccurrencesOfString:@"，" withString:@","],
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
                                       [self.navigationController dismissViewControllerAnimated:YES completion:^{
                                           [DDWelcome show];
                                       }];
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
