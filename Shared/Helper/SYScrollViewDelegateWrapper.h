//
//  SYScrollViewDelegateWrapper.h
//  Soouya
//
//  Created by hetao on 2/25/16.
//  Copyright © 2016 Soouya. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  为解决链接中的问题
 *  http://blog.csdn.net/kaihaodir/article/details/46376173
 */

@interface SYScrollViewDelegateWrapper : NSObject <UIScrollViewDelegate>

@property (weak, nonatomic) id delegate;

+ (void)hookUIScrollViewSetDelegate;

@end
