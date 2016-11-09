//
//  DDRateViewController.m
//  DaoDao
//
//  Created by hetao on 2016/11/6.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDRateViewController.h"
#import "DDRateViewModel.h"

@interface DDRateViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imgHead;
@property (weak, nonatomic) IBOutlet UIImageView *imgGender;

@property (weak, nonatomic) IBOutlet UILabel *labName; // 花名
@property (weak, nonatomic) IBOutlet UILabel *labGrade; // 届别
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) DDRateViewModel *viewModel;
@end

@implementation DDRateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MobClick event:AssessBtn_click];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (BOOL)wasStatusBarHidden
{
    return YES;
}

- (void)refresh
{
    DDUser *user;
    if (self.ask.isMyAsk) {
        user = self.ask.answer.user;
    } else {
        user = self.ask.user;
    }
    [self.imgHead sy_setThumbnailImageWithUrl:user.headUrl];
    [self.imgGender setImage:user.genderImage];

    self.labName.text = user.nickName;
    self.labGrade.text = MajorGrade(user.major, user.grade);

    CGSize size = self.scrollView.frame.size;
    [self.scrollView setContentSize:CGSizeMake(size.width * 3, size.height)];

}

- (IBAction)popSelf:(UIButton *)sender
{
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"确定要取消本次评价吗？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *logout = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [vc addAction:logout];
    [vc addAction:cancel];
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

- (void)sendRate
{
    [MobClick event:SubmitAssessBtn_click];
    if (self.ask.isMyAsk) {
        [SYRequestEngine rateAnswerWithParams:@{} callback:^(BOOL success, id response) {

        }];
    } else {
        [SYRequestEngine rateAskWithParams:@{} callback:^(BOOL success, id response) {

        }];
    }
}

@end
