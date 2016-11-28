//
//  DDUserPageTableViewController.m
//  DaoDao
//
//  Created by hetao on 2016/11/16.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDUserPageTableViewController.h"
#import "UIButton+WebCache.h"
#import "BackView.h"
#import "SepView.h"
#import "UINavigationBar+Awesome.h"

@interface DDUserPageTableViewController ()


@property (weak, nonatomic) IBOutlet UIButton *btnAvatar;
@property (weak, nonatomic) IBOutlet UIImageView *imgGender;
@property (weak, nonatomic) IBOutlet UIImageView *imgGps;

@property (weak, nonatomic) IBOutlet UILabel *labName; // 花名
@property (weak, nonatomic) IBOutlet UILabel *labGrade; // 届别
@property (weak, nonatomic) IBOutlet UILabel *labAddr;
@property (weak, nonatomic) IBOutlet UILabel *labJob;
@property (weak, nonatomic) IBOutlet UILabel *labIndustry;
@property (weak, nonatomic) IBOutlet UILabel *labYear;

@property (weak, nonatomic) IBOutlet BackView *tagsView;
@property (weak, nonatomic) IBOutlet BackView *rateView;
@property (nonatomic) NSInteger tagRows;
@property (nonatomic) NSInteger rateRows;

@property (nonatomic, strong) DDUser *user;
@end

@implementation DDUserPageTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = BackgroundColor;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableView.delegate = self;
    [self scrollViewDidScroll:self.tableView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tableView.delegate = nil;
    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationController.navigationBar lt_reset];
}

- (IBAction)showPic:(UIButton *)sender
{
    NSURL *URL = [[NSURL alloc] initWithString:PicUrlFactory(_user.headUrl)];

    [SYUtils glanceImages:@[URL] fromIndex:0 srcImageViews:@[self.btnAvatar.imageView]];
}

- (void)freshWithUser:(DDUser *)user
{
    if (user.headUrl.length > 0) {
        NSString *thumbnailUrl = [user.headUrl stringByAppendingString:kThumbnailResolution];
        NSURL *URL = [[NSURL alloc] initWithString:PicUrlFactory(thumbnailUrl)];
        [self.btnAvatar sy_setImageWithURL:URL forState:UIControlStateNormal placeholderImage:DefaultAvatar];
        [self.btnAvatar sy_round];
    }
    [self.imgGender setImage:user.genderImage];
    [self.labJob setText:[user.job componentsJoinedByString:@" / "]];
    [self.labIndustry setText:[user.industry componentsJoinedByString:@" / "]];
    [self.labYear setText:[NSString stringWithFormat:@"%@年", user.year]];
    [self.labName setText:user.title];
    [self.labGrade setText:[NSString stringWithFormat:@"%@ %@期", user.major, user.grade]];
    [self.labAddr setText:user.city];
    if (user.city.length == 0) {
        self.imgGps.hidden = YES;
    }
    _user = user;
    [self.tableView reloadData];
}

#define NAVBAR_CHANGE_POINT 10

#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIColor * color = [[UINavigationBar appearance] barTintColor];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_CHANGE_POINT) {
        //透明度
        CGFloat alpha = MIN(0.9, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
        [self.navigationController.navigationBar setShadowImage:alpha > 0.4 ? nil : [UIImage new]];
    } else {
        //完全透明
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
        //去掉nav底部的线
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    }
}

#pragma mark - Table view data source

- (CGFloat)getTagsHeight
{
    NSInteger rows = self.tagRows;

    if (rows == 0 && _user) {
        // 擅长领域
        UILabel *lab = [self getTitle:@"擅长领域"];
        [self.tagsView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tagsView).offset(54);
            make.leading.equalTo(self.tagsView).offset(10);
        }];

        CGFloat x = 110;
        CGFloat padX = 6;
        CGFloat tagW = 75;
        for (NSInteger idx = 0; idx < _user.expert.count; idx++) {
            NSString *title = _user.expert[idx];
            UIView *view = [self getExpertView:title];
            [self.tagsView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(lab);
                make.leading.equalTo(self.tagsView).offset(x + idx *(padX + tagW));
            }];
        }

        padX = 10;
        // 感兴趣话题
        UILabel *labTopic = [self getTitle:@"感兴趣话题"];
        [self.tagsView addSubview:labTopic];
        [labTopic mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tagsView).offset(54 + 44);
            make.leading.equalTo(self.tagsView).offset(10);
        }];

        CGFloat topicH = 28;
        CGFloat topicX = x;
        NSInteger rowCount = 1;
        CGFloat maxW = SCREEN_WIDTH - 24;
        for (NSInteger idx = 0; idx < _user.topic.count; idx++) {
            NSString *title = _user.topic[idx];
            UILabel *view = [self getTopic:title];
            CGFloat textW = [title textWidthWithFontsSize:16.0] + 18.0; // 根据文字计算lab宽度
            if (topicX + textW > maxW) {
                topicX = x;
                rowCount++;
            }
            [self.tagsView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(labTopic).offset((rowCount - 1) * 44);
                make.leading.equalTo(self.tagsView).offset(topicX);
                make.width.mas_equalTo(textW);
                make.height.mas_equalTo(topicH);
            }];
            topicX += (textW + padX);
        }

        self.tagRows = 2 + rowCount;

        // 分割线
        for (NSInteger idx = 1; idx < self.tagRows; idx++) {
            SepView *sepView = [[SepView alloc] init];
            [self.tagsView addSubview:sepView];
            [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.tagsView).offset(idx * 44 - 1);
                make.leading.equalTo(self.tagsView).offset(10);
                make.trailing.equalTo(self.tagsView).offset(-10);
                make.height.mas_equalTo(1);
            }];
        }
    }

    return 44 * rows + 10;
}

