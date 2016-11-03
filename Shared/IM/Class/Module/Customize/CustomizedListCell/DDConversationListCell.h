//
//  DDConversationListCell.h
//  DaoDao
//
//  Created by hetao on 2016/10/9.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCCKBadgeView.h"

@class AVIMConversation;
@interface DDConversationListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *askInfoLabel;
@property (nonatomic, strong) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *messageTextLabel;
@property (nonatomic, strong) LCCKBadgeView *badgeView;
@property (nonatomic, strong) IBOutlet UIView *litteBadgeView;
@property (nonatomic, strong) IBOutlet UILabel *timestampLabel;
@property (nonatomic, strong) UIButton *remindMuteImageView;

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *conversationId;

- (void)configureCell:(AVIMConversation *)conversation;

+ (DDConversationListCell *)dequeueOrCreateCellByTableView :(UITableView *)tableView;

+ (CGFloat)cellHeight;
@end
