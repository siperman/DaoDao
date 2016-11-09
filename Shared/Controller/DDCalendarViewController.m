//
//  DDCalendarViewController.m
//  DaoDao
//
//  Created by hetao on 16/9/23.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDCalendarViewController.h"
#import <FSCalendar/FSCalendar.h>

@interface DDCalendarViewController () <FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance>

@property (nonatomic, strong) FSCalendar *calendar;
@property (strong, nonatomic) NSCalendar *gregorianCalendar;

@property (strong, nonatomic) NSCalendar *lunarCalendar;
@property (strong, nonatomic) NSArray *lunarChars;

@property (strong, nonatomic) NSDateFormatter *dateFormatter1;
@property (strong, nonatomic) NSDateFormatter *dateFormatter2;
@property (strong, nonatomic) NSDateFormatter *dateFormatter3;

@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) UILabel *labTime;
@property (strong, nonatomic) UIView *timeView;

@property (nonatomic) NSTimeInterval time;
@end

@implementation DDCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BackgroundColor;

    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    self.navigationItem.rightBarButtonItem = item;
    [item setTintColor:BarTintColor];
    item.enabled = NO;

    [self.view addSubview:self.calendar];
    [self.calendar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.view).offset(64);
        make.height.mas_equalTo(300);
    }];

    [self.view addSubview:self.timeView];
    [self.timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.calendar.mas_bottom).offset(10);
        make.height.mas_equalTo(40);
    }];

    [self.view addSubview:self.datePicker];
    [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.top.equalTo(self.timeView.mas_bottom);
    }];

    [self setUpData];
    self.timeView.alpha = 0;
    self.datePicker.alpha = 0;
}

- (void)setUpData
{
    NSLocale *chinese = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];

    self.gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

    self.dateFormatter1 = [[NSDateFormatter alloc] init];
    self.dateFormatter1.locale = chinese;
    self.dateFormatter1.dateFormat = @"yyyy/MM/dd";

    self.dateFormatter2 = [[NSDateFormatter alloc] init];
    self.dateFormatter2.locale = chinese;
    self.dateFormatter2.dateFormat = @"yyyy/MM/dd HH:mm";

    self.dateFormatter3 = [[NSDateFormatter alloc] init];
    self.dateFormatter3.locale = chinese;
    self.dateFormatter3.dateFormat = @"yyyy年M月";

    self.lunarCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    self.lunarCalendar.locale = chinese;
    self.lunarChars = @[@"初一",@"初二",@"初三",@"初四",@"初五",@"初六",@"初七",@"初八",@"初九",@"初十",@"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十",@"二一",@"二二",@"二三",@"二四",@"二五",@"二六",@"二七",@"二八",@"二九",@"三十"];

    [self configureCalendar];

    self.title = [self.dateFormatter3 stringFromDate:[NSDate date]];
}

- (void)done
{
    if ([self.delegete respondsToSelector:@selector(chooseTime:)]) {
        [self.delegete chooseTime:_time];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)configureCalendar
{
    _calendar.placeholderType = FSCalendarPlaceholderTypeNone;
    _calendar.headerHeight = 0;
    _calendar.weekdayHeight = 34.0;

    FSCalendarAppearance *appearance = _calendar.appearance;

    appearance.titleWeekendColor = ColorHex(@"9e9e9e");
    appearance.subtitleWeekendColor = ColorHex(@"9e9e9e");
    appearance.weekdayTextColor = ColorHex(@"f87127");
    appearance.weekdayFont = Font(16);
    appearance.headerTitleColor = ColorHex(@"3f2622");
    appearance.selectionColor = SecondColor;
    appearance.todayColor = ClearColor;
    appearance.titleTodayColor = ColorHex(@"3f2622");
    appearance.subtitleTodayColor = ColorHex(@"3f2622");
    appearance.titleFont =Font(16);
    appearance.subtitleFont =Font(11);
    appearance.headerTitleFont = Font(16);
    appearance.adjustsFontSizeToFitContentSize = NO;
    appearance.headerMinimumDissolvedAlpha = 0.0;
}

#pragma mark - FSCalendarDataSource

//- (NSString *)calendar:(FSCalendar *)calendar titleForDate:(NSDate *)date
//{
//    return [self.gregorianCalendar isDateInToday:date] ? @"今天" : nil;
//}

- (NSString *)calendar:(FSCalendar *)calendar subtitleForDate:(NSDate *)date
{
    NSInteger day = [_lunarCalendar components:NSCalendarUnitDay fromDate:date].day;
    return _lunarChars[day-1];
}

- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar
{
    // 月初
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSCalendarUnitDay ) fromDate:[NSDate date]];
    [components setDay:-([components day] - 1)];

    NSDate *minDate = [cal dateByAddingComponents:components toDate:[NSDate date] options:0];

    return minDate;
}

- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar
{
    // 一年后
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSCalendarUnitYear ) fromDate:[NSDate date]];
    components.year = 1;

    NSDate *maxDate = [cal dateByAddingComponents:components toDate:[NSDate date] options:0];

    return maxDate;
}

#pragma mark - FSCalendarDelegate

- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date
{
    // 只能选大于今天的日期
    return [date compare:[NSDate date]] == NSOrderedDescending;
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date
{
    NSLog(@"did select date %@",[self.dateFormatter1 stringFromDate:date]);
    CGRect frame = [self.calendar frameForDate:date];
    NSLog(@"%@",NSStringFromCGRect(frame));

    [self.datePicker setDate:date animated:YES];
    [self changeTime:date];
    if (self.datePicker.alpha == 0) {
        [UIView animateWithDuration:kAnimationDuration animations:^{
            self.datePicker.alpha = 1;
            self.timeView.alpha = 1;
        }];
    }
}

- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar
{
    NSLog(@"did change to page %@",[self.dateFormatter1 stringFromDate:calendar.currentPage]);

    self.title = [self.dateFormatter3 stringFromDate:calendar.currentPage];

    [self.datePicker setDate: calendar.currentPage animated:YES];
}

- (void)calendarCurrentScopeWillChange:(FSCalendar *)calendar animated:(BOOL)animated
{
    debugLog(@"width %0.2f, height %0.2f", [calendar sizeThatFits:CGSizeZero].width, [calendar sizeThatFits:CGSizeZero].height);
    [self.calendar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo([calendar sizeThatFits:CGSizeZero].height);
    }];

    [self.view layoutIfNeeded];
}

- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated
{
    debugLog(@"width %0.2f, height %0.2f", bounds.size.width, bounds.size.height);

    [self.calendar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(CGRectGetHeight(bounds));
    }];

    [self.view layoutIfNeeded];
}

- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance borderDefaultColorForDate:(NSDate *)date
{
    return [_lunarCalendar isDateInToday:date] ? SecondColor : appearance.borderDefaultColor;
}

- (CGFloat)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance borderRadiusForDate:(nonnull NSDate *)date
{
    return [_lunarCalendar isDateInToday:date] ? 0.0 : 1.0;
}

#pragma mark datePicker
- (void)pickTime:(UIDatePicker*)sender
{
    [self.calendar selectDate:sender.date];
    [self changeTime:sender.date];
}

- (void)changeTime:(NSDate *)date
{
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
    _labTime.text = [self.dateFormatter2 stringFromDate:date];
    _time = [date timeIntervalSince1970];
}

#pragma mark Getter / Setter

- (FSCalendar *)calendar
{
    if (!_calendar) {
        _calendar = [[FSCalendar alloc] init];
        _calendar.delegate = self;
        _calendar.dataSource = self;
        _calendar.backgroundColor = WhiteColor;
    }
    return _calendar;
}

- (UIView *)timeView
{
    if (!_timeView) {
        _timeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375, 40)];
        _timeView.backgroundColor = WhiteColor;

        UILabel *lab = [[UILabel alloc] init];
        lab.text = @"见面时间";
        lab.textColor = MainColor;
        lab.font = NormalTextFont;
        [_timeView addSubview:lab];

        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_timeView);
            make.leading.equalTo(_timeView).offset(10);
        }];

        lab = [[UILabel alloc] init];
        lab.text = @"2016/9/23";
        lab.textColor = SecondColor;
        lab.font = NormalTextFont;
        lab.textAlignment = NSTextAlignmentRight;
        [_timeView addSubview:lab];
        _labTime = lab;
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_timeView);
            make.trailing.equalTo(_timeView).offset(-10);
        }];
    }
    return _timeView;
}

- (UIDatePicker *)datePicker
{
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.minuteInterval = 10;
        [_datePicker addTarget:self action:@selector(pickTime:) forControlEvents:UIControlEventValueChanged]; //为UIDatePicker添加一个事件当UIDatePicker的值被改变时触发

        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDateComponents *components = [cal components:( NSCalendarUnitDay | NSCalendarUnitHour ) fromDate:[NSDate date]];
        [components setDay:1];
        [components setHour:-components.hour];

        NSDate *minDate = [cal dateByAddingComponents:components toDate:[NSDate date] options:0];
        _datePicker.minimumDate = minDate;

    }
    return _datePicker;
}
@end
