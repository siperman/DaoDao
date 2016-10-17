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
//    RAC(self.btnPost, enabled) = self.postAskModel.enablePostSignal;
}

#pragma mark Action

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
//        vc.showTopView = YES;
        vc.callback = ^(NSString *str) {
            self.postAskModel.industry = str;
            self.txtIndustry.text = str;
        };
        [self.navigationController pushViewController:vc animated:YES];
    } else if (tag == 1) {
        // 职务
        DDFillJobIndustryViewController *vc = [DDFillJobIndustryViewController viewController];
        vc.isFillJob = YES;
//        vc.showTopView = YES;
        vc.callback = ^(NSString *str) {
            self.postAskModel.job = str;
            self.txtJob.text = str;
        };
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        // 专家
        DDChooseFavGoodViewController *vc = [DDChooseFavGoodViewController GoodVC];
        vc.delegete = self;

        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)post:(UIButton *)sender
{
    if (![self checkParams]) {
        return;
    }
    [self showLoadingHUD];
    id params = @{ kDemandKey : _postAskModel.demand,
                   kIndustryKey : _postAskModel.industry,
                   kJobKey : _postAskModel.job,
                   kExpertKey : _postAskModel.expert
                    };
    [SYRequestEngine sendAskWithParams:params
                              callback:^(BOOL success, id response) {
                                  [self hideAllHUD];
                                  if (success) {
                                      DDAskDetailViewController *vc = [[DDAskDetailViewController alloc] init];

                                      [self.navigationController pushViewController:vc animated:YES];
                                  } else {
                                      [self showRequestNotice:response];
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
