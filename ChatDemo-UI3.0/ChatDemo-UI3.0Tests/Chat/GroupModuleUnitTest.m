//
//  GroupModuleUnitTest.m
//  ChatDemo-UI3.0
//
//  Created by EaseMob on 16/8/5.
//  Copyright © 2016年 EaseMob. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "UITestHeader.h"

@interface GroupModuleUnitTest : XCTestCase

@end

@implementation GroupModuleUnitTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test001CreateGroup {
    
    [[TestHelper shareHelper] startCase];
    
    [[EarlGrey selectElementWithMatcher:grey_text(NSLocalizedString(@"title.addressbook", @"AddressBook"))] performAction:grey_tap()];
    
    //进入群列表
    [[EarlGrey selectElementWithMatcher:grey_text(NSLocalizedString(@"title.group", @"Group"))] performAction:grey_tap()];
    
    //进入创建群组VC
    [[EarlGrey selectElementWithMatcher:grey_text(NSLocalizedString(@"group.create.group",@"Create a group"))] performAction:grey_tap()];
    
    [TestHelper shareHelper].groupName = [NSString stringWithFormat:@"a_groupTitle_%@",@((long)([[NSDate date] timeIntervalSince1970]*1000))];
    
    [[EarlGrey selectElementWithMatcher:grey_text(NSLocalizedString(@"group.create.inputName", @"please enter the group name"))] performAction:grey_typeText([[TestHelper shareHelper].groupName enterMessage])];
    
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"GreateGroupVC_textview")] performAction:grey_typeText([NSString stringWithFormat:@"groupDesc %@ \n",[NSDate date]])];
    
    [[EarlGrey selectElementWithMatcher:grey_keyWindow()] performAction:grey_tapAtPoint(CGPointMake([UIScreen mainScreen].bounds.size.width - 22, 22))];
    
    [[EarlGrey selectElementWithMatcher:grey_text(kDefault_username_other)] performAction:grey_tap()];
    
    [[EarlGrey selectElementWithMatcher:grey_keyWindow()] performAction:grey_tapAtPoint(CGPointMake([UIScreen mainScreen].bounds.size.width - 22, [UIScreen mainScreen].bounds.size.height - 22))];
    
    [[TestHelper shareHelper] backAction];
}

- (void)test002JoinGroup {
    
    [[TestHelper shareHelper] logoutDemo];
    
    [[TestHelper shareHelper] loginDemoOther];
    
    NSError *alertError = nil;
    [[EarlGrey selectElementWithMatcher:grey_text(@"ok")] assertWithMatcher:grey_sufficientlyVisible() error:&alertError];
    if (!alertError) {
        [[EarlGrey selectElementWithMatcher:grey_text(@"ok")] performAction:grey_tap()];
    }
    
    [[EarlGrey selectElementWithMatcher:grey_text(NSLocalizedString(@"title.addressbook", @"AddressBook"))] performAction:grey_tap()];
    
    //进入群列表
    [[EarlGrey selectElementWithMatcher:grey_text(NSLocalizedString(@"title.group", @"Group"))] performAction:grey_tap()];
    
    GREYCondition *myCondition = [GREYCondition conditionWithName:@"JoinGroup condition"
                                                            block:^BOOL {
                                                                NSError *error = nil;
                                                                [[EarlGrey selectElementWithMatcher:grey_text([TestHelper shareHelper].groupName)] assertWithMatcher:grey_sufficientlyVisible() error:&error];
                                                                return error == nil ? YES : NO;
                                                            }];
    
    BOOL success = [myCondition waitWithTimeout:kDefault_test_timeout];
    if (!success) {
        // Handle condition timeout.
        GREYFail(@"DimissOrQuiteGroup failed");
        [[TestHelper shareHelper] saveError:@"DimissOrQuiteGroup failed"];
    }
}

- (void)test003GetGroupDetail {
    //进入群列表
    [[EarlGrey selectElementWithMatcher:grey_text(NSLocalizedString(@"title.group", @"Group"))] performAction:grey_tap()];
    
    //进入会话
    [[EarlGrey selectElementWithMatcher:grey_text([TestHelper shareHelper].groupName)] performAction:grey_tap()];
    
    //获取详情
    [[EarlGrey selectElementWithMatcher:grey_keyWindow()] performAction:grey_tapAtPoint(CGPointMake(kScreenWidth - 30, 30))];
    
    [[TestHelper shareHelper] backAction];
    
    [[TestHelper shareHelper] backAction];
}

