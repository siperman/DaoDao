//
//  DDAskChatManager.h
//  DaoDao
//
//  Created by hetao on 2016/10/10.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^DDAskChatCallback)(DDAsk *);

@interface DDAskChatManager : NSObject

+ (instancetype)sharedInstance;

// 根据聊天室id取本地缓存约局信息
- (DDAsk *)getCachedProfileIfExists:(NSString *)conversationId;

// 根据聊天室id取服务端约局信息并更新本地缓存
- (void)getProfilesInBackgroundForConversationId:(NSString *)conversationId callback:(DDAskChatCallback)callback;

@end
