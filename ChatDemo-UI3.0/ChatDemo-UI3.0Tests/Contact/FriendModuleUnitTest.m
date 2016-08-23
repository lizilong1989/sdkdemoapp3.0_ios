//
//  FriendModuleUnitTest.m
//  ChatDemo-UI3.0
//
//  Created by EaseMob on 16/8/6.
//  Copyright © 2016年 EaseMob. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "UITestHeader.h"

@interface FriendModuleUnitTest : XCTestCase

@end

@implementation FriendModuleUnitTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test001AddFriend {

    [[TestHelper shareHelper] startCase];
    
    [[EarlGrey selectElementWithMatcher:grey_text(NSLocalizedString(@"title.addressbook", @"AddressBook"))] performAction:grey_tap()];
    
    [[EarlGrey selectElementWithMatcher:grey_keyWindow()] performAction:grey_tapAtPoint(CGPointMake(kScreenWidth - 22, 22))];
    
    [[EarlGrey selectElementWithMatcher:grey_text(NSLocalizedString(@"friend.inputNameToSearch", @"input to find friends"))] performAction:grey_typeText([kDefault_username_other_friend enterMessage])];
    
    [[EarlGrey selectElementWithMatcher:grey_keyWindow()] performAction:grey_tapAtPoint(CGPointMake(kScreenWidth - 22, 22))];
    
    [[EarlGrey selectElementWithMatcher:grey_text(NSLocalizedString(@"add", @"Add"))] performAction:grey_tap()];
    
    [[EarlGrey selectElementWithMatcher:grey_text(NSLocalizedString(@"ok", @"OK"))] performAction:grey_tap()];
    
    [[TestHelper shareHelper] backAction];
    
    [[TestHelper shareHelper] logoutDemo];
    
    [[TestHelper shareHelper] loginDemoOtherFriend];
    
    [[EarlGrey selectElementWithMatcher:grey_text(NSLocalizedString(@"title.addressbook", @"AddressBook"))] performAction:grey_tap()];
    
    [[EarlGrey selectElementWithMatcher:grey_text(NSLocalizedString(@"title.apply", @"Application and notification"))] performAction:grey_tap()];
    
    [[EarlGrey selectElementWithMatcher:grey_text(NSLocalizedString(@"accept", @"Accept"))] performAction:grey_tap()];
    
    [[TestHelper shareHelper] backAction];
    
    GREYCondition *myCondition = [GREYCondition conditionWithName:@"addFriend condition"
                                                            block:^BOOL {
                                                                NSError *error;
                                                                [[EarlGrey selectElementWithMatcher:grey_text(kDefault_username)] assertWithMatcher:grey_sufficientlyVisible() error:&error];
                                                                return error == nil ? YES : NO;
                                                            }];
    // Wait for my condition to be satisfied or timeout after 5 seconds.
    BOOL success = [myCondition waitWithTimeout:kDefault_test_timeout];
    if (!success) {
        // Handle condition timeout.
        GREYFail(@"addFriend failed");
        [[TestHelper shareHelper] saveError:@"addFriend failed"];
    }
}

- (void)test002RemoveFriend {

    [[TestHelper shareHelper] logoutDemo];
    [[TestHelper shareHelper] loginDemo];
    
    [[EarlGrey selectElementWithMatcher:grey_text(@"确定")] performAction:grey_tap()];
    
    [[EarlGrey selectElementWithMatcher:grey_text(NSLocalizedString(@"title.addressbook", @"AddressBook"))] performAction:grey_tap()];
    
    [[EarlGrey selectElementWithMatcher:grey_text(kDefault_username_other_friend)] performAction:grey_swipeFastInDirection(kGREYDirectionLeft)];
    
    [[EarlGrey selectElementWithMatcher:grey_text(@"Delete")] performAction:grey_tap()];
    
    [[TestHelper shareHelper] logoutDemo];
    [[TestHelper shareHelper] loginDemoOtherFriend];
    [[EarlGrey selectElementWithMatcher:grey_text(NSLocalizedString(@"title.addressbook", @"AddressBook"))] performAction:grey_tap()];
    
    GREYCondition *myCondition = [GREYCondition conditionWithName:@"removeFriend condition"
                                                            block:^BOOL {
                                                                NSError *error;
                                                                [[EarlGrey selectElementWithMatcher:grey_text(kDefault_username)] assertWithMatcher:grey_notVisible() error:&error];
                                                                return error == nil ? YES : NO;
                                                            }];
    // Wait for my condition to be satisfied or timeout after 5 seconds.
    BOOL success = [myCondition waitWithTimeout:kDefault_test_timeout];
    if (!success) {
        // Handle condition timeout.
        GREYFail(@"removeFriend failed");
        [[TestHelper shareHelper] saveError:@"removeFriend failed"];
    }
    
    [[TestHelper shareHelper] logoutDemo];
}

