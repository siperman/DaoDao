//
//  DDMineViewController.m
//  DaoDao
//
//  Created by hetao on 2016/10/31.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDMineViewController.h"
#import "UIButton+WebCache.h"
#import "DDMyAskTableViewController.h"
#import "DDMyAnswerTableViewController.h"
#import "DDMineInfoTableViewController.h"
#import "LCCKBadgeView.h"

@interface DDMineViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnCall;
@property (weak, nonatomic) IBOutlet UIButton *btnAvatar;
@property (weak, nonatomic) IBOutlet UIButton *btnLogout;
@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UILabel *labDesc;
@property (weak, nonatomic) IBOutlet UIButton *btnMyAsk;
@property (weak, nonatomic) IBOutlet UIButton *btnMyAnswer;
@property (weak, nonatomic) IBOutlet UIButton *btnMine;

@property (nonatomic, strong) LCCKBadgeView *badgeAsk;
@property (nonatomic, strong) LCCKBadgeView *badgeAnswer;
@property (nonatomic, strong) UIView *mineBadgeView;

@end

@implementation DDMineViewController

+ (instancetype)viewController
{
    DDMineViewController *vc = [[DDMineViewController alloc] initWithNibName:@"DDMineViewController" bundle:nil];
    return vc;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的";
    self.view.backgroundColor = BackgroundColor;
    [self.btnAvatar sy_round];
    [self.btnLogout actionTransparentStyle];
    NSString *tel = [NSString stringWithFormat:@"客服帮助请点击：%@", kServiceCall];
    [self.btnCall setTitle:tel];

    [self freshView];
    [self subscribeNotication:kUpdateUserInfoNotification selector:@selector(freshView)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (![SYPrefManager boolForKey:NSStringFromClass([self class])]) {
        [DDGuide showWithGuideType:DDGuideMine];
        [SYPrefManager setBool:YES forKey:NSStringFromClass([self class])];
    }
}

- (void)freshView
{
    DDUser *user = [DDUserManager manager].user;
    self.labName.text = user.nickName;
    if (user.askReds.integerValue > 0) {
        self.badgeAsk.badgeText = [user.askReds stringValue];
        self.badgeAsk.hidden = NO;
    } else {
        self.badgeAsk.hidden = YES;
    }
    if (user.answerReds.integerValue > 0) {
        self.badgeAnswer.badgeText = [user.answerReds stringValue];
        self.badgeAnswer.hidden = NO;
    } else {
        self.badgeAnswer.hidden = YES;
    }


    if (user.integrity.integerValue >= 100) {
        self.mineBadgeView.hidden = YES;
        self.labDesc.text = @"个人资料完善度100%，更多靠谱的人会靠近您";
    } else {
        self.mineBadgeView.hidden = NO;
        self.labDesc.text = [NSString stringWithFormat:@"个人资料完善度%@%%，丰富资料更精确找到靠谱人", user.integrity];
    }
    if (user.headUrl.length > 0) {
        NSString *thumbnailUrl = [user.headUrl stringByAppendingString:kThumbnailResolution];
        NSURL *URL = [[NSURL alloc] initWithString:PicUrlFactory(thumbnailUrl)];
        [self.btnAvatar sy_setImageWithURL:URL forState:UIControlStateNormal placeholderImage:DefaultAvatar];
    }
}

- (IBAction)logout:(UIButton *)sender
{
    [MobClick event:Mine_logOutBtn_click];
    NSString *buildID = [NSString stringWithFormat:@"%@ (Build %@)", [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"], [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
#ifdef RELEASE
    buildID = @"";
#endif
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:buildID message:@"退出后不会删除任何数据，下次登录依然可以使用本账号" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *logout = [UIAlertAction actionWithTitle:@"退出登录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [SYRequestEngine userLogout:^(BOOL success, id response) {
            debugLog(@"reponse %@", response);
        }];
        [DDUserManager manager].user = nil;
        [self checkLogin];

        [SYUtils showWindowLevelNotice:kLogoutSuccessNotice];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [vc addAction:logout];
    [vc addAction:cancel];
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

- (IBAction)goMineInfo:(UIButton *)sender
{
    DDMineInfoTableViewController *vc = [DDMineInfoTableViewController viewController];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)call:(UIButton *)sender
{
    [self makeCall:kServiceCall];
}

- (IBAction)goMineDetail:(UIButton *)sender
{
    DDUserHomePageViewController *vc = [DDUserHomePageViewController viewController];
    vc.userId = [DDUserManager manager].user.uid;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)goAskList:(UIButton *)sender
{
    DDMyAskTableViewController *vc = [[DDMyAskTableViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)goAnswerList:(UIButton *)sender
{
    DDMyAnswerTableViewController *vc = [[DDMyAnswerTableViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark Getter

- (LCCKBadgeView *)badgeAsk {
    if (_badgeAsk == nil) {
        LCCKBadgeView *badgeView = [[LCCKBadgeView alloc] initWithParentView:self.btnMyAsk
                                                                   alignment:LCCKBadgeViewAlignmentCenterRight];
        badgeView.badgeBackgroundColor = BadgeColor;
        badgeView.badgeTextColor = WhiteColor;
        badgeView.badgePositionAdjustment = CGPointMake(-36, 0);
        badgeView.hidden = YES;
        _badgeAsk = badgeView;
    }
    return _badgeAsk;
}

- (LCCKBadgeView *)badgeAnswer {
    if (_badgeAnswer == nil) {
        LCCKBadgeView *badgeView = [[LCCKBadgeView alloc] initWithParentView:self.btnMyAnswer
                                                                   alignment:LCCKBadgeViewAlignmentCenterRight];
        badgeView.badgeBackgroundColor = BadgeColor;
        badgeView.badgeTextColor = WhiteColor;
        badgeView.badgePositionAdjustment = CGPointMake(-36, 0);
        badgeView.hidden = YES;
        _badgeAnswer = badgeView;
    }
    return _badgeAnswer;
}

- (UIView *)mineBadgeView {
    if (_mineBadgeView == nil) {
        UIView *litteBadgeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LittleBadgeSize, LittleBadgeSize)];
        litteBadgeView.layer.cornerRadius = LittleBadgeSize / 2;
        litteBadgeView.hidden = YES;
        litteBadgeView.backgroundColor = BadgeColor;
        [self.btnMine addSubview:litteBadgeView];
        [litteBadgeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.btnMine);
            make.trailing.equalTo(self.btnMine).offset(3);
            make.width.height.mas_equalTo(LittleBadgeSize);
        }];
        _mineBadgeView = litteBadgeView;
    }
    return _mineBadgeView;
}

@end
