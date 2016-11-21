//
//  DDMineInfoTableViewController.m
//  DaoDao
//
//  Created by hetao on 2016/11/11.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDMineInfoTableViewController.h"
#import "DDUpdateUserInfoViewController.h"
#import "DDChooseFavGoodViewController.h"
#import "DDFillJobIndustryViewController.h"
#import "GYZChooseCityController.h"
#import "DDChangeAvatarViewController.h"

@interface DDMineInfoTableViewController () <DDChooseFavGoodViewControllerProtocol, GYZChooseCityDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imgHead;
@property (weak, nonatomic) IBOutlet UILabel *labNickName;
@property (weak, nonatomic) IBOutlet UILabel *labRealName;
@property (weak, nonatomic) IBOutlet UILabel *labGender;
@property (weak, nonatomic) IBOutlet UILabel *labMajorGrade;
@property (weak, nonatomic) IBOutlet UILabel *labJob;
@property (weak, nonatomic) IBOutlet UILabel *labIndustry;
@property (weak, nonatomic) IBOutlet UILabel *labYear;
@property (weak, nonatomic) IBOutlet UILabel *labPlace;
@property (weak, nonatomic) IBOutlet UILabel *labExpert;
@property (weak, nonatomic) IBOutlet UILabel *labTopic;

@end

@implementation DDMineInfoTableViewController

+ (instancetype)viewController
{
    DDMineInfoTableViewController *vc = [[SYStoryboardManager manager].mainSB instantiateViewControllerWithIdentifier:@"DDMineInfoTableViewController"];

    return vc;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"个人信息";
    [self freshView];
    [self subscribeNotication:kUpdateUserInfoNotification selector:@selector(freshView)];
}

- (void)freshView
{
    DDUser *user = [[DDUserManager manager] user];
    [self.imgHead sy_round];
    [self.imgHead sy_setThumbnailImageWithUrl:user.headUrl];
    [self.labNickName setText:user.nickName];
    [self.labRealName setText:user.realName];
    [self.labGender setText:user.gender.boolValue ? @"女" : @"男"];
    [self.labMajorGrade setText:MajorGrade(user.major, user.grade)];
    [self.labJob setText:[user.job componentsJoinedByString:@"、"]];
    [self.labIndustry setText:[user.industry componentsJoinedByString:@"、"]];
    [self.labYear setText:[NSString stringWithFormat:@"%@年", user.year]];
    [self.labPlace setText:user.city];
    [self.labExpert setText:[user.expert componentsJoinedByString:@"、"]];
    [self.labTopic setText:[user.topic componentsJoinedByString:@"、"]];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    DDUser *user = [[DDUserManager manager] user];

    if (section == 0) {
        if (row == 0) { // 头像
            DDChangeAvatarViewController *vc = [[DDChangeAvatarViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else { // 花名
            DDUpdateUserInfoViewController *vc = [[DDUpdateUserInfoViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if (section == 2) {
        if (row == 0) { // 职务
            DDFillJobIndustryViewController *vc = [DDFillJobIndustryViewController viewController];
            vc.isFillJob = YES;
            vc.callback = ^(NSString *str) {
                [self updateUserInfo:@{@"job" : [str stringByReplacingOccurrencesOfString:@"，" withString:@","]}];
            };
            vc.fillStr = [user.job componentsJoinedByString:@","];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (row == 1) { // 行业
            DDFillJobIndustryViewController *vc = [DDFillJobIndustryViewController viewController];
            vc.callback = ^(NSString *str) {
                [self updateUserInfo:@{@"industry" : [str stringByReplacingOccurrencesOfString:@"，" withString:@","]}];
            };
            vc.fillStr = [user.industry componentsJoinedByString:@","];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (row == 2) { // 从业时间
            DDUpdateUserInfoViewController *vc = [[DDUpdateUserInfoViewController alloc] init];
            vc.isUpdateYear = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else { // 企业所在地
            GYZChooseCityController *vc = [[GYZChooseCityController alloc] init];
            [vc setDelegate:self];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if (section == 3) {
        if (row == 1) { // 擅长领域

            DDChooseFavGoodViewController *vc = [DDChooseFavGoodViewController GoodVC];
            vc.delegete = self;

            [self.navigationController pushViewController:vc animated:YES];
        } else if (row == 2) { // 感兴趣话题

            DDChooseFavGoodViewController *vc = [DDChooseFavGoodViewController FavVC];
            vc.delegete = self;

            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

#pragma mark - GYZChooseCityDelegate
- (void) cityPickerController:(GYZChooseCityController *)chooseCityController didSelectCity:(GYZCity *)city
{
    [self updateUserInfo:@{@"city" : city.cityName}];
}

- (void) cityPickerControllerDidCancel:(GYZChooseCityController *)chooseCityController
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark DDChooseFavGoodViewControllerProtocol
- (void)chooseFavGood:(DDChooseFavGoodViewController *)vc
{
    id params;
    if (vc.isChooseFav) {
        params = @{@"topic" : vc.chooseValues};
    } else {
        params = @{@"expert" : vc.chooseValues};
    }

    [self updateUserInfo:params];
}

- (void)updateUserInfo:(NSDictionary *)params
{
    [self.navigationController showLoadingHUD];
    [SYRequestEngine updateUserInfo:params avatar:nil callback:^(BOOL success, id response) {
        [self.navigationController hideAllHUD];
        if (success) {
            DDUser *user = [DDUser fromDict:response[kObjKey]];
            [DDUserManager manager].user = user;
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self.navigationController showRequestNotice:response];
        }
    }];
}

@end
