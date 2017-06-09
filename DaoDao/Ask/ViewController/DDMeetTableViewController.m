//
//  DDMeetTableViewController.m
//  DaoDao
//
//  Created by hetao on 2016/10/24.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDMeetTableViewController.h"
#import "DDCalendarViewController.h"
#import "GYZChooseCityController.h"
#import "DDAskChatManager.h"

@interface DDMeetTableViewController () <UITextFieldDelegate, GYZChooseCityDelegate, DDChooseTimeProtocol>
@property (weak, nonatomic) IBOutlet UIButton *btnPost;
@property (weak, nonatomic) IBOutlet UILabel *label;

@property (weak, nonatomic) IBOutlet UITextField *txtTime;
@property (weak, nonatomic) IBOutlet UITextField *txtCity;
@property (weak, nonatomic) IBOutlet UITextField *txtAddr;

@property (nonatomic) NSTimeInterval time;
@end

@implementation DDMeetTableViewController

+ (instancetype)viewController
{
    DDMeetTableViewController *vc = [[SYStoryboardManager manager].askSB instantiateViewControllerWithIdentifier:@"DDMeetTableViewController"];

    return vc;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [MobClick event:YuejuIm_meetBtn_click];
    
    self.title = @"约见面";
    self.view.backgroundColor = BackgroundColor;
    [self.btnPost actionStyle];
    [self.label normalTextStyle];
    [@[self.txtAddr, self.txtTime, self.txtCity] makeObjectsPerformSelector:@selector(normalStyle)];
    self.txtAddr.delegate = self;
}

- (IBAction)post:(UIButton *)sender
{
    [MobClick event:Meet_publishBtn_click];
    if (self.txtTime.text.length == 0) {
        [self showNotice:@"还未选择见面时间喔！"];
        return;
    } else if (self.txtCity.text.length == 0) {
        [self showNotice:@"所在城市不能为空喔！"];
        return;
    } else if (self.txtAddr.text.length == 0) {
        [self showNotice:@"详细地址不能为空喔！"];
        return;
    }

    NSNumber *time = [NSNumber numberWithDouble:_time];
    id params = @{ kIDKey : [NSString validString:_ask.aid],
                   @"meetTime" : time,
                   @"meetCity" : _txtCity.text,
                   @"meetAddr" : _txtAddr.text};

    [self showLoadingHUD];
    [SYRequestEngine inviteAnswerWithParams:params callback:^(BOOL success, id response) {
        [self hideAllHUD];
        if (success) {
            _ask = [DDAsk fromDict:response[kObjKey]];
            // 缓存约局信息
            [[DDAskChatManager sharedInstance] cacheAsk:_ask ForConversationId:_ask.answer.conversionId];

            [self.navigationController popViewControllerAnimated:YES];
            if (self.callback) {
                self.callback();
            }
        } else {
            [self showRequestNotice:response];
        }
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;

    if (section == 0 && row == 1) {
        // 见面时间
        DDCalendarViewController *vc = [[DDCalendarViewController alloc] init];
        [vc setDelegete:self];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (section == 1 && row == 1) {
        // 所在城市
        GYZChooseCityController *vc = [[GYZChooseCityController alloc] init];
        [vc setDelegate:self];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - DDChooseTimeProtocol

- (void)chooseTime:(NSTimeInterval)time
{
    self.txtTime.text = [SYUtils dateFormInterval:time];
    self.time = time;
}

#pragma mark - GYZChooseCityDelegate
- (void) cityPickerController:(GYZChooseCityController *)chooseCityController didSelectCity:(GYZCity *)city
{
    self.txtCity.text = city.cityName;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) cityPickerControllerDidCancel:(GYZChooseCityController *)chooseCityController
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
