//
//  AZBannerScollView.h
//  Soouya
//
//  Created by hetao on 1/20/15.
//  Copyright (c) 2015 Soouya. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AZBannerScollViewDelegate <NSObject>

- (void)bannerScrollViewSelectIndex:(NSInteger)idx;

@optional
- (void)bannerScrollViewDidScrollToIndex:(NSInteger)idx;

@end

typedef NS_ENUM(NSUInteger, UIPageControlShowStyle)
{
    UIPageControlShowStyleNone,     //default
    UIPageControlShowStyleLeft,
    UIPageControlShowStyleCenter,
    UIPageControlShowStyleRight,
};

typedef NS_ENUM(NSUInteger, AdTitleShowStyle)
{
    AdTitleShowStyleNone,
    AdTitleShowStyleLeft,
    AdTitleShowStyleCenter,
    AdTitleShowStyleRight,
};

@interface AZBannerScollView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, weak) id<AZBannerScollViewDelegate> bannerDelegate;
@property (nonatomic) BOOL isAD;
@property (retain, nonatomic, readonly) UIPageControl * pageControl;
@property (retain, nonatomic, readwrite) NSArray * imageURLs;
@property (retain, nonatomic, readonly) NSArray * adTitleArray;
@property (assign, nonatomic, readwrite) UIPageControlShowStyle  PageControlShowStyle;
@property (assign, nonatomic, readonly) AdTitleShowStyle  adTitleStyle;
@property (nonatomic) BOOL displayActivityIndicator;
@property (nonatomic, readonly) NSMutableArray *images;
@property (retain,nonatomic,readonly) UIImageView * centerImageView;

@property (nonatomic) UIViewContentMode imageContentMode;

- (void)scrollToIndex:(NSInteger)idx;
- (void)setAdTitleArray:(NSArray *)adTitleArray withShowStyle:(AdTitleShowStyle)adTitleStyle;
- (void)pauseAutoScroll;
- (void)startAutoScroll;

@end
