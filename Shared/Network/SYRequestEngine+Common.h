//
//  SYRequest+Common.h
//  Soouya
//
//  Created by hetao on 16/7/25.
//  Copyright © 2016年 Soouya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYRequestEngine.h"

@interface SYRequestEngine (Common)

+ (void)uploadImage:(UIImage *)image
           callback:(AZNetworkResultBlock)callback;

+ (NSArray *)imagesDataFromImages:(NSArray *)images;

@end
