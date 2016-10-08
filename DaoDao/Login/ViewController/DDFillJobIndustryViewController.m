//
//  DDFillJobIndustryViewController.m
//  DaoDao
//
//  Created by hetao on 16/9/28.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDFillJobIndustryViewController.h"
#import "DDConfig.h"

@interface DDFillJobIndustryViewController () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *labDesc;
@property (weak, nonatomic) IBOutlet UITextField *txtOne;
@property (weak, nonatomic) IBOutlet UITextField *txtTwo;
@property (weak, nonatomic) IBOutlet UITextField *txtThree;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *labOne;
@property (weak, nonatomic) IBOutlet UILabel *labTwo;
@property (weak, nonatomic) IBOutlet UILabel *labThree;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableTop;

@property (nonatomic, weak) UITextField *writing;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSMutableArray *searchArray;

@end

@implementation DDFillJobIndustryViewController

+ (instancetype)viewController
{
    DDFillJobIndustryViewController *vc = [[DDFillJobIndustryViewController alloc] initWithNibName:@"DDFillJobIndustryViewController" bundle:nil];
    return vc;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (self.isFillJob) {
        self.title = @"输入职务";
        self.labDesc.text = @"请输入您的职务，请至少输入1个，最多可输入3个职务。";
        self.data = [DDConfig job];
    } else {
        self.title = @"输入行业";
        self.labDesc.text = @"请输入您所在的行业，请至少输入1个，最多可输入3个行业";
        self.data = [DDConfig industry];
        self.labOne.text = @"行业一";
        self.labTwo.text = @"行业二";
        self.labThree.text = @"行业三";
    }
    self.searchArray = [NSMutableArray array];
    self.tableView.hidden = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [@[self.txtOne, self.txtTwo, self.txtThree] enumerateObjectsUsingBlock:^(UITextField *textField, NSUInteger idx, BOOL * _Nonnull stop) {
        [textField addTarget:self action:@selector(textFieldDidChange:)forControlEvents:UIControlEventEditingChanged];
        textField.delegate = self;
        if (!self.isFillJob) {
            [textField setPlaceholder:@"输入行业"];
        }
    }];

    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(fillDone)];
    [item setTintColor:SecondColor];

    RAC(item, enabled) =  [RACSignal combineLatest:@[self.txtOne.rac_textSignal,
                                                     self.txtTwo.rac_textSignal,
                                                     self.txtThree.rac_textSignal]
                                            reduce:^id(NSString *one,NSString *two,NSString *three){
                                                return @(one.length || two.length || three.length);
                                            }];

    self.navigationItem.rightBarButtonItem = item;
}

- (void)fillDone
{
    if (self.callback) {
        NSMutableString *str = [NSMutableString stringWithString:@""];
        for (NSString *text in @[self.txtOne.text,
                                 self.txtTwo.text,
                                 self.txtThree.text]) {
            if (text.length > 0) {
                [str appendFormat:@"%@,", text];
            }
        }
        !str.length ?: [str deleteCharactersInRange:NSMakeRange(str.length - 1, 1)];
        self.callback(str);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.txtOne) {
        self.tableTop.constant = -100;
    } else if (textField == self.txtTwo) {
        self.tableTop.constant = -50;
    } else {
        self.tableTop.constant = 0;
    }
    _writing = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.tableView.hidden = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    [self.searchArray removeAllObjects];
    NSString *searchText = textField.text;
    if (searchText.length == 0) {
        self.tableView.hidden = YES;
    } else {
        for (NSDictionary *dict in self.data) {
            NSString *text = dict[@"name"];
            if (text.length > 0) {
                NSRange range = [text rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if (range.location != NSNotFound) {
                    [self.searchArray addObject:text];
                }
            }
        }
        if (self.searchArray.count > 0) {
            self.tableView.hidden = NO;
            [self.tableView reloadData];
        } else {
            self.tableView.hidden = YES;
        }
    }
}


#pragma mark UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.searchArray[row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;

    if (row < self.searchArray.count) {
        self.writing.text = self.searchArray[row];
        [self.view endEditing:YES];
    }
}

@end
