//
//  DDMajorGradePickerView.m
//  DaoDao
//
//  Created by hetao on 16/9/27.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDMajorGradePickerView.h"
#import "DDConfig.h"

@interface DDMajorGradePickerView ()

@property (nonatomic, strong) NSArray <NSDictionary *>*majorGrades;
@property (nonatomic, strong) NSArray <NSNumber *>*grades;
@property (nonatomic, strong) NSString *major;
@property (nonatomic, strong) NSNumber *grade;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@end

@implementation DDMajorGradePickerView

+ (instancetype)majorGradePickerWithDelegate:(id<DDMajorGradePickerProtocol>) delegate
{
    DDMajorGradePickerView *picker = LoadView(@"DDMajorGradePickerView");
    picker.delegate = delegate;
    picker.majorGrades = [DDConfig majorGrade];
    picker.grades = [[picker.majorGrades firstObject] objectForKey:kValueKey];
    picker.major = [[picker.majorGrades firstObject] objectForKey:@"name"];
    picker.grade = [picker.grades firstObject];

    return picker;
}

#pragma Action
- (IBAction)cancel:(UIButton *)sender
{
    [self cancelPicker];
}

- (IBAction)done:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(pickedMajor:grade:)]) {
        [self.delegate pickedMajor:_major grade:_grade];
    }
    [self cancelPicker];
}

/*
 "majorGrade":[{"name":"DBA","value":[1,2,3]},{"name":"EMBA","value":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28]},{"name":"CEO班","value":[1,2,3,4,5,6,7,8,9,10,11]},{"name":"MBA","value":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]},{"name":"FMBA","value":[1,2,3,4,5,6,7,8,9,10,11,12,13,14]}
 */
#pragma mark - PickerView lifecycle

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [_majorGrades count];
            break;
        case 1:
            return [_grades count];
            break;
        default:
            return 0;
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [[_majorGrades objectAtIndex:row] objectForKey:@"name"];
            break;
        case 1:
            return [NSString stringWithFormat:@"%@期", [_grades objectAtIndex:row]];
            break;
        default:
            return @"";
            break;
    }}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            _grades = [[_majorGrades objectAtIndex:row] objectForKey:kValueKey];
            [self.pickerView selectRow:0 inComponent:1 animated:YES];
            [self.pickerView reloadComponent:1];

            self.major = [[_majorGrades objectAtIndex:row] objectForKey:@"name"];
            self.grade = [_grades objectAtIndex:0];
            break;
        case 1:
            self.grade = [_grades objectAtIndex:row];
            break;
        default:
            break;
    }
}

- (void)pickedMajor:(NSString *)major grade:(NSNumber *)grade
{
    if (major.length > 0) {
        for (NSInteger row = 0; row < _majorGrades.count; row++) {
            if ([major isEqualToString:[[_majorGrades objectAtIndex:row] objectForKey:@"name"]]) {
                [self.pickerView selectRow:row inComponent:0 animated:NO];
                self.major = major;
                _grades = [[_majorGrades objectAtIndex:row] objectForKey:kValueKey];
                [self.pickerView reloadComponent:1];

                break;
            }
        }
    }

    if (grade) {
        for (NSInteger row = 0; row < _grades.count; row++) {
            if ([grade isEqualToNumber:[_grades objectAtIndex:row]]) {
                self.grade = grade;
                [self.pickerView selectRow:row inComponent:1 animated:NO];

                break;
            }
        }
    }

}

#pragma mark - animation

- (void)showInView:(UIView *) view
{
    self.frame = CGRectMake(0, view.frame.size.height, SCREEN_WIDTH, 150);
    [view addSubview:self];

    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, view.frame.size.height - 150, SCREEN_WIDTH, 150);
    }];

}

- (void)cancelPicker
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.frame = CGRectMake(0, self.frame.origin.y+150, SCREEN_WIDTH, 150);
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];

                     }];

}

@end
