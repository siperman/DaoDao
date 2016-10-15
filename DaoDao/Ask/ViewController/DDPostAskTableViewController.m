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

@interface DDPostAskTableViewController () <UITextViewDelegate, DDChooseFavGoodViewControllerProtocol>


@property (weak, nonatomic) IBOutlet UILabel *labPlaceHolder;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *labResidue;

@property (weak, nonatomic) IBOutlet UIButton *btnType;
@property (weak, nonatomic) IBOutlet UIButton *btnPost;

@property (weak, nonatomic) IBOutlet UITextField *txtType;
@property (weak, nonatomic) IBOutlet UITextField *txtDemand;
@property (weak, nonatomic) IBOutlet UITextView *txtDesc;
@property (weak, nonatomic) IBOutlet UITextField *txtIndustry;
@property (weak, nonatomic) IBOutlet UITextField *txtJob;
@property (weak, nonatomic) IBOutlet UITextField *txtExpert;

@property (nonatomic) BOOL hideType;
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
    
    self.title = @"新的约局";
    self.view.backgroundColor = BackgroundColor;
    [self.btnPost actionStyle];

    self.postAskModel = [[DDPostAskViewModel alloc] init];
    RAC(self.postAskModel, demand) = self.txtDemand.rac_textSignal;
    RAC(self.postAskModel, desc) = self.txtDesc.rac_textSignal;
    RAC(self.btnPost, enabled) = self.postAskModel.enablePostSignal;
}

#pragma mark Action
- (IBAction)showType:(UIButton *)sender
{
}

- (IBAction)clickType:(UIButton *)sender
{
    NSString *text;
    if (sender.tag == 0) {
        text = [@"合作" copy];
    } else if (sender.tag == 1) {
        text = [@"咨询" copy];
    } else {
        text = [@"求助" copy];
    }
    self.postAskModel.type = text;
    self.txtType.text = text;
}

- (IBAction)clickPush:(UIButton *)sender
{
    if (sender.tag == 0) {
        // 行业
        DDFillJobIndustryViewController *vc = [DDFillJobIndustryViewController viewController];
        vc.isFillJob = NO;
        vc.showTopView = YES;
        vc.callback = ^(NSString *str) {
            self.postAskModel.industry = str;
            self.txtIndustry.text = str;
        };
        [self.navigationController pushViewController:vc animated:YES];
    } else if (sender.tag == 1) {
        // 职务
        DDFillJobIndustryViewController *vc = [DDFillJobIndustryViewController viewController];
        vc.isFillJob = YES;
        vc.showTopView = YES;
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
    [self showLoadingHUD];
    id params = @{ kTypeKey : _postAskModel.type,
                   @"demand" : _postAskModel.demand,
                   @"descr" : [NSString validString:_postAskModel.desc],
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

    self.labResidue.text = [NSString stringWithFormat:@"%ld/%d",(long)existTextNum, MaxTextNumber];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return textView.text.length + text.length < MaxTextNumber;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [super numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;

    if (section == 0 && row == 1) {
        self.hideType = !self.hideType;
        [self.btnType sy_setImage:self.hideType ? Image(@"btn_shouqi") : Image(@"btn_xiala")];
        [self.tableView reloadData];
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;

    if (section == 0 && row == 2 && self.hideType) {
        return CGFLOAT_MIN;
    }

    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

@end
