//
//  UIButton+WebCache.m
//  Soouya
//
//  Created by hetao on 15/11/30.
//  Copyright © 2015年 Soouya. All rights reserved.
//

#import "UIButton+WebCache.h"
#import <SDWebImage/UIButton+WebCache.h>

@implementation UIButton (Additon)

- (void)sy_setImageWithURL:(NSURL *)URL forState:(UIControlState)state {
    [self sy_setImageWithURL:URL forState:state placeholderImage:nil completed:nil];
}

- (void)sy_setImageWithURL:(NSURL *)URL forState:(UIControlState)state placeholderImage:(UIImage *)placeholder {
    [self sy_setImageWithURL:URL forState:state placeholderImage:placeholder completed:nil];
}

- (void)sy_setImageWithURL:(NSURL *)URL forState:(UIControlState)state placeholderImage:(UIImage *)placeholder completed:(SYWebImageCompletionBlock)completedBlock {
    [self sd_setImageWithURL:URL forState:state placeholderImage:placeholder options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, imageURL);
        }
    }];
}

@end
