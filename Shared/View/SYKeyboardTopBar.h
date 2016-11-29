//
//  SYKeyboardTopBar.h
//  Soouya
//
//  Created by hetao on 16/3/4.
//  Copyright © 2016年 Soouya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYKeyboardTopBar : UIToolbar

@property (nonatomic, strong) NSArray<UIView<UITextInput>*> *textFields;
+ (instancetype)keyboardTopBar;
+ (instancetype)simpleKeyboardTopBar;

- (void)showBar:(UIView<UITextInput>*)textfield;
@end
