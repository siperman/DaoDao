//
//  DDAskBaseViewController.m
//  DaoDao
//
//  Created by hetao on 2016/10/27.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDAskBaseViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "DDAskDetailViewController.h"

@interface DDAskBaseViewController ()

@end

@implementation DDAskBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = BackgroundColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"详情";

    [self.tableView registerNib:[DDUserInfoTableViewCell class]];
    [self.tableView registerNib:[DDDemandInfoTableViewCell class]];
    [self.tableView registerNib:[DDDemandInfoSmallTableViewCell class]];
    [self.tableView registerNib:[DDAskHandOutTableViewCell class]];
    [self.tableView registerNib:[DDAskRateInfoTableViewCell class]];

    [self subscribeNotication:kUpdateAskInfoNotification selector:@selector(handleNotification:)];
}

- (void)handleNotification:(NSNotification*) notification
{
    NSDictionary *userInfo = [notification userInfo];
    if ([userInfo isKindOfClass:[NSDictionary class]]) {
        DDAsk *oldAsk = userInfo[kOldAskKey];
        DDAsk *newAsk = userInfo[kNewAskKey];
        if (oldAsk == _ask) {
            [self setAsk:newAsk];
        }
    }
}

- (void)refresh
{
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _labHead = nil;
    _bottomView = nil;

    NSInteger offsetTop = 64;
    BOOL hasHead = self.showHead;
    if (hasHead) {
        [self.view addSubview:self.labHead];
        [self.labHead mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self.view);
            make.top.equalTo(self.view).offset(offsetTop);
            make.height.mas_equalTo(@50);
        }];
        if (_ask.isMyAsk) {
            if (_ask.status.integerValue == DDAskWaitingAgreeMeet) {
                self.labHead.text = @"已发邀请函，请等待对方确认赴约";
            } else if (_ask.status.integerValue == DDAskWaitingMeet) {
                NSString *timeStr = [NSString stringWithFormat:@"距离见面时间：%@", [SYUtils dateDetailSinceNowFormInterval:_ask.answer.meet.time]];
                NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:timeStr];
                [attrStr setAttributes:@{NSForegroundColorAttributeName : SecondColor} range:NSMakeRange(7, timeStr.length - 7)];
                self.labHead.attributedText = attrStr;
            } else if (_ask.status.integerValue == DDAskAnswerRate ||
                       _ask.status.integerValue == DDAskBothRate) {
                self.labHead.text = @"已完成评价，约见结束";
            } else if (_ask.status.integerValue == DDAskAnswerDisagreeMeet) {
                self.labHead.text = @"对方拒绝赴约，约见结束！";
            } else {
                hasHead = NO;
                self.labHead.hidden = YES;
            }
        } else {
            if (_ask.status.integerValue == DDAskAnswerDisagreeMeet) {
                self.labHead.text = @"已失效！您拒绝了赴约对方的邀请";
                self.labHead.textColor = SecondColor;
//            } else if (_ask.status.integerValue == DDAskAskerRate ||  //应局完成不显示labHead
//                       _ask.status.integerValue == DDAskBothRate) {
//                self.labHead.text = @"已完成评价，约见结束";
            } else {
                hasHead = NO;
                self.labHead.hidden = YES;
            }
        }
    } else {
        // 注意：后来新增约局详情也有labHead的情况
        if (_ask.isMyAsk &&
            _ask.status.integerValue == DDAskBothRate) {
            [self.view addSubview:self.labHead];
            [self.labHead mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.trailing.equalTo(self.view);
                make.top.equalTo(self.view).offset(offsetTop);
                make.height.mas_equalTo(@50);
            }];

            self.labHead.text = @"恭喜！本次约局已完成！";
            hasHead = YES;
        }
    }
    [self.view addSubview:self.tableView];
    UIEdgeInsets edge = UIEdgeInsetsMake(hasHead ? 50 + offsetTop : offsetTop, 0, 50, 0);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(edge);
    }];

    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.equalTo(self.view);
        make.height.mas_equalTo(@50);
    }];

    BOOL hasTwoBtn = self.showHead;
    if (hasTwoBtn && _ask.isMyAsk) {
        UIButton *btn1 = [self getBtnTitle:@"查看其它响应者" action:@selector(checkOtherAsk)];
        btn1.alpha = 0.7;
        [self.bottomView addSubview:btn1];
        [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.bottom.equalTo(self.bottomView);
            make.width.mas_equalTo(SCREEN_WIDTH/2);
        }];

        UIButton *btn2 = [self getBtnTitle:@"客服帮助" action:@selector(call)];
        btn2.alpha = 0.9;
        [self.bottomView addSubview:btn2];
        [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.top.bottom.equalTo(self.bottomView);
            make.width.mas_equalTo(SCREEN_WIDTH/2);
        }];
    } else {
        NSString *title = [NSString stringWithFormat:@"客服帮助请点击%@", kServiceCall];
        UIButton *btn1 = [self getBtnTitle:title action:@selector(call)];
        btn1.alpha = 0.8;
        [self.bottomView addSubview:btn1];
        [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.bottomView).insets(UIEdgeInsetsZero);
        }];
    }
}

- (void)call
{
    [self makeCall:kServiceCall];
}

- (void)checkOtherAsk
{
    NSArray *vcs = self.navigationController.viewControllers;

    if (vcs.count > 2 &&
        [vcs[vcs.count - 2] isKindOfClass:[DDAskDetailViewController class]]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        DDAskDetailViewController *vc = [[DDAskDetailViewController alloc] init];
        vc.ask = self.ask;
        [self.navigationController pushViewController:vc animated:YES];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSAssert(false, @"rewrite this function");
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Class class = [self cellClassForRowAtIndexPath:indexPath];
    DDBaseTableViewCell *cell = [tableView dequeueCell:class indexPath:indexPath];
    [cell configureCellWithData:self.ask];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Class class = [self cellClassForRowAtIndexPath:indexPath];
    return [tableView fd_heightForCellWithIdentifier:NSStringFromClass(class) cacheByIndexPath:indexPath configuration:^(DDBaseTableViewCell *cell) {
        [cell configureCellWithData:self.ask];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (Class)cellClassForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger status = self.ask.status.integerValue;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;

    if (status == DDAskPostSuccess ||
        status == DDAskWaitingHandOut ||
        status == DDAskWaitingAnswerInterest) {
        if (section == 0) {
            if (self.showSmall) {
                return [DDDemandInfoSmallTableViewCell class];
            } else {
                return [DDDemandInfoTableViewCell class];
            }
        } else if (section == 1) {
            return [DDAskHandOutTableViewCell class];
        }

    }
    
    return [UITableViewCell class];
}

#pragma mark - Setter / Getter

- (void)setAsk:(DDAsk *)ask
{
    if (_ask != ask) {
        _ask = ask;
        [_tableView reloadData];
        [self refresh];
    }
}

- (UILabel *)labHead
{
    if (!_labHead) {
        _labHead = [[UILabel alloc] init];
        _labHead.textColor = MainColor;
        _labHead.textAlignment = NSTextAlignmentCenter;
        _labHead.font = NormalTextFont;
        _labHead.backgroundColor = WhiteColor;
    }
    return _labHead;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = BackgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionHeaderHeight = 10.0;
        _tableView.sectionFooterHeight = CGFLOAT_MIN;
        _tableView.tableHeaderView = [UIView new];
    }
    return _tableView;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = ClearColor;
    }
    return _bottomView;
}
@end
