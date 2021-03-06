//
//  DDPostAskTableViewController.m
//  DaoDao
//
//  Created by hetao on 2016/10/8.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDPostAskTableViewController.h"
#import "DDPostAskViewModel.h"
#import "DDFillJobIndustryViewController.h"
#import "DDAskDetailViewController.h"
#import "DDChooseFavGoodViewController.h"

@interface DDPostAskTableViewController () <UITextViewDelegate, UITextFieldDelegate, DDChooseFavGoodViewControllerProtocol>

@property (nonatomic) NSInteger time_;
@property (weak, nonatomic) IBOutlet UILabel *labPlaceHolder;
@property (weak, nonatomic) IBOutlet UILabel *labResidue;
@property (weak, nonatomic) IBOutlet UITextView *txtDemand;

@property (weak, nonatomic) IBOutlet UITextField *txtIndustry;
@property (weak, nonatomic) IBOutlet UITextField *txtJob;
@property (weak, nonatomic) IBOutlet UITextField *txtExpert;

@property (weak, nonatomic) IBOutlet UIButton *btnPost;

@property (nonatomic, strong) DDPostAskViewModel *postAskModel;
@end

@implementation DDPostAskTableViewController

+ (instancetype)viewController
{
    DDPostAskTableViewController *vc = [[SYStoryboardManager manager].askSB instantiateViewControllerWithIdentifier:@"DDPostAskTableViewController"];

    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"新的需求";
    self.view.backgroundColor = BackgroundColor;
    [self.btnPost actionStyle];

    self.txtDemand.delegate = self;
    self.postAskModel = [[DDPostAskViewModel alloc] init];
    self.time_ = [SYUtils currentTimestamp];
//    RAC(self.btnPost, enabled) = self.postAskModel.enablePostSignal;
    [self setBackButtonSelector:@selector(back)];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}
#pragma mark Action

- (void)back
{
    if (_postAskModel.demand.length > 0 ||
        _postAskModel.industry.length > 0 ||
        _postAskModel.job.length > 0 ||
        _postAskModel.expert.length > 0) {
        UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"确定要放弃已编辑需求信息吗？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *logout = [UIAlertAction actionWithTitle:@"放弃编辑" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"继续编辑" style:UIAlertActionStyleCancel handler:nil];
        [vc addAction:logout];
        [vc addAction:cancel];
        [self.navigationController presentViewController:vc animated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)clickPush:(UIButton *)sender
{
    [self input:sender.tag];
}

- (void)input:(NSInteger)tag
{
    if (tag == 0) {
        // 行业
        DDFillJobIndustryViewController *vc = [DDFillJobIndustryViewController viewController];
        vc.isFillJob = NO;
        vc.callback = ^(NSString *str) {
            self.postAskModel.industry = [str stringByReplacingOccurrencesOfString:@"，" withString:@","];
            self.txtIndustry.text = str;
            [self.navigationController popViewControllerAnimated:YES];
        };
        vc.fillStr = self.txtIndustry.text;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (tag == 1) {
        // 职务
        DDFillJobIndustryViewController *vc = [DDFillJobIndustryViewController viewController];
        vc.isFillJob = YES;
        vc.callback = ^(NSString *str) {
            self.postAskModel.job = [str stringByReplacingOccurrencesOfString:@"，" withString:@","];
            self.txtJob.text = str;
            [self.navigationController popViewControllerAnimated:YES];
        };
        vc.fillStr = self.txtJob.text;

        [self.navigationController pushViewController:vc animated:YES];
    } else {
        // 专家
        DDChooseFavGoodViewController *vc = [DDChooseFavGoodViewController GoodVC];
        vc.delegete = self;
        if (_postAskModel.expert) {
            vc.placeholderArray = [_postAskModel.expert componentsSeparatedByString:@","];
        }

        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)post:(UIButton *)sender
{
    [MobClick event:NewYueju_publishBtn_click];
    if (![self checkParams]) {
        return;
    }
    [self.navigationController showLoadingHUD];
    id params = @{ kDemandKey : _postAskModel.demand,
                   kIndustryKey : _postAskModel.industry,
                   kJobKey : _postAskModel.job,
                   kExpertKey : _postAskModel.expert,
                   @"_time" : @(self.time_)
                    };
    [SYRequestEngine sendAskWithParams:params
                              callback:^(BOOL success, id response) {
                                  [self.navigationController hideAllHUD];
                                  if (success) {
                                      DDAskDetailViewController *vc = [[DDAskDetailViewController alloc] init];
                                      NSMutableArray *vcs = [[self.navigationController viewControllers] mutableCopy];
                                      [vcs replaceObjectAtIndex:[vcs indexOfObject:self] withObject:vc];
                                      vc.ask = [DDAsk fromDict:response[kObjKey]];

                                      [self.navigationController showNotice:@"发布需求成功"];
                                      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kDefaultHideNoticeIntervel * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                          [self.navigationController setViewControllers:vcs animated:YES];
                                      });
                                      POST_NOTIFICATION(kPostAskSuccessNotification, nil);
                                  } else {
                                      [self.navigationController showRequestNotice:response];
                                  }
                              }];
}

- (BOOL)checkParams
{
    BOOL result = YES;

    if (_postAskModel.demand.length == 0) {
        [self showNotice:@"需求内容不能为空喔！"];
        result = NO;
    } else if (_postAskModel.industry.length == 0) {
        [self showNotice:@"发布对象的行业不能为空喔！"];
        result = NO;
    } else if (_postAskModel.job.length == 0) {
        [self showNotice:@"发布对象的职务不能为空喔！"];
        result = NO;
    } else if (_postAskModel.expert.length == 0) {
        [self showNotice:@"发布对象的专长不能为空喔！"];
        result = NO;
    }

    return result;
}

#pragma mark DDChooseFavGoodViewControllerProtocol
- (void)chooseFavGood:(DDChooseFavGoodViewController *)vc
{
    _postAskModel.expert = vc.chooseValues;
    self.txtExpert.text = vc.chooseValues;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UITextViewDelegate
#define MaxTextNumber 100
-(void)textViewDidChange:(UITextView*)textView
{
    if([textView.text length] == 0) {
        self.labPlaceHolder.hidden = NO;
    } else {
        self.labPlaceHolder.hidden = YES;
    }

    NSInteger existTextNum = [textView.text length];
    _postAskModel.demand = textView.text;

    self.labResidue.text = [NSString stringWithFormat:@"%ld/%d",(long)existTextNum, MaxTextNumber];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return YES;
    }

    return textView.text.length + text.length <= MaxTextNumber;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self input:textField.tag];
    return NO;
}

@end
