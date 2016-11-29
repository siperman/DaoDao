//
//  SYKeyboardTopBar.m
//  Soouya
//
//  Created by hetao on 16/3/4.
//  Copyright © 2016年 Soouya. All rights reserved.
//

#import "SYKeyboardTopBar.h"

@interface SYKeyboardTopBar ()
@property (nonatomic, strong) UIView<UITextInput> *currentTextField;
@end

@implementation SYKeyboardTopBar

+ (instancetype)simpleKeyboardTopBar
{
    SYKeyboardTopBar * toolBar = [[SYKeyboardTopBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    [toolBar setBarStyle:UIBarStyleDefault];

    UIBarButtonItem * btnSpace = [[UIBarButtonItem  alloc] initWithBarButtonSystemItem:                                        UIBarButtonSystemItemFlexibleSpace target:toolBar action:nil];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:toolBar action:@selector(takebackkeyboard)];

    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];

    [toolBar setItems:buttonsArray];
    return toolBar;
}

+ (instancetype)keyboardTopBar
{
    SYKeyboardTopBar * toolBar = [[SYKeyboardTopBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    [toolBar setBarStyle:UIBarStyleDefault];

    UIBarButtonItem * backButton = [[UIBarButtonItem alloc] initWithImage:Image(@"btn_shouqi") style:UIBarButtonItemStylePlain target:toolBar action:@selector(showPrevious)];
    UIBarButtonItem * forwardButton = [[UIBarButtonItem alloc] initWithImage:Image(@"btn_xiala") style:UIBarButtonItemStylePlain target:toolBar action:@selector(showNext)];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem  alloc] initWithBarButtonSystemItem:                                        UIBarButtonSystemItemFlexibleSpace target:toolBar action:nil];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:toolBar action:@selector(takebackkeyboard)];

    NSArray * buttonsArray = [NSArray arrayWithObjects:backButton, forwardButton, btnSpace,doneButton,nil];

    [toolBar setItems:buttonsArray];
    return toolBar;
}

- (void)showBar:(UITextField *)textField
{
    self.currentTextField = textField;
    [textField setInputAccessoryView:self];
}

- (void)showPrevious{
    if (_textFields) {
        NSInteger num = -1;
        for (NSInteger i = 0; i < _textFields.count; i++) {
            if ([_textFields objectAtIndex:i] == _currentTextField) {
                num = i;
                break;
            }
        }
        if (num > 0){
            [[_textFields objectAtIndex:num - 1] becomeFirstResponder];
            [self showBar:[_textFields objectAtIndex:num - 1]];
        }
    }
}

- (void)showNext{
    if (_textFields) {
        NSInteger num = _textFields.count;
        for (NSInteger i = 0; i < _textFields.count; i++) {
            if ([_textFields objectAtIndex:i] == _currentTextField) {
                num = i;
                break;
            }
        }
        if (num < _textFields.count - 1){
            [[_textFields objectAtIndex:num + 1] becomeFirstResponder];
            [self showBar:[_textFields objectAtIndex:num + 1]];
        }
    }
}

- (void)takebackkeyboard {
    [_currentTextField resignFirstResponder];
}

@end
