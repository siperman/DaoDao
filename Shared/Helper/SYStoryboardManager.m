//
//  SYStoryboardManager.m
//  Soouya
//
//  Created by hetao on 15/10/9.
//  Copyright © 2015年 Soouya. All rights reserved.
//

#import "SYStoryboardManager.h"


@implementation SYStoryboardManager

+ (instancetype)manager
{
    static SYStoryboardManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        
        [instance setup];
    });
    
    return instance;
}

- (void)setup
{
    self.mainSB = Storyboard(@"Main");
    self.loginSB = Storyboard(@"Login");
    self.askSB = Storyboard(@"Ask");

}

@end
