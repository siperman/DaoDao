//
//  AVIMConversation+Coder.m
//  DaoDao
//
//  Created by hetao on 2016/11/18.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "AVIMConversation+Coder.h"

@interface AVIMConversation ()
@property (nonatomic, strong, nullable) NSArray      *members;
@property (nonatomic, copy, nullable) NSString       *conversationId;

@end

@implementation AVIMConversation (Coder)

- (void) encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject:self.members forKey:@"members"];
    [coder encodeObject:self.lcck_lastMessage forKey:@"lcck_lastMessage"];
    [coder encodeInteger:self.lcck_unreadCount forKey:@"lcck_unreadCount"];
    [coder encodeObject:self.conversationId forKey:@"conversationId"];
}

- (id) initWithCoder: (NSCoder *) coder
{
    self.members = [[coder decodeObjectForKey:@"members"] copy];
    self.lcck_lastMessage = [[coder decodeObjectForKey:@"lcck_lastMessage"] copy];
    self.lcck_unreadCount = [coder decodeIntegerForKey:@"lcck_unreadCount"];
    self.conversationId = [[coder decodeObjectForKey:@"conversationId"] copy];
    return self;
}

@end
