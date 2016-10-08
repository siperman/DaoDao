//
//  HZAreaPickerView.h
//  areapicker
//
//  Created by Cloud Dai on 12-9-9.
//  Copyright (c) 2012年 clouddai.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    HZAreaPickerWithStateAndCity,
    HZAreaPickerWithStateAndCityAndDistrict
} HZAreaPickerStyle;

@class HZAreaPickerView, HZLocation;

@protocol HZAreaPickerDelegate <NSObject>

@optional
- (void)pickerDidChaneStatus:(HZAreaPickerView *)picker;

@end

@interface HZAreaPickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (assign, nonatomic) id <HZAreaPickerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIPickerView *locatePicker;
@property (strong, nonatomic) HZLocation *locate;
@property (nonatomic) HZAreaPickerStyle pickerStyle;

+ (instancetype)areaPickerWithDelegate:(id<HZAreaPickerDelegate>) delegate;
- (void)showInView:(UIView *)view;
- (void)cancelPicker;

@end

@interface HZLocation : NSObject

@property (copy, nonatomic) NSString *state;
@property (copy, nonatomic) NSString *city;
@property (copy, nonatomic) NSString *district;

@end
