//
//  ChooseImageViewModel.h
//  DaoDao
//
//  Created by hetao on 16/9/28.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "MTLModel+Addition.h"

@interface ChooseImageViewModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic) BOOL selected;
@end
