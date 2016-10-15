//
//  DDChatListViewController.m
//  DaoDao
//
//  Created by hetao on 16/9/8.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDChatListViewController.h"
#import "DDConversationListViewModel.h"

@interface DDChatListViewController ()

@property (nonatomic, strong) DDConversationListViewModel *conversationListViewModel;
@end

@implementation DDChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (DDConversationListViewModel *)conversationListViewModel {
    if (_conversationListViewModel == nil) {
        DDConversationListViewModel *conversationListViewModel = [[DDConversationListViewModel alloc] initWithConversationListViewController:self];
        _conversationListViewModel = conversationListViewModel;
    }
    return _conversationListViewModel;
}

@end
