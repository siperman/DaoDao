//
//  UITableView+Addition.h
//  Soouya
//
//  Created by hetao on 12/29/15.
//  Copyright © 2015 Soouya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Addition)

- (void)registerNib:(Class)cellClass;

- (void)registerClass:(Class)cellClass;

- (void)registerNibs:(NSDictionary<NSString *, NSString *> *)identifiersAndClassNames;

- (__kindof UITableViewCell *)dequeueCell:(Class)cellClass indexPath:(NSIndexPath *)indexPath;

@end
