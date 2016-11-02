//
//  DDAskBaseViewController.m
//  DaoDao
//
//  Created by hetao on 2016/10/27.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDAskBaseViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface DDAskBaseViewController ()

@end

@implementation DDAskBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = BackgroundColor;
    self.title = @"详情";

    [self.tableView registerNib:[DDUserInfoTableViewCell class]];
    [self.tableView registerNib:[DDDemandInfoTableViewCell class]];
    [self.tableView registerNib:[DDDemandInfoSmallTableViewCell class]];
    [self.tableView registerNib:[DDAskHandOutTableViewCell class]];

}

- (void)refresh
{
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    BOOL hasHead = NO;
    if (hasHead) {
        [self.view addSubview:self.labHead];
        [self.labHead mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(self.view);
            make.height.mas_equalTo(@50);
        }];
    }
    [self.view addSubview:self.tableView];
    UIEdgeInsets edge = UIEdgeInsetsMake(hasHead ? 50 : 0, 0, 50, 0);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(edge);
    }];

    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.equalTo(self.view);
        make.height.mas_equalTo(@50);
    }];

    BOOL hasTwoBtn = NO;
    if (hasTwoBtn) {
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
        btn1.alpha = 0.7;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSAssert(false, @"rewrite this function");
    return 0;
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
