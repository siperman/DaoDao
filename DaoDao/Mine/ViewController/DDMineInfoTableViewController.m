//
//  DDMineInfoTableViewController.m
//  DaoDao
//
//  Created by hetao on 2016/11/11.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDMineInfoTableViewController.h"

@interface DDMineInfoTableViewController ()
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self freshView];
}

- (void)freshView
{
    DDUser *user = [[DDUserManager manager] user];
    [self.imgHead sy_setThumbnailImageWithUrl:user.headUrl];
    [self.labNickName setText:user.nickName];
    [self.labRealName setText:user.realName];
    [self.labGender setText:user.gender.boolValue ? @"女" : @"男"];
    [self.labMajorGrade setText:MajorGrade(user.major, user.grade)];
    [self.labJob setText:[user.job componentsJoinedByString:@"、"]];
    [self.labIndustry setText:[user.industry componentsJoinedByString:@"、"]];
    [self.labYear setText:[NSString stringWithFormat:@"%@年", user.year]];
    [self.labPlace setText:[NSString stringWithFormat:@"%@%@", user.province, user.city]];
    [self.labExpert setText:[user.expert componentsJoinedByString:@"、"]];
    [self.labTopic setText:[user.topic componentsJoinedByString:@"、"]];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

@end
