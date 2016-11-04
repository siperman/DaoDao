//
//  DDMeetDetailViewController.m
//  DaoDao
//
//  Created by hetao on 2016/10/25.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDMeetDetailViewController.h"
#import "DDAskChatManager.h"

@interface DDMeetDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UILabel *labDemand;
@property (weak, nonatomic) IBOutlet UILabel *labTime;
@property (weak, nonatomic) IBOutlet UILabel *labAddr;
@property (nonatomic, strong) DDAsk *ask;

@end

@implementation DDMeetDetailViewController

+ (instancetype)viewController
{
    DDMeetDetailViewController *vc = [[SYStoryboardManager manager].askSB instantiateViewControllerWithIdentifier:@"DDMeetDetailViewController"];

    return vc;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"查看邀请函";
    self.view.backgroundColor = BackgroundColor;

    _ask = [[DDAskChatManager sharedInstance] getCachedProfileIfExists:_conversationId];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (_ask && _ask.answer.meet) {
        [self setUpData];
    } else {
        [self requestData];
    }
}

- (void)requestData
{
    [self showLoadingHUD];
    WeakSelf;
    [SYRequestEngine requestAskInfoWithId:_conversationId callback:^(BOOL success, id response) {
        [self hideAllHUD];
        if (success) {
            _ask = [DDAsk fromDict:response[kObjKey]];
            // 缓存约局信息
            [[DDAskChatManager sharedInstance] cacheAsk:_ask ForConversationId:_conversationId];
            [weakSelf setUpData];
        } else {
            [self showRequestNotice:response];
        }
    }];
}

- (void)agree
{
    [self showLoadingHUD];
    WeakSelf;
    [SYRequestEngine agreeAskInviteWithId:_ask.aid callback:^(BOOL success, id response) {
        [self hideAllHUD];
        if (success) {
            _ask = [DDAsk fromDict:response[kObjKey]];
            // 缓存约局信息
            [[DDAskChatManager sharedInstance] cacheAsk:_ask ForConversationId:_conversationId];
            if (weakSelf.callback) {
                weakSelf.callback(@"好的，收到邀请函，确认赴约。");
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        } else {
            [self showRequestNotice:response];
        }
    }];
}

- (void)disagree
{
    [self showLoadingHUD];
    WeakSelf;
    [SYRequestEngine disagreeAskInviteWithId:_ask.aid callback:^(BOOL success, id response) {
        [self hideAllHUD];
        if (success) {
            _ask = [DDAsk fromDict:response[kObjKey]];
            // 缓存约局信息
            [[DDAskChatManager sharedInstance] cacheAsk:_ask ForConversationId:_conversationId];
            if (weakSelf.callback) {
                weakSelf.callback(@"抱歉，暂时无法赴约，请见谅。");
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        } else {
            [self showRequestNotice:response];
        }
    }];
}

- (void)setUpData
{
    _labName.text = _ask.answer.user.title;
    _labDemand.text = _ask.demand;
    _labTime.text = [SYUtils dateFormInterval:_ask.answer.meet.time.doubleValue];
    _labAddr.text = [NSString stringWithFormat:@"%@%@", _ask.answer.meet.city, _ask.answer.meet.addr];

//    if (_ask.status.integerValue != DDAskWaitingAgreeMeet) {
//        return;
//    }
    if (_ask.isMyAsk) {
        UILabel *lab = [[UILabel alloc] init];
        lab.text = @"等待对方确认赴约...";
        lab.textColor = WhiteColor;
        lab.font = BigTextFont;
        lab.backgroundColor = ColorHex(@"9e9e9e");
        lab.alpha = 0.8;
        lab.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.leading.bottom.equalTo(self.view);
            make.height.mas_equalTo(49);
        }];
    } else {
        UIButton *btn1 = [self getBtnTitle:@"无法赴约" action:@selector(disagree)];
        btn1.alpha = 0.7;
        [self.view addSubview:btn1];
        [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.bottom.equalTo(self.view);
            make.width.mas_equalTo(SCREEN_WIDTH/2);
            make.height.mas_equalTo(49);
        }];

        UIButton *btn2 = [self getBtnTitle:@"确认赴约" action:@selector(agree)];
        btn2.alpha = 0.9;
        [self.view addSubview:btn2];
        [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.bottom.equalTo(self.view);
            make.width.mas_equalTo(SCREEN_WIDTH/2);
            make.height.mas_equalTo(49);
        }];
    }
}

- (UIButton *)getBtnTitle:(NSString *)title action:(SEL)action
{
    UIButton *btn1 = [[UIButton alloc] init];
    [btn1 setTitle:title];
    [btn1 setTitleColor:WhiteColor];
    btn1.titleLabel.font = BigTextFont;
    btn1.backgroundColor = MainColor;
    [btn1 addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return btn1;
}

@end