- (CGFloat)getRateHeight
{
    NSInteger rows = self.rateRows;

    if (rows == 0 && _user) {
        CGFloat x = 10;
        CGFloat padX = 10;
        CGFloat topicH = 27;
        CGFloat topicX = x;
        NSInteger rowCount = 1;
        CGFloat maxW = SCREEN_WIDTH - 24;
        for (NSInteger idx = 0; idx < _user.tags.count; idx++) {
            DDRateTag *tag = _user.tags[idx];
            UIView *view = [self getRate:tag];
            CGFloat textW = [[tag tagStr] textWidthWithFontsSize:14.0] + 37.0; // 根据文字计算lab宽度
            if (topicX + textW > maxW) {
                topicX = x;
                rowCount++;
            }
            [self.rateView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.rateView).offset((rowCount - 1) * 44 + 52);
                make.leading.equalTo(self.rateView).offset(topicX);
                make.width.mas_equalTo(textW);
                make.height.mas_equalTo(topicH);
            }];
            topicX += (textW + padX);
        }

        if (_user.tags.count == 0) {
            rows = 1;
        } else {
            rows = 1 + rowCount;
        }
        self.rateRows = rows;
        // 分割线
        for (NSInteger idx = 1; idx < rows; idx++) {
            SepView *sepView = [[SepView alloc] init];
            [self.rateView addSubview:sepView];
            [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.rateView).offset(idx * 44 - 1);
                make.leading.equalTo(self.rateView).offset(10);
                make.trailing.equalTo(self.rateView).offset(-10);
                make.height.mas_equalTo(1);
            }];
        }
    }

    return 44 * rows + 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (row == 0) {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    } else if (row == 1) {
        return [self getTagsHeight];
    } else {
        return [self getRateHeight];
    }
}

#pragma mark - Util

- (UILabel *)getTitle:(NSString *)title
{
    UILabel *lab = [[UILabel alloc] init];
    lab.text = title;
    lab.textColor = MainColor;
    lab.font = BigTextFont;
    return lab;
}

- (UIView *)getExpertView:(NSString *)title
{
    UIImageView *imgView = [[UIImageView alloc] initWithImage:Image(@"biaoqian1")];
    UILabel *lab = [[UILabel alloc] init];
    lab.textColor = WhiteColor;
    lab.text = title;
    lab.font = Font(13);
    lab.textAlignment = NSTextAlignmentCenter;
    [imgView addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(imgView).insets(UIEdgeInsetsMake(0, 10, 0, 0));
    }];

    return imgView;
}

- (UILabel *)getTopic:(NSString *)title
{
    UILabel *lab = [[UILabel alloc] init];
    lab.text = title;
    lab.textColor = MainColor;
    lab.font = Font(16);
    lab.textAlignment = NSTextAlignmentCenter;
    lab.layer.cornerRadius = kCornerRadius;
    lab.layer.borderColor = TextColor.CGColor;
    lab.layer.borderWidth = OnePixelHeight;
    return lab;
}

- (UILabel *)getRate:(DDRateTag *)tag
{
    UILabel *lab = [[UILabel alloc] init];
    lab.textColor = MainColor;
    lab.font = Font(14);
    lab.textAlignment = NSTextAlignmentCenter;
    lab.layer.cornerRadius = 27.0/2;
    lab.layer.borderColor = SecondColor.CGColor;
    lab.layer.borderWidth = OnePixelHeight;

    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:tag.tag];
    NSAttributedString *countStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@", tag.count]
                                                                   attributes:@{NSForegroundColorAttributeName : SecondColor}];
    [attrStr appendAttributedString:countStr];
    [lab setAttributedText:attrStr];
    return lab;
}

@end