- (void)test004ReceiveGroupMessage {
    
    //进入群列表
    [[EarlGrey selectElementWithMatcher:grey_text(NSLocalizedString(@"title.group", @"Group"))] performAction:grey_tap()];
    
    //进入会话
    [[EarlGrey selectElementWithMatcher:grey_text([TestHelper shareHelper].groupName)] performAction:grey_tap()];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    for (int index = 0; index < kDefault_loop_time; index++) {
        [TestHelper shareHelper].testMessage = [NSString stringWithFormat:@"test-%d %@",index,[NSDate date]];
        [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"ChatVC_inputtextview")] performAction:grey_typeText([[TestHelper shareHelper].testMessage enterMessage])];
    }
    
    [[EarlGrey selectElementWithMatcher:grey_keyWindow()] performAction:grey_tap()];
    
    [[TestHelper shareHelper] backAction];
    
    [[TestHelper shareHelper] backAction];
    
    [[TestHelper shareHelper] logoutDemo];
    
    //default 收消息
    [[TestHelper shareHelper] loginDemo];
    
    [[EarlGrey selectElementWithMatcher:grey_text(NSLocalizedString(@"title.addressbook", @"AddressBook"))] performAction:grey_tap()];
    
    [[EarlGrey selectElementWithMatcher:grey_text(NSLocalizedString(@"title.group", @"Group"))] performAction:grey_tap()];
    
    //进入会话
    [[EarlGrey selectElementWithMatcher:grey_text([TestHelper shareHelper].groupName)] performAction:grey_tap()];
    
    GREYCondition *myCondition = [GREYCondition conditionWithName:@"ReceiveGroupMessage condition"
                                                            block:^BOOL {
                                                                NSError *error = nil;
                                                                [[EarlGrey selectElementWithMatcher:grey_text([TestHelper shareHelper].testMessage)] assertWithMatcher:grey_sufficientlyVisible() error:&error];
                                                                if (error) {
                                                                    return NO;
                                                                } else {
                                                                    return YES;
                                                                }
                                                            }];
    
    BOOL success = [myCondition waitWithTimeout:kDefault_test_timeout];
    if (!success) {
        // Handle condition timeout.
        GREYFail(@"ReceiveGroupMessage failed");
        [[TestHelper shareHelper] saveError:@"ReceiveGroupMessage failed"];
    }
    
    [[TestHelper shareHelper] backAction];
    
    [[TestHelper shareHelper] backAction];
    
    [[TestHelper shareHelper] logoutDemo];
}

- (void)test005QuiteGroup
{
    [[TestHelper shareHelper] loginDemoOther];
    
    [[EarlGrey selectElementWithMatcher:grey_text(NSLocalizedString(@"title.addressbook", @"AddressBook"))] performAction:grey_tap()];
    
    //进入群列表
    [[EarlGrey selectElementWithMatcher:grey_text(NSLocalizedString(@"title.group", @"Group"))] performAction:grey_tap()];
    
    [[EarlGrey selectElementWithMatcher:grey_text([TestHelper shareHelper].groupName)] performAction:grey_tap()];
    
    [[EarlGrey selectElementWithMatcher:grey_keyWindow()] performAction:grey_tapAtPoint(CGPointMake(kScreenWidth - 30, 30))];
    
    [[EarlGrey selectElementWithMatcher:grey_text(NSLocalizedString(@"group.leave", @"quit the group"))] performAction:grey_tap()];
    
    GREYCondition *myCondition = [GREYCondition conditionWithName:@"QuiteGroup condition"
                                                            block:^BOOL {
                                                                NSError *error = nil;
                                                                [[EarlGrey selectElementWithMatcher:grey_text([TestHelper shareHelper].testMessage)] assertWithMatcher:grey_notVisible() error:&error];
                                                                if (error) {
                                                                    return NO;
                                                                } else {
                                                                    return YES;
                                                                }
                                                            }];
    
    BOOL success = [myCondition waitWithTimeout:kDefault_test_timeout];
    if (!success) {
        // Handle condition timeout.
        GREYFail(@"QuiteGroup failed");
        [[TestHelper shareHelper] saveError:@"QuiteGroup failed"];
    }
    
    [[TestHelper shareHelper] backAction];
    
    [[TestHelper shareHelper] logoutDemo];
}

