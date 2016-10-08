//
//  UITableView+Addition.m
//  Soouya
//
//  Created by hetao on 12/29/15.
//  Copyright © 2015 Soouya. All rights reserved.
//

#import "UITableView+Addition.h"
#import "UITableViewCell+Addition.h"

@implementation UITableView (Addition)

- (void)registerNib:(Class)cellClass
{
    [self registerNib:Nib(([cellClass defaultNibName])) forCellReuseIdentifier:[cellClass defaultReuseIdentifier]];
}

- (void)registerClass:(Class)cellClass
{
    [self registerClass:cellClass forCellReuseIdentifier:[cellClass defaultReuseIdentifier]];
}

- (void)registerNibs:(NSDictionary<NSString *, NSString *> *)identifiersAndClassNames
{
    [identifiersAndClassNames enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull identifier, NSString * _Nonnull className, BOOL * _Nonnull stop) {
        [self registerNib:Nib(className) forCellReuseIdentifier:identifier];
    }];
}

- (__kindof UITableViewCell *)dequeueCell:(Class)cellClass indexPath:(NSIndexPath *)indexPath
{
    return [self dequeueReusableCellWithIdentifier:[cellClass defaultReuseIdentifier] forIndexPath:indexPath];
}

@end
