//
//  DDGuidePagesViewController.m
//  DaoDao
//
//  Created by hetao on 2016/11/29.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDGuidePagesViewController.h"

@interface DDGuidePagesViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *gui;
@property (nonatomic, strong) UIPageControl *pageControl;
@end

#define VERSION_INFO_CURRENT @"VERSION_INFO_CURRENT"
@implementation DDGuidePagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)initWithGuideImages:(NSArray *)images
{
    UIScrollView *gui = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    gui.pagingEnabled = YES;
    // 隐藏滑动条
    gui.showsHorizontalScrollIndicator = NO;
    gui.showsVerticalScrollIndicator = NO;
    // 取消反弹
    gui.bounces = NO;
    gui.delegate = self;
    for (NSInteger i = 0; i < images.count; i ++) {
        [gui addSubview:({
            self.btnEnter = [UIButton buttonWithType:UIButtonTypeCustom];
            self.btnEnter.frame = CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            UIImageView *imgView = [[UIImageView alloc] initWithImage:Image(images[i])];
            imgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            [self.btnEnter addSubview:imgView];
            self.btnEnter;
        })];

        if (i == images.count - 1) {
            [self.btnEnter addTarget:self action:@selector(clickEnter) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    gui.contentSize = CGSizeMake(SCREEN_WIDTH * images.count, 0);
    [self.view addSubview:gui];
    self.gui = gui;

    // pageControl
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 2, 30)];
    self.pageControl.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT - 82);
    [self.view addSubview:self.pageControl];
    self.pageControl.numberOfPages = images.count;

    [self.pageControl setPageIndicatorTintColor:TextColor];
    [self.pageControl setCurrentPageIndicatorTintColor:WhiteColor];
    [self.pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
}

- (void)clickEnter
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(guideDone)]) {
        [self.delegate guideDone];
    }
}

+ (BOOL)isShow
{
    // 读取版本信息
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *localVersion = [user objectForKey:VERSION_INFO_CURRENT];
    NSString *currentVersion =[[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"L ===%@", localVersion);
    NSLog(@"C ===%@", currentVersion);
    if (localVersion == nil || ![currentVersion isEqualToString:localVersion]) {
        [self saveCurrentVersion];
        return YES;
    } else {
        return NO;
    }
}
// 保存版本信息
+ (void)saveCurrentVersion
{
    NSString *version =[[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:version forKey:VERSION_INFO_CURRENT];
    [user synchronize];
}

#pragma mark - ScrollerView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = scrollView.contentOffset.x / SCREEN_WIDTH;
    if (self.pageControl.currentPage == self.pageControl.numberOfPages - 1) {
        self.pageControl.hidden = YES;
    } else {
        self.pageControl.hidden = NO;
    }
}

- (void)changePage:(UIPageControl *)sender
{
    [self.gui setContentOffset:CGPointMake(SCREEN_WIDTH * sender.currentPage, 0) animated:YES];
    if (self.pageControl.currentPage == self.pageControl.numberOfPages - 1) {
        self.pageControl.hidden = YES;
    } else {
        self.pageControl.hidden = NO;
    }
}

+ (instancetype)shareGuideVC
{
    static DDGuidePagesViewController *x = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        x = [[DDGuidePagesViewController alloc] init];
    });
    return x;
}

@end
