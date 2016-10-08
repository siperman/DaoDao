//
//  UICollectionView+Addition.m
//  Soouya
//
//  Created by hetao on 2/29/16.
//  Copyright © 2016 Soouya. All rights reserved.
//

#import "UICollectionView+Addition.h"
#import "UICollectionViewCell+Addition.h"

@implementation UICollectionView (Addition)

- (void)registerNib:(Class)cellClass
{
    [self registerNib:Nib(([cellClass defaultNibName])) forCellWithReuseIdentifier:[cellClass defaultReuseIdentifier]];
}

- (void)registerClass:(Class)cellClass
{
    [self registerClass:cellClass forCellWithReuseIdentifier:[cellClass defaultReuseIdentifier]];
}

- (void)registerNibs:(NSDictionary<NSString *, NSString *> *)identifiersAndClassNames
{
    [identifiersAndClassNames enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull identifier, NSString * _Nonnull className, BOOL * _Nonnull stop) {
        [self registerNib:Nib(className) forCellWithReuseIdentifier:identifier];
    }];
}

- (__kindof UICollectionViewCell *)dequeueCell:(Class)cellClass indexPath:(NSIndexPath *)indexPath
{
    return [self dequeueReusableCellWithReuseIdentifier:[cellClass defaultReuseIdentifier] forIndexPath:indexPath];
}

@end
