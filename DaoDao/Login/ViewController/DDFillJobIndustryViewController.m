//
//  DDFillJobIndustryViewController.m
//  DaoDao
//
//  Created by hetao on 16/9/28.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDFillJobIndustryViewController.h"
#import "MLPAutoCompleteTextField.h"
#import "DDConfig.h"

@interface DDFillJobIndustryViewController () <UITextFieldDelegate, MLPAutoCompleteTextFieldDataSource>

@property (weak, nonatomic) IBOutlet UILabel *labDesc;
@property (weak, nonatomic) IBOutlet MLPAutoCompleteTextField *txtOne;
@property (weak, nonatomic) IBOutlet MLPAutoCompleteTextField *txtTwo;
@property (weak, nonatomic) IBOutlet MLPAutoCompleteTextField *txtThree;
@property (weak, nonatomic) IBOutlet UILabel *labOne;
@property (weak, nonatomic) IBOutlet UILabel *labTwo;
@property (weak, nonatomic) IBOutlet UILabel *labThree;
@property (weak, nonatomic) IBOutlet UIView *inputView;

@property (nonatomic, strong) NSArray *data;

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
        self.labDesc.text = @"请输入您的职务，请至少输入1个，最多3个";
        self.data = [DDConfig job];
    } else {
        self.title = @"输入行业";
        self.labDesc.text = @"请输入您的行业，请至少输入1个，最多3个";
        self.data = [DDConfig industry];
        self.labOne.text = @"行业一";
        self.labTwo.text = @"行业二";
        self.labThree.text = @"行业三";
    }
    [self.labDesc setTextColor:TextColor];

    NSArray *strs = nil;
    if (self.fillStr) {
        self.fillStr = [self.fillStr stringByReplacingOccurrencesOfString:@"，" withString:@","];
        strs = [self.fillStr componentsSeparatedByString:@","];
    }
    [@[self.txtOne, self.txtTwo, self.txtThree] enumerateObjectsUsingBlock:^(MLPAutoCompleteTextField *textField, NSUInteger idx, BOOL * _Nonnull stop) {
        textField.delegate = self;
        if (!self.isFillJob) {
            [textField setPlaceholder:@"输入行业"];
        }
        if (strs.count > idx) {
            textField.text = strs[idx];
        }
        [textField normalStyle];
        textField.autoCompleteTableBorderColor = SepColor;
        textField.autoCompleteTableCellTextColor = TextColor;
        textField.autoCompleteTableBackgroundColor = WhiteColor;
        textField.maximumNumberOfAutoCompleteRows = 4;
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
                [str appendFormat:@"%@，", text];
            }
        }
        !str.length ?: [str deleteCharactersInRange:NSMakeRange(str.length - 1, 1)];
        self.callback(str);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickBtn:(UIButton *)sender
{
    [self.view endEditing:YES];
    sender.selected = !sender.selected;
    self.navigationItem.rightBarButtonItem.enabled = sender.selected;
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return textField.text.length + string.length <= 10;
}

#pragma mark - MLPAutoCompleteTextField Delegate


//- (BOOL)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
//          shouldConfigureCell:(UITableViewCell *)cell
//       withAutoCompleteString:(NSString *)autocompleteString
//         withAttributedString:(NSAttributedString *)boldedString
//        forAutoCompleteObject:(id<MLPAutoCompletionObject>)autocompleteObject
//            forRowAtIndexPath:(NSIndexPath *)indexPath {
//    //This is your chance to customize an autocomplete tableview cell before it appears in the autocomplete tableview
//    cell.textLabel.text = self.searchArray[indexPath.row];
//
//    return YES;
//}

//- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
//  didSelectAutoCompleteString:(NSString *)selectedString
//       withAutoCompleteObject:(id<MLPAutoCompletionObject>)selectedObject
//            forRowAtIndexPath:(NSIndexPath *)indexPath {
//    !_clientIDHandler ?: _clientIDHandler(selectedString);
//}

- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField willHideAutoCompleteTableView:(UITableView *)autoCompleteTableView {
    NSLog(@"Autocomplete table view will be removed from the view hierarchy");
}

- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField willShowAutoCompleteTableView:(UITableView *)autoCompleteTableView {
    NSLog(@"Autocomplete table view will be added to the view hierarchy");
}

- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField didHideAutoCompleteTableView:(UITableView *)autoCompleteTableView {
    NSLog(@"Autocomplete table view ws removed from the view hierarchy");
}

- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField didShowAutoCompleteTableView:(UITableView *)autoCompleteTableView {
    NSLog(@"Autocomplete table view was added to the view hierarchy");
}

- (NSArray *)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
      possibleCompletionsForString:(NSString *)string
{
    NSMutableArray *array = [NSMutableArray array];
    NSString *searchText = string;
    if (searchText.length > 0) {
        for (NSDictionary *dict in self.data) {
            NSString *text = dict[@"name"];
            if (text.length > 0) {
                NSRange range = [text rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if (range.location != NSNotFound) {
                    [array addObject:text];
                }
            }
        }
    }
    return array;
}

@end
