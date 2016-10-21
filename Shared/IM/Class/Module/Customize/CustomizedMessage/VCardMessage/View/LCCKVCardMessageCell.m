//
//  LCCKVCardMessageCell.m
//  ChatKit-OC
//
//  v0.7.0 Created by ElonChan (微信向我报BUG:chenyilong1010) on 16/8/10.
//  Copyright © 2016年 LeanCloud. All rights reserved.
//

#import "LCCKVCardMessageCell.h"
#import "LCCKVCardMessage.h"

#if __has_include(<SDWebImage/UIImageView+WebCache.h>)
#import <SDWebImage/UIImageView+WebCache.h>
#else
#import "UIImageView+WebCache.h"
#endif

@interface LCCKVCardMessageCell ()

@property (nonatomic, strong) UIImageView *messageImageView;

@end

@implementation LCCKVCardMessageCell


#pragma mark - Override Methods

#pragma mark - Public Methods

- (void)setup {
    [self.messageContentView addSubview:self.messageImageView];

    UIEdgeInsets edgeMessageBubbleCustomize;
    if (self.messageOwner == LCCKMessageOwnerTypeSelf) {
        UIEdgeInsets rightEdgeMessageBubbleCustomize = [LCCKSettingService sharedInstance].rightHollowEdgeMessageBubbleCustomize;
        edgeMessageBubbleCustomize = rightEdgeMessageBubbleCustomize;
    } else {
        UIEdgeInsets leftEdgeMessageBubbleCustomize = [LCCKSettingService sharedInstance].leftHollowEdgeMessageBubbleCustomize;
        edgeMessageBubbleCustomize = leftEdgeMessageBubbleCustomize;
    }
    [self.messageImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.messageContentView).with.insets(edgeMessageBubbleCustomize);
        make.height.lessThanOrEqualTo(@200).priorityHigh();
    }];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapMessageImageViewGestureRecognizerHandler:)];
    [self.messageContentView addGestureRecognizer:recognizer];
    [super setup];
    [self addGeneralView];
}

- (void)singleTapMessageImageViewGestureRecognizerHandler:(UITapGestureRecognizer *)tapGestureRecognizer {
    if (tapGestureRecognizer.state == UIGestureRecognizerStateEnded) {
//        if ([self.delegate respondsToSelector:@selector(messageCellTappedMessage:)]) {
//            [self.delegate messageCellTappedMessage:self];
//        }
        [self.viewController showNotice:@"邀请函"];
    }
}

- (void)configureCellWithData:(LCCKMessage *)message {
    [super configureCellWithData:message];
    self.messageImageView.image = Image(@"bg_im_yaoqinghan");
}

#pragma mark - Getters

- (UIImageView *)messageImageView {
    if (!_messageImageView) {
        _messageImageView = [[UIImageView alloc] init];
        //FIXME:这一行可以不需要
        _messageImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _messageImageView;

}

#pragma mark -
#pragma mark - LCCKChatMessageCellSubclassing Method

+ (void)load {
    [self registerCustomMessageCell];
}

+ (AVIMMessageMediaType)classMediaType {
    return kAVIMMessageMediaTypeVCard;
}

@end
