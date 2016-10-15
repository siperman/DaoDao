//
//  DDConversationListViewModel.m
//  DaoDao
//
//  Created by hetao on 2016/10/9.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDConversationListViewModel.h"

@implementation DDConversationListViewModel

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    AVIMConversation *conversation = [self.dataArray objectAtIndex:indexPath.row];
//
//    LCCKCellForRowBlock cellForRowBlock = [[LCCKConversationListService sharedInstance] cellForRowBlock];
//    if (cellForRowBlock) {
//        UITableViewCell *customCell = cellForRowBlock(tableView, indexPath, conversation);
//        LCCKConfigureCellBlock configureCellBlock = [[LCCKConversationListService sharedInstance] configureCellBlock];
//        if (configureCellBlock) {
//            configureCellBlock(customCell, tableView, indexPath, conversation);
//        }
//        return customCell;
//    }
//    LCCKConversationListCell *cell = [LCCKConversationListCell dequeueOrCreateCellByTableView:tableView];
//    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
//    [tableView setSeparatorColor:[[LCCKSettingService sharedInstance] defaultThemeColorForKey:@"TableView-SeparatorColor"]];
//    __block NSString *displayName = nil;
//    __block NSURL *avatarURL = nil;
//    NSString *peerId = nil;
//    if (conversation.lcck_type == LCCKConversationTypeSingle) {
//        peerId = conversation.lcck_peerId;
//    } else {
//        peerId = conversation.lcck_lastMessage.clientId;
//    }
//    if (peerId) {
//        [self asyncCacheElseNetLoadCell:cell peerId:peerId name:&displayName avatarURL:&avatarURL];
//    }
//    if (conversation.lcck_type == LCCKConversationTypeSingle) {
//        [cell.avatarImageView sd_setImageWithURL:avatarURL placeholderImage:[self imageInBundleForImageName:@"Placeholder_Avatar" ]];
//    } else {
//        NSString *conversationGroupAvatarURLKey = [conversation.attributes valueForKey:LCCKConversationGroupAvatarURLKey];
//        NSURL *conversationGroupAvatarURL = [NSURL URLWithString:conversationGroupAvatarURLKey];
//        [cell.avatarImageView sd_setImageWithURL:conversationGroupAvatarURL placeholderImage:[self imageInBundleForImageName:@"Placeholder_Group" ]];
//    }
//
//    cell.nameLabel.text = conversation.lcck_displayName;
//    if (conversation.lcck_lastMessage) {
//        cell.messageTextLabel.attributedText = [LCCKLastMessageTypeManager attributedStringWithMessage:conversation.lcck_lastMessage conversation:conversation userName:displayName];
//        cell.timestampLabel.text = [[NSDate dateWithTimeIntervalSince1970:conversation.lcck_lastMessage.sendTimestamp / 1000] lcck_timeAgoSinceNow];
//    }
//    if (conversation.lcck_unreadCount > 0) {
//        if (conversation.muted) {
//            cell.litteBadgeView.hidden = NO;
//        } else {
//            cell.badgeView.badgeText = conversation.lcck_badgeText;
//        }
//    }
//    if (conversation.muted == YES) {
//        cell.remindMuteImageView.hidden = NO;
//    }
//    LCCKConfigureCellBlock configureCellBlock = [[LCCKConversationListService sharedInstance] configureCellBlock];
//    if (configureCellBlock) {
//        configureCellBlock(cell, tableView, indexPath, conversation);
//    }
//    return cell;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    AVIMConversation *conversation = [self.dataArray objectAtIndex:indexPath.row];
//    LCCKHeightForRowBlock heightForRowBlock = [[LCCKConversationListService sharedInstance] heightForRowBlock];
//    if (heightForRowBlock) {
//        return heightForRowBlock(tableView, indexPath, conversation);
//    }
//    return LCCKConversationListCellDefaultHeight;
//}

@end
