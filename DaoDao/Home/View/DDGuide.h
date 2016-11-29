//
//  DDGuide.h
//  DaoDao
//
//  Created by hetao on 2016/11/29.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DDGuideType) {
    DDGuideHome = 0,
    DDGuideSettingTimeOne,
    DDGuideSettingTimeTwo,
    DDGuideMine,
    DDGuideIM
};

@interface DDGuide : UIControl

+ (void)showWithGuideType:(DDGuideType)type;

@end
