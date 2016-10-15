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
#import <ChatKit/LCCKConversationListViewController.h>

@interface DDHomeViewController ()

@property (nonatomic, strong) DDChessboardView *chessboard;
@property (nonatomic, strong) UIButton *btnPost;
@end

@implementation DDHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:Image(@"icon_p1")];

    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:Image(@"icon_left_bar") style:UIBarButtonItemStylePlain target:self action:@selector(goMine)];
    [leftItem setTintColor:SecondColor];

    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:Image(@"icon_new") style:UIBarButtonItemStylePlain target:self action:@selector(goIM)];
    [rightItem setTintColor:SecondColor];

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
        make.top.equalTo(self.chessboard.mas_bottom).offset(32);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(305);
        make.height.mas_equalTo(40);
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([self checkLogin]) {
        [self requestChess];
    }
}

- (void)requestChess
{
    [SYRequestEngine requestChessCallback:^(BOOL success, id response) {
        if (success) {
            NSArray *array = [DDChess parseFromDicts:response[kResultKey]];
            [self.chessboard setChessArray:array];
        }
    }];
}

- (void)goMine
{
//    DDChess *chess = [[DDChess alloc] init];
//    NSMutableArray *array = [NSMutableArray array];
//    for (NSInteger i = 0; i < 18; i++) {
//        chess.isBig = i%2;
//        chess.isWhite = i%3;
//        chess.isLighting = i%4;
//        chess.cid = [NSString stringWithFormat:@"围棋棋子第%@个", @(i)];
//        [array addObject:[chess copy]];
//    }
//    [self.chessboard setChessArray:array];

    RIButtonItem *btnCancle = [RIButtonItem itemWithLabel:@"取消"];
    RIButtonItem *btnLogout = [RIButtonItem itemWithLabel:@"确定" action:^{
        [SYRequestEngine userLogout:^(BOOL success, id response) {
            debugLog(@"reponse %@", response);
        }];
        [DDUserManager manager].user = nil;

        [self checkLogin];
        [self.navigationController popViewControllerAnimated:NO];

        [SYUtils showWindowLevelNotice:kLogoutSuccessNotice];
    }];

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定要退出当前账号？"
                                                    message:nil
                                           cancelButtonItem:btnCancle
                                           otherButtonItems:btnLogout, nil];
    [alert show];
}

- (void)goIM
{
    LCCKConversationListViewController *vc = [[LCCKConversationListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)postAsk
{
//    [self showNotice:@"click post"];
    DDPostAskTableViewController *vc = [DDPostAskTableViewController viewController];

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
        [_btnPost setTitle:@"发需求"];
        [_btnPost setTitleColor:MainColor];
        _btnPost.backgroundColor = ColorHex(@"ebebeb");
        _btnPost.titleLabel.font = BigTextFont;

        [_btnPost addTarget:self action:@selector(postAsk) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnPost;
}

@end
