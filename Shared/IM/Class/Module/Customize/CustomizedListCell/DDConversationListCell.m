//
//  DDConversationListCell.m
//  DaoDao
//
//  Created by hetao on 2016/10/9.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDConversationListCell.h"
#import "LCCKBadgeView.h"
#import <ChatKit/LCChatKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "LCCKLastMessageTypeManager.h"
#import "NSDate+LCCKDateTools.h"
#import "DDAskChatManager.h"

@interface DDConversationListCell ()

@property (nonatomic, strong) UIColor *conversationListUnreadBackgroundColor;
@property (nonatomic, strong) UIColor *conversationListUnreadTextColor;

@end

@implementation DDConversationListCell

+ (DDConversationListCell *)dequeueOrCreateCellByTableView :(UITableView *)tableView {
    DDConversationListCell *cell = [tableView dequeueReusableCellWithIdentifier:[DDConversationListCell identifier]];
    if (cell == nil) {
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [tableView registerNib:[self class]];
        cell = [tableView dequeueReusableCellWithIdentifier:[DDConversationListCell identifier]];
    }

    return cell;
}

+ (NSString *)identifier {
    return NSStringFromClass([DDConversationListCell class]);
}

+ (CGFloat)cellHeight
{
    return 115.0;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")]) {
            subView.backgroundColor = ClearColor;
            for (UIButton *btn in subView.subviews) {
                if ([btn isKindOfClass:[UIButton class]]) {
                    btn.backgroundColor = ClearColor;
                    [btn setTitle:@""];
                    [btn sy_setImage:Image(@"cell_delete")];
                }
            }
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCell:(AVIMConversation *)conversation
{
    __block NSString *askInfo = nil;
    __block NSString *displayName = nil;
    __block NSURL *avatarURL = nil;
    NSString *peerId = nil;
    if (conversation.lcck_type == LCCKConversationTypeSingle) {
        peerId = conversation.lcck_peerId;
    } else {
        peerId = conversation.lcck_lastMessage.clientId;
    }
    if (peerId) {
        [self asyncCacheElseNetLoadWithPeerId:peerId name:&displayName avatarURL:&avatarURL];
    }

    if (conversation.lcck_type == LCCKConversationTypeSingle) {
        [self.avatarImageView sd_setImageWithURL:avatarURL placeholderImage:Image(@"icon_touxiang")];
    } else {
        NSString *conversationGroupAvatarURLKey = [conversation.attributes valueForKey:LCCKConversationGroupAvatarURLKey];
        NSURL *conversationGroupAvatarURL = [NSURL URLWithString:conversationGroupAvatarURLKey];
        [self.avatarImageView sd_setImageWithURL:conversationGroupAvatarURL placeholderImage:Image(@"icon_touxiang")];
    }

    [self asyncCacheElseNetLoadWithConversationId:conversation.conversationId askInfo:&askInfo];
    self.askInfoLabel.text = askInfo;

    self.nameLabel.text = conversation.lcck_displayName;
    if (conversation.lcck_lastMessage) {
        self.messageTextLabel.attributedText = [LCCKLastMessageTypeManager attributedStringWithMessage:conversation.lcck_lastMessage conversation:conversation userName:displayName];
        self.timestampLabel.text = [[NSDate dateWithTimeIntervalSince1970:conversation.lcck_lastMessage.sendTimestamp / 1000] lcck_timeAgoSinceNow];
    }
    if (conversation.lcck_unreadCount > 0) {
        self.badgeView.badgeText = conversation.lcck_badgeText;
    }
}

// 异步取用户头像
- (void)asyncCacheElseNetLoadWithPeerId:(NSString *)peerId name:(NSString **)name avatarURL:(NSURL **)avatarURL {
    NSError *error = nil;
    self.identifier = peerId;
    [[LCCKUserSystemService sharedInstance] getCachedProfileIfExists:peerId name:name avatarURL:avatarURL error:&error];
    if (error) {
        //        NSLog(@"%@", error);
    }

    if (!*name) {
        if (peerId != NULL) {
            *name = peerId;
        }
        __weak __typeof(self) weakSelf = self;
        [[LCCKUserSystemService sharedInstance] getProfileInBackgroundForUserId:peerId callback:^(id<LCCKUserDelegate> user, NSError *error) {
            BOOL hasData = user.name;
            if (hasData && [weakSelf.identifier isEqualToString:user.clientId]) {
                [weakSelf.avatarImageView sd_setImageWithURL:user.avatarURL placeholderImage:Image(@"icon_touxiang")];
            }
        }];
    }
}

// 异步取约局信息
- (void)asyncCacheElseNetLoadWithConversationId:(NSString *)conversationId askInfo:(NSString **)askInfo
{
    self.conversationId = conversationId;
    DDAsk *ask = [[DDAskChatManager sharedInstance] getCachedProfileIfExists:conversationId];
    if (ask) {
        *askInfo = [[NSString alloc] initWithFormat:@"%@  |  %@", ask.type, ask.demand];
    } else {
        __weak __typeof(self) weakSelf = self;
        [[DDAskChatManager sharedInstance] getProfilesInBackgroundForConversationId:conversationId callback:^(DDAsk *ask) {
            if ([weakSelf.conversationId isEqualToString:conversationId])
            {
                weakSelf.askInfoLabel.text = [[NSString alloc] initWithFormat:@"%@  |  %@", ask.type, ask.demand];
            }
        }];
    }
}

- (LCCKBadgeView *)badgeView {
    if (_badgeView == nil) {
        LCCKBadgeView *badgeView = [[LCCKBadgeView alloc] initWithParentView:self.litteBadgeView
                                                                   alignment:LCCKBadgeViewAlignmentTopRight];
        badgeView.badgeBackgroundColor = self.conversationListUnreadBackgroundColor;
        badgeView.badgeTextColor = self.conversationListUnreadTextColor;
        _badgeView = badgeView;
    }
    return _badgeView;
}

- (UIColor *)conversationListUnreadBackgroundColor {
    if (_conversationListUnreadBackgroundColor) {
        return _conversationListUnreadBackgroundColor;
    }
    _conversationListUnreadBackgroundColor = [[LCCKSettingService sharedInstance] defaultThemeColorForKey:@"ConversationList-UnreadBackground"];
    return _conversationListUnreadBackgroundColor;
}

- (UIColor *)conversationListUnreadTextColor {
    if (_conversationListUnreadTextColor) {
        return _conversationListUnreadTextColor;
    }
    _conversationListUnreadTextColor = [[LCCKSettingService sharedInstance] defaultThemeColorForKey:@"ConversationList-UnreadText"];
    return _conversationListUnreadTextColor;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.badgeView.badgeText = nil;
    self.badgeView = nil;
    self.messageTextLabel.text = nil;
    self.timestampLabel.text = nil;
    self.nameLabel.text = nil;
    self.askInfoLabel.text = nil;
}

@end
