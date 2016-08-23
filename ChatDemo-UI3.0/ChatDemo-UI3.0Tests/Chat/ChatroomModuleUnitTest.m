//
//  ChatroomModuleUnitTest.m
//  ChatDemo-UI3.0
//
//  Created by EaseMob on 16/8/4.
//  Copyright © 2016年 EaseMob. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "UITestHeader.h"
#import "TestHelper.h"

@interface ChatroomModuleUnitTest : XCTestCase <EMChatManagerDelegate>

@end

@implementation ChatroomModuleUnitTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test001EnterChatroom {
    
    [[TestHelper shareHelper] startCase];
    
    [[EarlGrey selectElementWithMatcher:grey_text(NSLocalizedString(@"title.addressbook", @"AddressBook"))] performAction:grey_tap()];
    
    //进入聊天室列表
    [[EarlGrey selectElementWithMatcher:grey_text(NSLocalizedString(@"title.chatroomlist",@"chatroom list"))] performAction:grey_tap()];
    
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"ChatroomListVC_cell_0")] performAction:grey_tap()];
    
    GREYCondition *myCondition = [GREYCondition conditionWithName:@"joinChatroom condition"
                                                            block:^BOOL {
                                                                return [[TestHelper shareHelper] isReceiveMessageFromChatroom];
                                                            }];
    // Wait for my condition to be satisfied or timeout after 5 seconds.
    BOOL success = [myCondition waitWithTimeout:kDefault_test_timeout];
    if (!success) {
        // Handle condition timeout.
        GREYFail(@"joinChatroom timeout");
        [[TestHelper shareHelper] saveError:@"joinChatroom failed"];
    }
}

- (void)test002SendMessage
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    for (int index = 0; index < kDefault_loop_time; index++) {
        [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"ChatVC_inputtextview")] performAction:grey_typeText([NSString stringWithFormat:@"test-%d %@ \n",index,[NSDate date]])];
    }
    
    [[EarlGrey selectElementWithMatcher:grey_keyWindow()] performAction:grey_tap()];
}

- (void)test003SendVoiceMessage
{
    [[EarlGrey selectElementWithMatcher:grey_keyWindow()] performAction:grey_tapAtPoint(CGPointMake(kScreenWidth/2, kScreenHeight/2))];
    
    [[EarlGrey selectElementWithMatcher:grey_keyWindow()] performAction:grey_tapAtPoint(CGPointMake(30, kScreenHeight - 30))];
    
    [[EarlGrey selectElementWithMatcher:grey_keyWindow()] performAction:grey_longPressAtPointWithDuration(CGPointMake(kScreenWidth/2, kScreenHeight - 30), 5)];
    
    [[EarlGrey selectElementWithMatcher:grey_keyWindow()] performAction:grey_tap()];
}

- (void)test005LeaveChatroom
{
    [[TestHelper shareHelper] backAction];
    
    [[TestHelper shareHelper] backAction];
    
    GREYCondition *myCondition = [GREYCondition conditionWithName:@"LeaveChatroom condition"
                                                            block:^BOOL {
                                                                return YES;
                                                            }];
    
    BOOL success = [myCondition waitWithTimeout:kDefault_test_timeout];
    if (!success) {
        GREYFail(@"LeaveChatroom failed");
        [[TestHelper shareHelper] saveError:@"LeaveChatroom failed"];
    }
    
    if ([EMClient sharedClient].isLoggedIn) {
        [[TestHelper shareHelper] logoutDemo];
    }
}

@end
