//
//  UIImageView+WebCache.h
//  Soouya
//
//  Created by hetao on 15/11/30.
//  Copyright © 2015年 Soouya. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SYWebImageProgressBlock)(NSInteger receivedSize, NSInteger expectedSize);
typedef void(^SYWebImageCompletionBlock)(UIImage *image, NSError *error, NSURL *imageURL);

@interface UIImageView (Addition)

- (void)sy_setImageWithUrl:(NSString *)url;

- (void)sy_setThumbnailImageWithUrl:(NSString *)url;

- (void)sy_setImageWithURL:(NSURL *)URL;

- (void)sy_setImageWithURL:(NSURL *)URL placeholderImage:(UIImage *)placeholderImage;

- (void)sy_setImageWithURL:(NSURL *)URL placeholderImage:(UIImage *)placeholderImage completed:(SYWebImageCompletionBlock)completed;

- (void)sy_setImageWithURL:(NSURL *)URL placeholderImage:(UIImage *)placeholderImage progress:(SYWebImageProgressBlock)progress completed:(SYWebImageCompletionBlock)completed;

- (void)sy_setImageWithURL:(NSURL *)URL displayActivityIndicator:(BOOL)displayActivityIndicator completed:(SYWebImageCompletionBlock)completed;

@end
