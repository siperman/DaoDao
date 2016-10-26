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

- (void)setUpData
{
    _labName.text = _ask.answer.user.title;
    _labDemand.text = _ask.demand;
    _labTime.text = [SYUtils dateFormInterval:_ask.answer.meet.time.doubleValue];
    _labAddr.text = [NSString stringWithFormat:@"%@%@", _ask.answer.meet.city, _ask.answer.meet.addr];
}

@end
