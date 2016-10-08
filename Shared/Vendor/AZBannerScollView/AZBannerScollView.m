//
//  AZBannerScollView.m
//  Soouya
//
//  Created by hetao on 1/20/15.
//  Copyright (c) 2015 Soouya. All rights reserved.
//

#import "AZBannerScollView.h"
#import "UIImageView+WebCache.h"
#import "NSTimer+Addition.h"
#import "UIView+SYAddition.h"

#define UISCREENWIDTH  self.bounds.size.width
#define UISCREENHEIGHT  self.bounds.size.height

#define HIGHT self.bounds.origin.y

NSTimeInterval const AutoScrollTimerInterval = 3.0;

@interface AZBannerScollView ()
{
    
    UILabel * _adLabel;
    
    UIImageView * _leftImageView;
    UIImageView * _centerImageView;
    UIImageView * _rightImageView;
    
    UILabel * _leftAdLabel;
    UILabel * _centerAdLabel;
    UILabel * _rightAdLabel;
}

@property (nonatomic) NSInteger currentIdx;
@property (nonatomic, strong) NSTimer *autoScrollTimer;
@property (retain,nonatomic,readonly) UIImageView * leftImageView;
@property (retain,nonatomic,readonly) UIImageView * rightImageView;

@property (nonatomic, strong) NSMutableArray *images;

@end

@implementation AZBannerScollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.bounces = NO;
        
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.pagingEnabled = YES;
        self.contentOffset = CGPointMake(UISCREENWIDTH, 0);
        self.contentSize = CGSizeMake(UISCREENWIDTH * 3, UISCREENHEIGHT);
        self.delegate = self;
        
        _leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, UISCREENWIDTH, UISCREENHEIGHT)];
        _leftImageView.userInteractionEnabled = YES;
        _leftImageView.contentMode = UIViewContentModeScaleAspectFill;
        _leftImageView.clipsToBounds = YES;
        [self addSubview:_leftImageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [_leftImageView addGestureRecognizer:tap];
        
        _centerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(UISCREENWIDTH, 0, UISCREENWIDTH, UISCREENHEIGHT)];
        _centerImageView.userInteractionEnabled = YES;
        _centerImageView.contentMode = UIViewContentModeScaleAspectFill;
        _centerImageView.clipsToBounds = YES;
        [self addSubview:_centerImageView];
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [_centerImageView addGestureRecognizer:tap];
        
        _rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(UISCREENWIDTH * 2, 0, UISCREENWIDTH, UISCREENHEIGHT)];
        _rightImageView.userInteractionEnabled = YES;
        _rightImageView.contentMode = UIViewContentModeScaleAspectFill;
        _rightImageView.clipsToBounds = YES;
        [self addSubview:_rightImageView];
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [_rightImageView addGestureRecognizer:tap];
        
        self.autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:AutoScrollTimerInterval target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
        [self.autoScrollTimer pauseTimer];
    }
    return self;
}

- (void)tap:(UIGestureRecognizer *)gesture
{
    if ([self.bannerDelegate respondsToSelector:@selector(bannerScrollViewSelectIndex:)]) {
        [self.bannerDelegate bannerScrollViewSelectIndex:self.currentIdx];
    }
}

- (void)setImageURLs:(NSArray *)imageURLs
{
    _imageURLs = [NSArray arrayWithArray:imageURLs];
    
    self.PageControlShowStyle = self.PageControlShowStyle;
    self.currentIdx = 0;
    self.pageControl.currentPage = 0;
    
    self.contentOffset = CGPointMake(UISCREENWIDTH, 0);

    if (imageURLs.count > 1 && self.isAD) {
        [self.autoScrollTimer resumeTimerAfterTimeInterval:AutoScrollTimerInterval];
    }

    _images = [NSMutableArray arrayWithArray:imageURLs];

    [self setupContents];

}

- (void)setAdTitleArray:(NSArray *)adTitleArray withShowStyle:(AdTitleShowStyle)adTitleStyle
{
    _adTitleArray = adTitleArray;
    
    if (adTitleStyle == AdTitleShowStyleNone) {
        return;
    }
    
    _leftAdLabel = [[UILabel alloc]init];
    _centerAdLabel = [[UILabel alloc]init];
    _rightAdLabel = [[UILabel alloc]init];
    
    _leftAdLabel.frame = CGRectMake(10, UISCREENHEIGHT - 40, UISCREENWIDTH, 20);
    [_leftImageView addSubview:_leftAdLabel];
    _centerAdLabel.frame = CGRectMake(10, UISCREENHEIGHT - 40, UISCREENWIDTH, 20);
    [_centerImageView addSubview:_centerAdLabel];
    _rightAdLabel.frame = CGRectMake(10, UISCREENHEIGHT - 40, UISCREENWIDTH, 20);
    [_rightImageView addSubview:_rightAdLabel];
    
    if (adTitleStyle == AdTitleShowStyleLeft) {
        _leftAdLabel.textAlignment = NSTextAlignmentLeft;
        _centerAdLabel.textAlignment = NSTextAlignmentLeft;
        _rightAdLabel.textAlignment = NSTextAlignmentLeft;
    }
    else if (adTitleStyle == AdTitleShowStyleCenter) {
        _leftAdLabel.textAlignment = NSTextAlignmentCenter;
        _centerAdLabel.textAlignment = NSTextAlignmentCenter;
        _rightAdLabel.textAlignment = NSTextAlignmentCenter;
    } else {
        _leftAdLabel.textAlignment = NSTextAlignmentRight;
        _centerAdLabel.textAlignment = NSTextAlignmentRight;
        _rightAdLabel.textAlignment = NSTextAlignmentRight;
    }
    
    _leftAdLabel.text = _adTitleArray[0];
    _centerAdLabel.text = _adTitleArray[1];
    _rightAdLabel.text = _adTitleArray[2];
}

