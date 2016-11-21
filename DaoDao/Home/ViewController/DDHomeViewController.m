//
//  DDHomeViewController.m
//  DaoDao
//
//  Created by hetao on 16/9/8.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDHomeViewController.h"
#import "DDChessboardView.h"
#import "DDPostAskTableViewController.h"
#import "DDCalendarViewController.h"
#import "DDMineViewController.h"

@interface DDHomeViewController ()

@property (nonatomic, strong) DDChessboardView *chessboard;
@property (nonatomic, strong) UIButton *btnPost;
@property (nonatomic, strong) NSTimer *countDownTimer;

@property (nonatomic) BOOL isLoading;

@end

@implementation DDHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:Image(@"icon_p1")];

    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:Image(@"icon_left_bar") style:UIBarButtonItemStylePlain target:self action:@selector(goMine)];
    [leftItem setTintColor:BarTintColor];

    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:Image(@"icon_new") style:UIBarButtonItemStylePlain target:self action:@selector(goIM)];
    [rightItem setTintColor:BarTintColor];

    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationItem.leftBarButtonItem = leftItem;

    [self.view addSubview:self.chessboard];
    [self.chessboard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64+8);
        make.leading.trailing.equalTo(self.view);
        make.height.mas_equalTo([DDChessboardView boardSize].height);
    }];

    [self.view addSubview:self.btnPost];
    [self.btnPost mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chessboard.mas_bottom).offset(14);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(305);
        make.height.mas_equalTo(40);
    }];

    [self subscribeNotication:kNewIMMessageNotification selector:@selector(newIMMessage)]; // 订阅新聊天消息推送
    [self subscribeNotication:kUpdateUnreadCountNotification selector:@selector(refreshIM)]; // 订阅未读聊天消息数推送

    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:120 target:self selector:@selector(requestChess) userInfo:nil repeats:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self checkLogin] && !self.isLoading) {
        [self requestChess];
        [[DDUserManager manager] touchUser];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.badgeView.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.badgeView.hidden = YES;
}

- (void)requestChess
{
    if (self.isLoading || ![DDUserManager manager].user) {
        return;
    }
    self.isLoading = YES;
    [SYRequestEngine requestChessCallback:^(BOOL success, id response) {
        if (success) {
            NSArray *array = [DDChess parseFromDicts:response[kResultKey]];
            [self.chessboard setChessArray:array];
        }
        self.isLoading = NO;
    }];
}

- (void)refreshIM
{
    NSInteger totalUnreadCount = [DDUserManager manager].notificationManager.unreadIMMessagesCount;

    if (totalUnreadCount > 0) {
        NSString *badgeValue = [NSString stringWithFormat:@"%ld", (long)totalUnreadCount];
        if (totalUnreadCount > 99) {
            badgeValue = @"99+";
        }
        self.badgeView.badgeText = badgeValue;
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:totalUnreadCount];
    } else {
        self.badgeView.badgeText = nil;
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }
}

- (void)newIMMessage
{
    [self.badgeView shake];
}

- (void)goMine
{
    [MobClick event:Home_mineIcon_click];
    DDMineViewController *vc = [[DDMineViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goIM
{
    [MobClick event:Home_msgIcon_click];
    LCCKConversationListViewController *vc = [[LCCKConversationListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)postAsk
{
    [MobClick event:Home_publishDemandBtn_click];
    DDPostAskTableViewController *vc = [DDPostAskTableViewController viewController];
//    DDCalendarViewController *vc = [[DDCalendarViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark Getter
- (DDChessboardView *)chessboard
{
    if (!_chessboard) {
        _chessboard = LoadView(@"DDChessboardView");
    }
    return _chessboard;
}

- (UIButton *)btnPost
{
    if (!_btnPost) {
        _btnPost = [[UIButton alloc] init];
        [_btnPost shadowStyle];
        [_btnPost.layer setShadowOpacity:0.4];
        [_btnPost.layer setBorderColor:ColorHex(@"dadada").CGColor];
        [_btnPost.layer setBorderWidth:OnePixelHeight];
        [_btnPost setTitle:@"发需求"];
        [_btnPost setTitleColor:MainColor];
        _btnPost.backgroundColor = ColorHex(@"ebebeb");
        _btnPost.titleLabel.font = BigTextFont;

        [_btnPost addTarget:self action:@selector(postAsk) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnPost;
}

- (LCCKBadgeView *)badgeView {
    if (_badgeView == nil) {
        LCCKBadgeView *badgeView = [[LCCKBadgeView alloc] initWithParentView:self.navigationController.navigationBar
                                                                   alignment:LCCKBadgeViewAlignmentTopRight];
        badgeView.badgeBackgroundColor = BadgeColor;
        badgeView.badgeTextColor = WhiteColor;
        badgeView.badgePositionAdjustment = CGPointMake(-16, 8);
        _badgeView = badgeView;

    }
    return _badgeView;
}

@end
