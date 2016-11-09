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

@interface DDMineViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnCall;
@property (weak, nonatomic) IBOutlet UIButton *btnAvatar;
@property (weak, nonatomic) IBOutlet UIButton *btnLogout;
@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UILabel *labDesc;

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
    [self.btnLogout actionTransparentStyle];
    NSString *tel = [NSString stringWithFormat:@"客服帮助请点击：%@", kServiceCall];
    [self.btnCall setTitle:tel];

    DDUser *user = [DDUserManager manager].user;
    self.labName.text = user.nickName;

    if (user.integrity.integerValue >= 100) {
        self.labDesc.text = @"个人资料完善度100%，更多靠谱的人会靠近您";
    } else {
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
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"" message:@"退出后不会删除任何数据，下次登录依然可以使用本账号" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *logout = [UIAlertAction actionWithTitle:@"退出登录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [SYRequestEngine userLogout:^(BOOL success, id response) {
            debugLog(@"reponse %@", response);
        }];
        [DDUserManager manager].user = nil;
        [self.navigationController popViewControllerAnimated:NO];

        [SYUtils showWindowLevelNotice:kLogoutSuccessNotice];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [vc addAction:logout];
    [vc addAction:cancel];
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

- (IBAction)call:(UIButton *)sender
{
    [self makeCall:kServiceCall];
}

- (IBAction)goMineDetail:(UIButton *)sender
{
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

@end
