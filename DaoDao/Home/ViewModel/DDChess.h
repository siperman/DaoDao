//
//  DDChess.h
//  DaoDao
//
//  Created by hetao on 16/9/29.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface DDChess : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *cid;
@property (nonatomic) BOOL isWhite;
@property (nonatomic) BOOL isBig;
@property (nonatomic) BOOL isLighting;


@end
