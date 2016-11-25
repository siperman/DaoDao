//
//  DDRateViewController.m
//  DaoDao
//
//  Created by hetao on 2016/11/6.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDRateViewController.h"
#import "DDRateViewModel.h"
#import "DDConfig.h"

@interface DDRateViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imgHead;
@property (weak, nonatomic) IBOutlet UIImageView *imgGender;
@property (weak, nonatomic) IBOutlet UIImageView *imgBig;

@property (weak, nonatomic) IBOutlet UILabel *labName; // 花名
@property (weak, nonatomic) IBOutlet UILabel *labGrade; // 届别
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) UIButton *btnSubmit;
@property (nonatomic, strong) DDRateViewModel *viewModel;
@end

#define DD_HAPPY_TAG   1
#define DD_USEFUL_TAG  2
#define DD_IMPRESS_TAG 3

@implementation DDRateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MobClick event:AssessBtn_click];

    UIImage *image = [Image(@"bg_yaoqingma") resizableImageWithCapInsets:UIEdgeInsetsMake(30.0f, 0.0f, 30.0f, 0.0f) resizingMode:UIImageResizingModeStretch];
    self.imgBig.image = image;

    [self.imgHead sy_round];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self layoutScrollView];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)layoutScrollView
{
    if (self.scrollView.subviews.count > 0) {
        return;
    }
//    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    DDUser *user;
    if (self.ask.isMyAsk) {
        user = self.ask.answer.user;
    } else {
        user = self.ask.user;
    }
    [self.imgHead sy_setThumbnailImageWithUrl:user.headUrl];
    [self.imgGender setImage:user.genderImage];

    self.labName.text = user.title;
    self.labGrade.text = MajorGrade(user.major, user.grade);

    CGSize size = self.scrollView.frame.size;
    [self.scrollView setContentSize:CGSizeMake(size.width * 3, size.height)];

    if (user.gender.boolValue) {
        self.viewModel.rateArray = [DDConfig femaleRate];
    } else {
        self.viewModel.rateArray = [DDConfig maleRate];
    }

    for (NSInteger i = 0; i < 3; i++) {
        UIView *view = [self rateViewWithTag:i + 1];

        [self.scrollView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.top.equalTo(self.scrollView);
            make.left.equalTo(self.scrollView).offset(i * self.scrollView.width);
        }];
    }

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

- (void)submitRate
{
    [MobClick event:SubmitAssessBtn_click];
    id params = @{kIDKey : self.ask.aid,
                  @"useful" : self.viewModel.useful,
                  @"happy" : self.viewModel.happy,
                  @"impress" : self.viewModel.impress};

    [self.navigationController showLoadingHUD];
    AZNetworkResultBlock callback = ^(BOOL success, id response) {
        [self.navigationController hideAllHUD];
        if (success) {
            DDAsk *ask = [DDAsk fromDict:response[kObjKey]];
            NSDictionary *info = @{ kOldAskKey : self.ask,
                                    kNewAskKey : ask};
            POST_NOTIFICATION(kUpdateAskInfoNotification, info);
            [[DDUserManager manager] touchUser];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self.navigationController showRequestNotice:response];
        }
    };
    if (self.ask.isMyAsk) {
        [SYRequestEngine rateAnswerWithParams:params callback:callback];
    } else {
        [SYRequestEngine rateAskWithParams:params callback:callback];
    }
}

- (void)collectRate:(UIView *)view
{
    NSMutableString *str = [NSMutableString string];
    for (UIView *subview in view.subviews) {
        if ([subview isKindOfClass:[UISegmentedControl class]]) {
            UISegmentedControl *seg = (UISegmentedControl *)subview;
            if (seg.selectedSegmentIndex >= 0) {
                NSInteger tag = seg.tag - DD_IMPRESS_TAG; // for lab
                NSInteger idx = seg.selectedSegmentIndex; // for value
                NSDictionary *rateDict = self.viewModel.rateArray[tag];
                NSString *name = rateDict[kTagsNameKey];
                NSString *value = rateDict[kTagsValueKey][idx];

                if (str.length > 0) {
                    [str appendFormat:@",%@@%@", name, value];
                } else {
                    [str appendFormat:@"%@@%@", name, value];
                }
            }
        }
    }
    self.viewModel.impress = [str copy];
}

