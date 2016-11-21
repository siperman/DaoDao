//
//  DDUpdateUserInfoViewController.m
//  DaoDao
//
//  Created by hetao on 2016/11/15.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDUpdateUserInfoViewController.h"

@interface DDUpdateUserInfoViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView *topView;
@end

@implementation DDUpdateUserInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = BackgroundColor;

    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(updateUserInfo)];
    self.navigationItem.rightBarButtonItem = item;

    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.view).offset(64);
        make.height.mas_equalTo(50);
    }];

    RAC(item, enabled) = [RACSignal combineLatest:@[self.textField.rac_textSignal] reduce:^(NSString *text){
        return @(text.length > 0);
    }];

    if (self.isUpdateYear) {
        self.title = @"从业时间";
    } else {
        self.title = @"花名";
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.textField becomeFirstResponder];
}

- (void)updateUserInfo
{
    id params;
    if (self.isUpdateYear) {
        params = @{@"year" : self.textField.text};
    } else {
        params = @{@"nickName" : self.textField.text};
    }
    [self.navigationController showLoadingHUD];
    [SYRequestEngine updateUserInfo:params avatar:nil callback:^(BOOL success, id response) {
        [self.navigationController hideAllHUD];
        if (success) {
            DDUser *user = [DDUser fromDict:response[kObjKey]];
            [DDUserManager manager].user = user;
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self.navigationController showRequestNotice:response];
        }
    }];
}

- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = WhiteColor;
        _textField = [[UITextField alloc] init];
        _textField.font = NormalTextFont;
        _textField.textColor = MainColor;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_topView addSubview:_textField];
        if (self.isUpdateYear) {
            _textField.keyboardType = UIKeyboardTypeNumberPad;
            _textField.text = [NSString stringWithFormat:@"%@", [DDUserManager manager].user.year];
            [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(_topView).insets(UIEdgeInsetsMake(0, 22, 0, 70));
            }];
            UILabel *lab = [[UILabel alloc] init];
            lab.font = NormalTextFont;
            lab.textColor = MainColor;
            lab.text = @"年";
            [_topView addSubview:lab];
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(_topView);
                make.trailing.equalTo(_topView).offset(-26);
            }];
        } else {
            _textField.text = [DDUserManager manager].user.nickName;
            [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(_topView).insets(UIEdgeInsetsMake(0, 22, 0, 26));
            }];
        }
        _textField.delegate = self;
    }

    return _topView;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.isUpdateYear) {
        NSString *year = [textField.text stringByReplacingCharactersInRange:range withString:string];
        return year.integerValue <= 60;
    } else {
        NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
        return text.length <= 8;
    }
}



@end
