//
//  UIButton+WebCache.h
//  Soouya
//
//  Created by hetao on 15/11/30.
//  Copyright © 2015年 Soouya. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SYWebImageCompletionBlock)(UIImage *image, NSError *error, NSURL *imageURL);

@interface UIButton (Additon)

- (void)sy_setImageWithURL:(NSURL *)url forState:(UIControlState)state;

- (void)sy_setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder;

- (void)sy_setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder completed:(SYWebImageCompletionBlock)completedBlock;

@end