- (void)segAction:(UISegmentedControl *)seg
{
    if (seg.tag >= DD_IMPRESS_TAG) {
        _btnSubmit.enabled = YES;
        [self collectRate:seg.superview];
        return;
    } else if (seg.tag == DD_HAPPY_TAG) {
        if (seg.selectedSegmentIndex == 0) {
            self.viewModel.happy = [NSNumber numberWithInt:1];
        } else {
            self.viewModel.happy = [NSNumber numberWithInt:0];
        }
    } else {
        if (seg.selectedSegmentIndex == 0) {
            self.viewModel.useful = [NSNumber numberWithInt:1];
        } else {
            self.viewModel.useful = [NSNumber numberWithInt:0];
        }
    }
    CGFloat width = self.scrollView.width;
    CGFloat height = self.scrollView.height;

    [UIView animateWithDuration:kAnimationDuration
                     animations:^{
                         seg.superview.alpha = 0;
                     } completion:^(BOOL finished) {
                         [self.scrollView scrollRectToVisible:CGRectMake(width * seg.tag, 0, width, height) animated:YES];
                     }];
}

- (UIView *)rateViewWithTag:(NSInteger)tag
{
    if (tag == DD_IMPRESS_TAG) {
        return [self lastRateView];
    }
    UIView *view = [[UIView alloc] init];

    NSString *text = @"本次约局是否有收获?";
    NSArray *items = @[@"是", @"否"];
    if (tag == DD_HAPPY_TAG) {
        text = @"请选择本次见面的整体感受";
        items = @[@"愉快", @"乏味"];
    }
    UILabel *lab = [[UILabel alloc] init];
    lab.textColor = MainColor;
    lab.font = Font(21);
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = text;
    [view addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).offset(60);
        make.leading.trailing.equalTo(view);
    }];

    UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:items];
    seg.tag = tag;
    seg.tintColor = SecondColor;
    [seg setTitleTextAttributes:@{NSFontAttributeName : Font(17)} forState:UIControlStateNormal];
    [seg setTitleTextAttributes:@{NSForegroundColorAttributeName : TextColor} forState:UIControlStateNormal];


    seg.layer.cornerRadius = 20;
    seg.layer.borderColor = SecondColor.CGColor;
    seg.layer.borderWidth = 1;
    seg.clipsToBounds = YES;

    [view addSubview:seg];
    [seg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab.mas_bottom).offset(100);
        make.centerX.equalTo(view);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(40);
    }];
    [seg addTarget:self action:@selector(segAction:) forControlEvents:UIControlEventValueChanged];

    return view;
}

- (UIView *)lastRateView
{
    UIView *view = [[UIView alloc] init];
    UILabel *lab = [[UILabel alloc] init];
    lab.textColor = MainColor;
    lab.font = Font(18);
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = @"您对TA感受最深的是";
    [view addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(view);
    }];

    CGFloat segHeight = 32.0;
    CGFloat spaceHeight = 56.0;
    CGFloat offsetHeight = segHeight + 18.0;
    for (NSInteger idx = 0; idx < self.viewModel.rateArray.count && idx < 5; idx++) {
        NSDictionary *rateDict = self.viewModel.rateArray[idx];
        UILabel *lab = [[UILabel alloc] init];
        lab.textColor = SecondColor;
        lab.font = Font(17);
        lab.text = rateDict[kTagsNameKey];
        [view addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(view);
            make.top.equalTo(view).offset(spaceHeight + idx * offsetHeight);
            make.height.mas_equalTo(segHeight);
        }];

        NSArray *items = rateDict[kTagsValueKey];
        UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:items];
        seg.tag = DD_IMPRESS_TAG + idx;
        seg.tintColor = SecondColor;
        [seg setTitleTextAttributes:@{NSFontAttributeName : Font(14),
                                      NSForegroundColorAttributeName : TextColor}
                           forState:UIControlStateNormal];

        seg.layer.cornerRadius = segHeight/2;
        seg.layer.borderColor = SecondColor.CGColor;
        seg.layer.borderWidth = 1;
        seg.clipsToBounds = YES;
        [view addSubview:seg];
        [seg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(view).offset(88);
            make.trailing.equalTo(view);
            make.top.equalTo(view).offset(spaceHeight + idx * offsetHeight);
            make.height.mas_equalTo(segHeight);
        }];
        [seg addTarget:self action:@selector(segAction:) forControlEvents:UIControlEventValueChanged];
    }

    _btnSubmit = [[UIButton alloc] init];
    [_btnSubmit setTitle:@"提交匿名评价"];
    [_btnSubmit actionStyle];
    _btnSubmit.titleLabel.font = Font(15);
    _btnSubmit.layer.cornerRadius = 20;
    [view addSubview:_btnSubmit];
    [_btnSubmit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.bottom.equalTo(view).offset(-10);
        make.width.mas_equalTo(160);
        make.height.mas_equalTo(40);
    }];
    [_btnSubmit addTarget:self action:@selector(submitRate) forControlEvents:UIControlEventTouchUpInside];
    _btnSubmit.enabled = NO;

    return view;
}

- (DDRateViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [[DDRateViewModel alloc] init];
    }
    return _viewModel;
}

@end
