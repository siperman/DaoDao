//
//  Created by Luka Gabrić.
//  Copyright (c) 2013 Luka Gabrić. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPlaceholderTextView : UITextView

@property (nonatomic) CGRect placeholderLabelRect;
@property (strong, nonatomic) UILabel *placeholderLabel;
@property (strong, nonatomic) NSString *placeholderText;
@property (strong, nonatomic) UIColor *placeholderColor;


@end