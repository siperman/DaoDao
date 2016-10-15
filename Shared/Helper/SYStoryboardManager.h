//
//  SYStoryboardManager.h
//  Soouya
//
//  Created by hetao on 15/10/9.
//  Copyright © 2015年 Soouya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYStoryboardManager : NSObject

@property (nonatomic, strong) UIStoryboard *mainSB;
@property (nonatomic, strong) UIStoryboard *loginSB;
@property (nonatomic, strong) UIStoryboard *askSB;

+ (instancetype)manager;

@end
