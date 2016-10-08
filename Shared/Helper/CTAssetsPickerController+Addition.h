//
//  CTAssetsPickerController+Addition.h
//  Soouya
//
//  Created by hetao on 15/6/21.
//  Copyright (c) 2015年 Soouya. All rights reserved.
//

#import "CTAssetsPickerController.h"

@interface CTAssetsPickerController (Addition)

- (BOOL)showMaximumNotice;

- (BOOL)showMaximumNotice:(BOOL)canSelect;

- (BOOL)showMaximumNotice:(BOOL)canSelect count:(NSInteger)maxCount;

@end
