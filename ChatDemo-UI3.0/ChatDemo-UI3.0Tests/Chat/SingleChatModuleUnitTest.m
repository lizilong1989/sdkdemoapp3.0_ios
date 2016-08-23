//
//  SingleChatModuleUnitTest.m
//  ChatDemo-UI3.0
//
//  Created by EaseMob on 16/8/6.
//  Copyright © 2016年 EaseMob. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "UITestHeader.h"

@interface SingleChatModuleUnitTest : XCTestCase

@end

@implementation SingleChatModuleUnitTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test001SendMessage {
    return;
    [[TestHelper shareHelper] startCase];
    
    [[EarlGrey selectElementWithMatcher:grey_text(NSLocalizedString(@"title.addressbook", @"AddressBook"))] performAction:grey_tap()];
    
    [[EarlGrey selectElementWithMatcher:grey_text(kDefault_username_other)] performAction:grey_tap()];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    for (int index = 0; index < kDefault_loop_time; index++) {
        [TestHelper shareHelper].testMessage = [NSString stringWithFormat:@"test-%d %@",index,[NSDate date]];
        [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"ChatVC_inputtextview")] performAction:grey_typeText([[TestHelper shareHelper].testMessage enterMessage])];
    }
    
    [[EarlGrey selectElementWithMatcher:grey_keyWindow()] performAction:grey_tap()];
    
    GREYCondition *myCondition = [GREYCondition conditionWithName:@"SendMessage condition"
                                                            block:^BOOL {
                                                                NSError *error;
                                                                [[EarlGrey selectElementWithMatcher:grey_kindOfClass([UIActivityIndicatorView class])] assertWithMatcher:grey_notVisible() error:&error];
                                                                return error == nil ? YES : NO;
                                                            }];
    // Wait for my condition to be satisfied or timeout after 5 seconds.
    BOOL success = [myCondition waitWithTimeout:kDefault_test_timeout];
    if (!success) {
        // Handle condition timeout.
        XCTAssert(@"SendMessage failed");
        [[TestHelper shareHelper] saveError:@"SendMessage failed"];
    }
    
    [[TestHelper shareHelper] backAction];
    
    [[TestHelper shareHelper] logoutDemo];
}

- (void)test002ReceiveMessage {
    return;
    [[TestHelper shareHelper] loginDemoOther];
    
    [[EarlGrey selectElementWithMatcher:grey_text(kDefault_username)] performAction:grey_tap()];
    
    GREYCondition *myCondition = [GREYCondition conditionWithName:@"ReceiveMessage condition"
                                                            block:^BOOL {
                                                                NSError *error;
                                                                [[EarlGrey selectElementWithMatcher:grey_text([TestHelper shareHelper].testMessage)] assertWithMatcher:grey_sufficientlyVisible() error:&error];
                                                                return error == nil ? YES : NO;
                                                            }];
    // Wait for my condition to be satisfied or timeout after 5 seconds.
    BOOL success = [myCondition waitWithTimeout:kDefault_test_timeout];
    if (!success) {
        // Handle condition timeout.
        XCTAssert(@"ReceiveMessage failed");
        [[TestHelper shareHelper] saveError:@"ReceiveMessage failed"];
    }
    
    [[TestHelper shareHelper] backAction];
    
    [[TestHelper shareHelper] logoutDemo];
}

- (void)test003SendVoiceMessage {
    
    [[TestHelper shareHelper] startCase];
    
    [[EarlGrey selectElementWithMatcher:grey_text(NSLocalizedString(@"title.addressbook", @"AddressBook"))] performAction:grey_tap()];
    
    [[EarlGrey selectElementWithMatcher:grey_text(kDefault_username_other)] performAction:grey_tap()];

    [[EarlGrey selectElementWithMatcher:grey_keyWindow()] performAction:grey_tapAtPoint(CGPointMake(30, kScreenHeight - 30))];
    
    [[EarlGrey selectElementWithMatcher:grey_keyWindow()] performAction:grey_longPressAtPointWithDuration(CGPointMake(kScreenWidth/2, kScreenHeight - 30), 5)];
    
    [[EarlGrey selectElementWithMatcher:grey_keyWindow()] performAction:grey_tap()];
    
    GREYCondition *myCondition = [GREYCondition conditionWithName:@"SendVoiceMessage condition"
                                                            block:^BOOL {
                                                                NSError *error;
                                                                [[EarlGrey selectElementWithMatcher:grey_kindOfClass([UIActivityIndicatorView class])] assertWithMatcher:grey_notVisible() error:&error];
                                                                return error == nil ? YES : NO;
                                                            }];
    // Wait for my condition to be satisfied or timeout after 5 seconds.
    BOOL success = [myCondition waitWithTimeout:kDefault_test_timeout];
    if (!success) {
        // Handle condition timeout.
        XCTAssert(@"SendVoiceMessage failed");
        [[TestHelper shareHelper] saveError:@"SendVoiceMessage failed"];
    }
    
    [[TestHelper shareHelper] backAction];
}

- (void)test004SendLocationMessage {
    
    GREYCondition *myCondition = [GREYCondition conditionWithName:@"SendLocationMessage condition"
                                                            block:^BOOL {
                                                                __block BOOL result;
                                                                [[TestHelper shareHelper] sendLocationMessage:kDefault_username_other completion:^(BOOL flag) {
                                                                    result = flag;
                                                                }];
                                                                return result;
                                                            }];
    // Wait for my condition to be satisfied or timeout after 5 seconds.
    BOOL success = [myCondition waitWithTimeout:kDefault_test_timeout];
    if (!success) {
        // Handle condition timeout.
        XCTAssert(@"SendLocationMessage failed");
        [[TestHelper shareHelper] saveError:@"SendLocationMessage failed"];
    }
}

- (void)test005SendImageMessage {
    
    GREYCondition *myCondition = [GREYCondition conditionWithName:@"SendImageMessage condition"
                                                            block:^BOOL {
                                                                __block BOOL result;
                                                                [[TestHelper shareHelper] sendImageMessage:kDefault_username_other completion:^(BOOL flag) {
                                                                    result = flag;
                                                                }];
                                                                return result;
                                                            }];
    // Wait for my condition to be satisfied or timeout after 5 seconds.
    BOOL success = [myCondition waitWithTimeout:kDefault_test_timeout];
    if (!success) {
        // Handle condition timeout.
        XCTAssert(@"SendImageMessage failed");
        [[TestHelper shareHelper] saveError:@"SendImageMessage failed"];
    }
    
    [[TestHelper shareHelper] logoutDemo];
}

@end
