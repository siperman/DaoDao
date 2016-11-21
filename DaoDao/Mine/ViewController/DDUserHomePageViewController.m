//
//  DDUserHomePageViewController.m
//  DaoDao
//
//  Created by hetao on 2016/11/11.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDUserHomePageViewController.h"
#import "DDUserPageTableViewController.h"

@interface DDUserHomePageViewController ()

@property (weak, nonatomic) DDUserPageTableViewController *containerVC;
@property (weak, nonatomic) IBOutlet UIButton *btnMenu;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (nonatomic, strong) DDUser *user;
@end

@implementation DDUserHomePageViewController

+ (instancetype)viewController
{
    DDUserHomePageViewController *vc = [[SYStoryboardManager manager].mainSB instantiateViewControllerWithIdentifier:@"DDUserHomePageViewController"];

    return vc;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = BackgroundColor;

    DDUser *user = [DDUserManager manager].user;
    if ([user.uid isEqualToString:self.userId]) {
//        [self.containerVC freshWithUser:user];
        self.btnMenu.hidden = YES;
        self.containerVC.view.hidden = YES;
        self.bottomView.hidden = YES;
        [self requestUser];
    } else {
        self.containerVC.view.hidden = YES;
        [self requestUser];
    }
    self.bottomView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (IBAction)back:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)popMenu:(UIButton *)sender
{
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *logout = [UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self showNotice:@"举报成功！"];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [vc addAction:logout];
    [vc addAction:cancel];
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

- (IBAction)call:(UIButton *)sender
{
    [self makeCall:self.user.mobilePhone];
}

- (void)requestUser
{
    [self showLoadingHUD];
    [SYRequestEngine requestUserWithId:self.userId callback:^(BOOL success, id response) {
        [self hideAllHUD];
        if (success) {
            DDUser *user = [DDUser fromDict:response[kObjKey]];
            [self.containerVC freshWithUser:user];
            self.containerVC.view.hidden = NO;
            self.user = user;
            if (user.isMeeting) {
                self.bottomView.hidden = NO;
            }
        } else {
            [self showRequestNotice:response];
        }
    }];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"DDUserPageTableViewController"]) {
        self.containerVC = segue.destinationViewController;
    }
}

@end
