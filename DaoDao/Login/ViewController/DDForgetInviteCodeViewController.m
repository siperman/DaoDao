//
//  DDForgetInviteCodeViewController.m
//  DaoDao
//
//  Created by hetao on 16/9/14.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDForgetInviteCodeViewController.h"

@interface DDForgetInviteCodeViewController ()

@property (weak, nonatomic) IBOutlet UIView *bigView;
@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UILabel *labPhone;

@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@end

@implementation DDForgetInviteCodeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"忘记邀请码";

    [self.labName bigSecondStyle];
    [self.labPhone bigSecondStyle];
    [self.txtPhone normalStyle];
    [self.txtName normalStyle];
    [self.bigView shadowStyle];
    [self.btnSubmit actionStyle];
}

- (IBAction)submit:(UIButton *)sender
{
    
}


@end