- (void)test006AddUserToMember {
    [[TestHelper shareHelper] startCase];
    
    [[EarlGrey selectElementWithMatcher:grey_text(NSLocalizedString(@"title.addressbook", @"AddressBook"))] performAction:grey_tap()];
    
    //进入群列表
    [[EarlGrey selectElementWithMatcher:grey_text(NSLocalizedString(@"title.group", @"Group"))] performAction:grey_tap()];
    
    [[EarlGrey selectElementWithMatcher:grey_text([TestHelper shareHelper].groupName)] performAction:grey_tap()];
    
    [[EarlGrey selectElementWithMatcher:grey_keyWindow()] performAction:grey_tapAtPoint(CGPointMake(kScreenWidth - 30, 30))];
    
    
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"ChatGroupDetailVC_addButton")] performAction:grey_tap()];
    
    [[EarlGrey selectElementWithMatcher:grey_text(kDefault_username_other)] performAction:grey_tap()];
    
    [[EarlGrey selectElementWithMatcher:grey_keyWindow()] performAction:grey_tapAtPoint(CGPointMake([UIScreen mainScreen].bounds.size.width - 22, [UIScreen mainScreen].bounds.size.height - 22))];
    
    [[TestHelper shareHelper] backAction];
    
    [[TestHelper shareHelper] backAction];
    
    [[TestHelper shareHelper] backAction];
    
    [self test002JoinGroup];
    
    [[TestHelper shareHelper] backAction];
    
    [[TestHelper shareHelper] logoutDemo];
}

- (void)test007DimissOrQuiteGroup {
    
    [[TestHelper shareHelper] startCase];
    
    [[EarlGrey selectElementWithMatcher:grey_text([TestHelper shareHelper].groupName)] performAction:grey_tap()];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    for (int index = 0; index < kDefault_loop_time; index++) {
        [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"ChatVC_inputtextview")] performAction:grey_typeText([NSString stringWithFormat:@"test-%d %@ \n",index,[NSDate date]])];
    }
    
    [[EarlGrey selectElementWithMatcher:grey_keyWindow()] performAction:grey_tap()];
    
    //进入群详情
    [[EarlGrey selectElementWithMatcher:grey_keyWindow()] performAction:grey_tapAtPoint(CGPointMake([UIScreen mainScreen].bounds.size.width - 22, 22))];
    
    [[EarlGrey selectElementWithMatcher:grey_text(NSLocalizedString(@"group.destroy", @"dissolution of the group"))] performAction:grey_tap()];
    
    [[TestHelper shareHelper] backAction];
    
    [[TestHelper shareHelper] logoutDemo];
    
    [[TestHelper shareHelper] loginDemoOther];
    
    NSError *alertError = nil;
    [[EarlGrey selectElementWithMatcher:grey_text(@"OK")] assertWithMatcher:grey_sufficientlyVisible() error:&alertError];
    if (!alertError) {
        [[EarlGrey selectElementWithMatcher:grey_text(@"OK")] performAction:grey_tap()];
    }
    
    [[EarlGrey selectElementWithMatcher:grey_text(NSLocalizedString(@"title.addressbook", @"AddressBook"))] performAction:grey_tap()];
    
    [[EarlGrey selectElementWithMatcher:grey_text(NSLocalizedString(@"title.group", @"Group"))] performAction:grey_tap()];
    
    GREYCondition *myCondition = [GREYCondition conditionWithName:@"DimissOrQuiteGroup condition"
                                                            block:^BOOL {
                                                                NSError *error = nil;
                                                                [[EarlGrey selectElementWithMatcher:grey_text([TestHelper shareHelper].groupName)] assertWithMatcher:grey_notVisible() error:&error];
                                                                if (error) {
                                                                    return NO;
                                                                } else {
                                                                    return YES;
                                                                }
                                                            }];
    
    BOOL success = [myCondition waitWithTimeout:kDefault_test_timeout];
    if (!success) {
        // Handle condition timeout.
        GREYFail(@"DimissOrQuiteGroup failed");
        [[TestHelper shareHelper] saveError:@"DimissOrQuiteGroup failed"];
    }
    
    [[TestHelper shareHelper] backAction];

    [[TestHelper shareHelper] logoutDemo];
}

@end
