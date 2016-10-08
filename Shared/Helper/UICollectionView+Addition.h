//
//  UICollectionView+Addition.h
//  Soouya
//
//  Created by hetao on 2/29/16.
//  Copyright © 2016 Soouya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (Addition)

- (void)registerNib:(Class)cellClass;

- (void)registerClass:(Class)cellClass;

- (void)registerNibs:(NSDictionary<NSString *, NSString *> *)identifiersAndClassNames;

- (__kindof UICollectionViewCell *)dequeueCell:(Class)cellClass indexPath:(NSIndexPath *)indexPath;

@end
