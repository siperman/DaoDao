//
//  LCCKInputViewPluginVCard.m
//  ChatKit-OC
//
//  v0.7.0 Created by ElonChan (微信向我报BUG:chenyilong1010) on 16/8/12.
//  Copyright © 2016年 LeanCloud. All rights reserved.
//

#import "LCCKInputViewPluginVCard.h"
#import "LCCKVCardMessage.h"
#import "LCCKContactListViewController.h"
#import "LCCKContactManager.h"
#import "DDMeetTableViewController.h"
#import "DDAskChatManager.h"

@implementation LCCKInputViewPluginVCard
@synthesize inputViewRef = _inputViewRef;
@synthesize sendCustomMessageHandler = _sendCustomMessageHandler;

#pragma mark -
#pragma mark - Override Methods

#pragma mark -
#pragma mark - LCCKInputViewPluginSubclassing Method

//+ (void)load {
//    [self registerCustomInputViewPlugin];
//}

+ (LCCKInputViewPluginType)classPluginType {
    return LCCKInputViewPluginTypeVCard;
}

#pragma mark -
#pragma mark - LCCKInputViewPluginDelegate Method

/**
 * 插件图标
 */
- (UIImage *)pluginIconImage {
    return [self imageInBundlePathForImageName:@"chat_bar_icons_location"];
}

/**
 * 插件名称
 */
- (NSString *)pluginTitle {
    return @"邀请函";
}

/**
 * 插件对应的 view，会被加载到 inputView 上
 */
- (UIView *)pluginContentView {
    return nil;
}

/**
 * 插件被选中运行
 */
- (void)pluginDidClicked {
    [super pluginDidClicked];
    [self pushMeetViewController];
}

/**
 * 发送自定消息的实现
 */
- (LCCKIdResultBlock)sendCustomMessageHandler {
    if (_sendCustomMessageHandler) {
        return _sendCustomMessageHandler;
    }
    if (!self.conversationViewController.isAvailable) {
        [self.conversationViewController sendLocalFeedbackTextMessge:@"邀请函发送失败"];
        return nil;
    }
    LCCKIdResultBlock sendCustomMessageHandler = ^(id object, NSError *error) {
        LCCKVCardMessage *vCardMessage = [LCCKVCardMessage vCardMessageWithClientId:object conversationType:[self.conversationViewController getConversationIfExists].lcck_type];
        [self.conversationViewController sendCustomMessage:vCardMessage progressBlock:^(NSInteger percentDone) {
        } success:^(BOOL succeeded, NSError *error) {
            [self.conversationViewController sendLocalFeedbackTextMessge:@"邀请函发送成功"];
        } failed:^(BOOL succeeded, NSError *error) {
            [self.conversationViewController sendLocalFeedbackTextMessge:@"邀请函发送失败"];
        }];
        //important: avoid retain cycle!
        _sendCustomMessageHandler = nil;
    };
    _sendCustomMessageHandler = sendCustomMessageHandler;
    return sendCustomMessageHandler;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    LCCKConversationViewController *vc = (LCCKConversationViewController *)self.viewController;
//    DDAsk *ask = [[DDAskChatManager sharedInstance] getCachedProfileIfExists:vc.conversationId];
//
//    if (ask.isMyAsk && ask.status.integerValue == DDAskWaitingSendMeet) {
//        self.hidden = NO;
//    } else {
//        self.hidden = YES;
//    }
}

#pragma mark - Private Methods

- (UIImage *)imageInBundlePathForImageName:(NSString *)imageName {
    UIImage *image = [UIImage lcck_imageNamed:imageName bundleName:@"ChatKeyboard" bundleForClass:[self class]];
    return image;
}

- (void)pushMeetViewController {
    DDMeetTableViewController *vc = [DDMeetTableViewController viewController];
    DDAsk *ask = [[DDAskChatManager sharedInstance] getCachedProfileIfExists:self.conversationViewController.conversationId];
    vc.ask = ask;
    [vc setCallback:^(){
        [self.inputViewRef open];
        !self.sendCustomMessageHandler ?: self.sendCustomMessageHandler(nil, nil);
    }];

    [self.conversationViewController.navigationController pushViewController:vc animated:YES];
}

@end
