//
//  DDMajorGradePickerView.h
//  DaoDao
//
//  Created by hetao on 16/9/27.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DDMajorGradePickerProtocol <NSObject>

@optional
- (void)pickedMajor:(NSString *)major grade:(NSNumber *)grade;

@end

@interface DDMajorGradePickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, weak) id<DDMajorGradePickerProtocol> delegate;

+ (instancetype)majorGradePickerWithDelegate:(id<DDMajorGradePickerProtocol>) delegate;
- (void)showInView:(UIView *)view;
- (void)cancelPicker;
@end