- (void)test003AddFriendToBlackList {
    
    [[TestHelper shareHelper] loginDemo];
    
    [[EarlGrey selectElementWithMatcher:grey_text(NSLocalizedString(@"title.addressbook", @"AddressBook"))] performAction:grey_tap()];
    
    [[EarlGrey selectElementWithMatcher:grey_text(kDefault_username_other_black)] performAction:grey_longPress()];
    
    [[EarlGrey selectElementWithMatcher:grey_text(NSLocalizedString(@"friend.block", @"join the blacklist"))] performAction:grey_longPress()];
    
    [[EarlGrey selectElementWithMatcher:grey_text(NSLocalizedString(@"title.setting", @"Setting"))] performAction:grey_tap()];
    
    [[EarlGrey selectElementWithMatcher:grey_text(NSLocalizedString(@"title.buddyBlock", @"Black List"))] performAction:grey_tap()];
    
    GREYCondition *myCondition = [GREYCondition conditionWithName:@"AddFriendToBlackList condition"
                                                            block:^BOOL {
                                                                NSError *error;
                                                                [[EarlGrey selectElementWithMatcher:grey_text(kDefault_username_other_black)] assertWithMatcher:grey_sufficientlyVisible() error:&error];
                                                                return error == nil ? YES : NO;
                                                            }];
    // Wait for my condition to be satisfied or timeout after 5 seconds.
    BOOL success = [myCondition waitWithTimeout:kDefault_test_timeout];
    if (!success) {
        // Handle condition timeout.
        GREYFail(@"AddFriendToBlackList failed");
        [[TestHelper shareHelper] saveError:@"AddFriendToBlackList failed"];
    }
}

- (void)test004RmoveFriendToBlackList {
    
    [[EarlGrey selectElementWithMatcher:grey_text(kDefault_username_other_black)] performAction:grey_swipeFastInDirection(kGREYDirectionLeft)];
    
    [[EarlGrey selectElementWithMatcher:grey_text(@"Delete")] performAction:grey_tap()];
    
    [[TestHelper shareHelper] backAction];
    
    [[EarlGrey selectElementWithMatcher:grey_text(NSLocalizedString(@"title.addressbook", @"AddressBook"))] performAction:grey_tap()];
    
    GREYCondition *myCondition = [GREYCondition conditionWithName:@"RmoveFriendToBlackList condition"
                                                            block:^BOOL {
                                                                NSError *error;
                                                                [[EarlGrey selectElementWithMatcher:grey_text(kDefault_username_other_black)] assertWithMatcher:grey_sufficientlyVisible() error:&error];
                                                                return error == nil ? YES : NO;
                                                            }];
    // Wait for my condition to be satisfied or timeout after 5 seconds.
    BOOL success = [myCondition waitWithTimeout:kDefault_test_timeout];
    if (!success) {
        // Handle condition timeout.
        GREYFail(@"RmoveFriendToBlackList failed");
        [[TestHelper shareHelper] saveError:@"RmoveFriendToBlackList failed"];
    }
    
    [[TestHelper shareHelper] logoutDemo];
}

@end
