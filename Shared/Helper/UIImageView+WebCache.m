//
//  UIImageView+Addition.m
//  Soouya
//
//  Created by hetao on 15/11/30.
//  Copyright © 2015年 Soouya. All rights reserved.
//

#import "UIImageView+WebCache.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <objc/runtime.h>
#import <Masonry/Masonry.h>

@interface UIImageView (Additon)

@property (nonatomic, strong, readonly) UIActivityIndicatorView *indicatorView;

@end

@implementation UIImageView (Addition)

- (void)sy_setImageWithUrl:(NSString *)url
{
    if (url.length > 0) {
        NSURL *URL = [[NSURL alloc] initWithString:PicUrlFactory(url)];
        [self sy_setImageWithURL:URL];
    }
}

- (void)sy_setThumbnailImageWithUrl:(NSString *)url
{
    // TODO: 缩略图
    if (url.length > 0) {
        NSString *thumbnailUrl = url;//[url stringByAppendingString:kThumbnailResolution];
        NSURL *URL = [[NSURL alloc] initWithString:PicUrlFactory(thumbnailUrl)];
        [self sy_setImageWithURL:URL];
    }
}

- (void)sy_setImageWithURL:(NSURL *)URL
{
    [self sy_setImageWithURL:URL placeholderImage:nil progress:nil completed:nil];
}

- (void)sy_setImageWithURL:(NSURL *)URL placeholderImage:(UIImage *)placeholderImage
{
    if (URL) {
        [self sy_setImageWithURL:URL placeholderImage:placeholderImage progress:nil completed:nil];
    } else {
        [self setImage:placeholderImage];
    }
}

- (void)sy_setImageWithURL:(NSURL *)URL placeholderImage:(UIImage *)placeholderImage completed:(SYWebImageCompletionBlock)completed
{
    [self sy_setImageWithURL:URL placeholderImage:placeholderImage progress:nil completed:completed];
}

- (void)sy_setImageWithURL:(NSURL *)URL placeholderImage:(UIImage *)placeholderImage progress:(SYWebImageProgressBlock)progress completed:(SYWebImageCompletionBlock)completed
{
    WeakSelf;
    [self sd_setImageWithPreviousCachedImageWithURL:URL placeholderImage:placeholderImage options:SDWebImageRetryFailed | SDWebImageAvoidAutoSetImage progress:progress completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            weakSelf.image = image;
        }
        if (completed) {
            completed(image, error, imageURL);
        }
    }];
}

- (void)sy_setImageWithURL:(NSURL *)URL displayActivityIndicator:(BOOL)displayActivityIndicator completed:(SYWebImageCompletionBlock)completed
{
    if (displayActivityIndicator && !self.image) {
        [self addSubview:self.indicatorView];
        
        [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];

        WeakSelf;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.indicatorView startAnimating];
            if (!weakSelf) return;
            [weakSelf sy_setImageWithURL:URL placeholderImage:nil progress:nil completed:^(UIImage *image, NSError *error, NSURL *imageURL) {
                if (!weakSelf) return;

                if (completed) {
                    completed(image, error, imageURL);
                }
                
                [weakSelf.indicatorView stopAnimating];
                [weakSelf.indicatorView removeFromSuperview];
            }];
        });
    } else {
        [self.indicatorView stopAnimating];
        [self.indicatorView removeFromSuperview];
        
        [self sy_setImageWithURL:URL placeholderImage:nil completed:completed];
    }
}

- (UIActivityIndicatorView *)indicatorView
{
    UIActivityIndicatorView *indicatorView = objc_getAssociatedObject(self, @selector(indicatorView));
    if (!indicatorView) {
        indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        objc_setAssociatedObject(self, @selector(indicatorView), indicatorView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return indicatorView;
}

@end