- (void) pauseAutoScroll{
    [self.autoScrollTimer pauseTimer];
}

- (void) startAutoScroll{
    if(self.isAD && self.images.count > 1){
        [self.autoScrollTimer resumeTimerAfterTimeInterval:AutoScrollTimerInterval];
    }
}

- (void)setPageControlShowStyle:(UIPageControlShowStyle)PageControlShowStyle
{
    if (PageControlShowStyle == UIPageControlShowStyleNone) {
        return;
    }
    
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
    }
    _pageControl.numberOfPages = _imageURLs.count;
    
    if (PageControlShowStyle == UIPageControlShowStyleLeft) {
        _pageControl.frame = CGRectMake(10, HIGHT + UISCREENHEIGHT - 20, 20 * _pageControl.numberOfPages, 20);
    } else if (PageControlShowStyle == UIPageControlShowStyleCenter) {
        _pageControl.frame = CGRectMake(0, 0, 20 * _pageControl.numberOfPages, 20);
        _pageControl.center = CGPointMake(UISCREENWIDTH / 2.0, HIGHT + UISCREENHEIGHT - 10);
    } else {
        _pageControl.frame = CGRectMake( UISCREENWIDTH - 20 * _pageControl.numberOfPages, HIGHT + UISCREENHEIGHT - 20, 20 * _pageControl.numberOfPages, 20);
    }
    _pageControl.currentPage = 0;
    
    _pageControl.enabled = NO;
    _pageControl.hidden = !(_imageURLs.count > 1);
    
    [self performSelector:@selector(addPageControl) withObject:nil afterDelay:0.1f];
}

- (void)setImageContentMode:(UIViewContentMode)imageContentMode
{
    _leftImageView.contentMode = imageContentMode;
    _centerImageView.contentMode = imageContentMode;
    _rightImageView.contentMode = imageContentMode;
}

- (void)addPageControl
{
    [[self superview] addSubview:_pageControl];
}

- (void)scrollToIndex:(NSInteger)idx
{
    if (idx == _currentIdx) {
        return;
    }
    _currentIdx = idx;
    _pageControl.currentPage = idx;
    self.contentOffset = CGPointMake(UISCREENWIDTH, 0);
    [self setupContents];
}

- (void)autoScroll
{
    if (!self.isDragging && [self isDisplayedInScreen]) {
        [self scrollRectToVisible:CGRectMake(UISCREENWIDTH * 2, 0, UISCREENWIDTH, self.height) animated:YES];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.autoScrollTimer pauseTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.isAD) {
        [self.autoScrollTimer resumeTimerAfterTimeInterval:AutoScrollTimerInterval];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self handleScrollEnded];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self handleScrollEnded];
}

- (void)handleScrollEnded
{
    if (self.contentOffset.x == 0) {
        NSUInteger leftIdx = (_currentIdx == 0 ? _imageURLs.count - 1 : (_currentIdx - 1) % _imageURLs.count);
        _currentIdx = leftIdx;
        _pageControl.currentPage = leftIdx;
    } else if(self.contentOffset.x == UISCREENWIDTH * 2) {
        _currentIdx = (_currentIdx + 1) % _imageURLs.count;
        _pageControl.currentPage = (_pageControl.currentPage + 1) % _imageURLs.count;
    } else {
        return;
    }
    
    self.contentOffset = CGPointMake(UISCREENWIDTH, 0);
    
    [self setupContents];
}

- (void)setupContents
{
    if (_imageURLs.count > 0) {
        // left
        NSUInteger leftIdx = (_currentIdx == 0 ? _imageURLs.count - 1 : (_currentIdx - 1) % _imageURLs.count);
        [self imageView:_leftImageView loadImageAtIndex:leftIdx];
        _leftAdLabel.text = _adTitleArray[leftIdx];
        
        // center
        NSUInteger curIdx = (_currentIdx) % _imageURLs.count;
        [self imageView:_centerImageView loadImageAtIndex:curIdx];
        _centerAdLabel.text = _adTitleArray[curIdx];
        
        // right
        NSUInteger rightIdx = (_currentIdx + 1) % _imageURLs.count;
        [self imageView:_rightImageView loadImageAtIndex:rightIdx];
        _rightAdLabel.text = _adTitleArray[rightIdx];
        
        if ([self.bannerDelegate respondsToSelector:@selector(bannerScrollViewDidScrollToIndex:)]) {
            [self.bannerDelegate bannerScrollViewDidScrollToIndex:self.currentIdx];
        }
    } else {
        _leftImageView.image = nil;
        _centerImageView.image = nil;
        _rightImageView.image = nil;
    }
}

- (void)imageView:(UIImageView *)imageView loadImageAtIndex:(NSUInteger)idx
{
    if ([[self.images objectAtIndex:idx] isKindOfClass:[UIImage class]]) {
        imageView.image = self.images[idx];
    } else if ([[self.imageURLs objectAtIndex:idx] isKindOfClass:[NSURL class]]) {
        imageView.image = nil;
        
        WeakSelf;
        [imageView sy_setImageWithURL:_imageURLs[idx] displayActivityIndicator:self.displayActivityIndicator completed:^(UIImage *image, NSError *error, NSURL *imageURL) {
            if (image) {
                StrongSelf;
                if (!strongSelf) {
                    return;
                }
                if (idx < strongSelf.images.count) {
                    [strongSelf.images replaceObjectAtIndex:idx withObject:image];
                }
            }
        }];
    }
}

@end
