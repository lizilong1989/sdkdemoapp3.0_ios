//
//  TestManager.m
//  ChatDemo-UI3.0
//
//  Created by EaseMob on 16/8/4.
//  Copyright © 2016年 EaseMob. All rights reserved.
//

#import "TestHelper.h"

#import "UITestHeader.h"
#import "EaseSDKHelper.h"

@implementation NSString (EnterMessage)

- (NSString*)enterMessage
{
    return [NSString stringWithFormat:@"%@\n",self];
}

@end

@interface TestHelper () <EMChatManagerDelegate>
{
    BOOL _isReceiveMessageFromChatroom;
}

@end

static TestHelper *helper = nil;

@implementation TestHelper

+ (instancetype)shareHelper
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[TestHelper alloc] init];
    });
    return helper;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self registDelegate];
    }
    return self;
}

- (void)registDelegate
{
    [self removeDelegate];
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
}

- (void)removeDelegate
{
    [[EMClient sharedClient].chatManager removeDelegate:self];
}


- (void)loginDemo
{
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usernameTextField")] performAction:grey_clearText()];
    
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usernameTextField")] performAction:grey_typeText(kDefault_username)];
    
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"passwordTextField")] performAction:grey_typeText(kDefault_password)];
    
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"loginButton")] performAction:grey_tap()];

}

- (void)loginDemoOther
{
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usernameTextField")] performAction:grey_clearText()];
    
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usernameTextField")] performAction:grey_typeText(kDefault_username_other)];
    
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"passwordTextField")] performAction:grey_typeText(kDefault_password)];
    
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"loginButton")] performAction:grey_tap()];

}

- (void)loginDemoOtherFriend
{
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usernameTextField")] performAction:grey_clearText()];
    
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usernameTextField")] performAction:grey_typeText(kDefault_username_other_friend)];
    
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"passwordTextField")] performAction:grey_typeText(kDefault_password)];
    
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"loginButton")] performAction:grey_tap()];
}

- (void)logoutDemo
{
    if (![EMClient sharedClient].isLoggedIn) {
        return;
    }
    
    [[EarlGrey selectElementWithMatcher:grey_text(NSLocalizedString(@"title.setting", @"Setting"))] performAction:grey_tap()];
    
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"SettingVC_tableview")] performAction:grey_scrollInDirection(kGREYDirectionDown, 11 * 50 + 80 + kDefaultNavbarHeight + kDefaultTabbarHeight - kScreenHeight)];
    
    NSString *username = [[EMClient sharedClient] currentUsername];
    NSString *logoutButtonTitle = [[NSString alloc] initWithFormat:NSLocalizedString(@"setting.loginUser", @"log out(%@)"), username];
    
    [[EarlGrey selectElementWithMatcher:grey_text(logoutButtonTitle)] performAction:grey_tap()];
}

- (void)startCase
{
    if (![EMClient sharedClient].isAutoLogin) {
        [[TestHelper shareHelper] loginDemo];
    }
    
    if ([[EMClient sharedClient].currentUsername isEqualToString:kDefault_username_other]) {
        [[TestHelper shareHelper] logoutDemo];
        [[TestHelper shareHelper] loginDemo];
    }
}

- (void)saveError:(NSString*)error
{
    NSLog(@"-----------------error:%@",error);
}

- (void)backAction
{
    [[EarlGrey selectElementWithMatcher:grey_keyWindow()] performAction:grey_tapAtPoint(CGPointMake(22, 22))];
}

- (BOOL)isReceiveMessageFromChatroom
{
    return _isReceiveMessageFromChatroom;
}

- (void)sendLocationMessage:(NSString*)username
                 completion:(void (^)(BOOL flag))aCompletion
{
    EMMessage *message = [EaseSDKHelper sendLocationMessageWithLatitude:39 longitude:116 address:@"test" to:username messageType:EMChatTypeChat messageExt:nil];
    [[EMClient sharedClient].chatManager asyncSendMessage:message progress:nil completion:^(EMMessage *message, EMError *error) {
        if (error == nil) {
            if (aCompletion) {
                aCompletion(YES);
            }
        } else {
            if (aCompletion) {
                aCompletion(NO);
            }
        }
    }];
}

- (void)sendImageMessage:(NSString*)username
              completion:(void (^)(BOOL flag))aCompletion
{
    EMMessage *message = [EaseSDKHelper sendImageMessageWithImage:[UIImage imageNamed:@"120"] to:username messageType:EMChatTypeChat messageExt:nil];
    [[EMClient sharedClient].chatManager asyncSendMessage:message progress:nil completion:^(EMMessage *message, EMError *error) {
        if (error == nil) {
            if (aCompletion) {
                aCompletion(YES);
            }
        } else {
            if (aCompletion) {
                aCompletion(NO);
            }
        }
    }];
}

#pragma mark - EMChatManagerDelegate

- (void)didReceiveMessages:(NSArray *)aMessages
{
    for (EMMessage *message in aMessages) {
        if (message.chatType == EMChatTypeChatRoom) {
             _isReceiveMessageFromChatroom = YES;
            break;
        }
    }
}

- (void)didReceiveCmdMessages:(NSArray *)aCmdMessages
{
    for (EMMessage *message in aCmdMessages) {
        if (message.chatType == EMChatTypeChatRoom) {
            _isReceiveMessageFromChatroom = YES;
            break;
        }
    }
}

@end
