//
//  LoginModuleUnitTest.m
//  ChatDemo-UI3.0
//
//  Created by EaseMob on 16/8/4.
//  Copyright © 2016年 EaseMob. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "UITestHeader.h"

@interface LoginModuleUnitTest : XCTestCase

@end

@implementation LoginModuleUnitTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test001LoginNoExist {
    if ([EMClient sharedClient].isAutoLogin) {
        return;
    }
    
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usernameTextField")] performAction:grey_clearText()];
    
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usernameTextField")] performAction:grey_typeText(kDefault_username_notexist)];
    
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"passwordTextField")] performAction:grey_typeText(kDefault_password)];
    
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"loginButton")] performAction:grey_tap()];
    
    GREYCondition *myCondition = [GREYCondition conditionWithName:@"Login condition"
                                                            block:^BOOL {
                                                                NSError *error;
                                                                [[EarlGrey selectElementWithMatcher:grey_text(@"User dosn't exist")] assertWithMatcher:grey_sufficientlyVisible() error:&error];
                                                                
                                                                if (error) {
                                                                    return NO;
                                                                } else {
                                                                    [[EarlGrey selectElementWithMatcher:grey_text(@"OK")] performAction:grey_tap()];
                                                                    return YES;
                                                                }
                                                            }];
    // Wait for my condition to be satisfied or timeout after 5 seconds.
    BOOL success = [myCondition waitWithTimeout:kDefault_test_timeout];
    if (!success) {
        // Handle condition timeout.
        GREYFail(@"Login not exist failed");
        [[TestHelper shareHelper] saveError:@"Login not exist failed"];
    }
}

- (void)test002Login {
    if ([EMClient sharedClient].isAutoLogin) {
        return;
    }
    
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usernameTextField")] performAction:grey_clearText()];
    
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usernameTextField")] performAction:grey_typeText(kDefault_username)];
    
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"passwordTextField")] performAction:grey_typeText(kDefault_password)];
    
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"loginButton")] performAction:grey_tap()];
    
    GREYCondition *myCondition = [GREYCondition conditionWithName:@"Login condition"
                                                            block:^BOOL {
                                                                return [EMClient sharedClient].isLoggedIn;
                                                            }];
    // Wait for my condition to be satisfied or timeout after 5 seconds.
    BOOL success = [myCondition waitWithTimeout:kDefault_test_timeout];
    if (!success) {
        // Handle condition timeout.
        GREYFail(@"Login timeout");
        [[TestHelper shareHelper] saveError:@"Login timeout"];
    }
}

- (void)test003Logout {
    
    if (![EMClient sharedClient].isLoggedIn) {
        return;
    }
    
    [[EarlGrey selectElementWithMatcher:grey_text(NSLocalizedString(@"title.setting", @"Setting"))] performAction:grey_tap()];
    
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"SettingVC_tableview")] performAction:grey_scrollInDirection(kGREYDirectionDown, 11 * 50 + 80 + kDefaultNavbarHeight + kDefaultTabbarHeight - kScreenHeight)];
    
    NSString *username = [[EMClient sharedClient] currentUsername];
    NSString *logoutButtonTitle = [[NSString alloc] initWithFormat:NSLocalizedString(@"setting.loginUser", @"log out(%@)"), username];
    
    [[EarlGrey selectElementWithMatcher:grey_text(logoutButtonTitle)] performAction:grey_tap()];
    
    GREYCondition *myCondition = [GREYCondition conditionWithName:@"Logout condition"
                                                            block:^BOOL {
                                                                return ![EMClient sharedClient].isLoggedIn;
                                                            }];

    BOOL success = [myCondition waitWithTimeout:kDefault_test_timeout];
    if (!success) {
        // Handle condition timeout.
        GREYFail(@"Logout timeout");
        [[TestHelper shareHelper] saveError:@"Logout timeout"];
    }
}

- (void)test010RegistAlreadyRegist {
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usernameTextField")] performAction:grey_clearText()];
    
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usernameTextField")] performAction:grey_typeText(kDefault_username)];
    
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"passwordTextField")] performAction:grey_typeText(kDefault_password)];
    
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"registButton")] performAction:grey_tap()];
    
    GREYCondition *registCondition = [GREYCondition conditionWithName:@"isInteractable" block:^BOOL{
        // Fails if element is not interactable
        NSError *error;
        [[EarlGrey selectElementWithMatcher:grey_text(NSLocalizedString(@"register.repeat", @"You registered user already exists!"))] assertWithMatcher:grey_sufficientlyVisible() error:&error];
        
        if (error) {
            return NO;
        } else {
            [[EarlGrey selectElementWithMatcher:grey_text(@"OK")] performAction:grey_tap()];
            return YES;
        }}];
    
    if (![registCondition waitWithTimeout:kDefault_test_timeout]) {
        GREYFail(@"testRegistAlreadyRegist failed");
        [[TestHelper shareHelper] saveError:@"testRegistAlreadyRegist failed"];
    }
}

- (void)test011RegistValid {
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usernameTextField")] performAction:grey_clearText()];
    
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usernameTextField")] performAction:grey_typeText(kDefault_valid_username)];
    
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"passwordTextField")] performAction:grey_typeText(kDefault_valid_password)];
    
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"registButton")] performAction:grey_tap()];
    
    GREYCondition *registCondition = [GREYCondition conditionWithName:@"isInteractable" block:^BOOL{
        // Fails if element is not interactable
        NSError *error;
        [[EarlGrey selectElementWithMatcher:grey_text(NSLocalizedString(@"register.fail", @"Registration failed"))] assertWithMatcher:grey_sufficientlyVisible() error:&error];
        
        if (error) {
            return NO;
        } else {
            [[EarlGrey selectElementWithMatcher:grey_text(@"OK")] performAction:grey_tap()];
            return YES;
        }}];
    
    if (![registCondition waitWithTimeout:kDefault_test_timeout]) {
        GREYFail(@"testRegistValid failed");
        [[TestHelper shareHelper] saveError:@"testRegistValid failed"];
    }
}

- (void)test012RegistAccount {
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usernameTextField")] performAction:grey_clearText()];
    
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"usernameTextField")] performAction:grey_typeText([NSString stringWithFormat:@"em_test_%@",@((long)([[NSDate date] timeIntervalSince1970]*1000))])];
    
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"passwordTextField")] performAction:grey_typeText(kDefault_password)];
    
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"registButton")] performAction:grey_tap()];
    
    GREYCondition *registCondition = [GREYCondition conditionWithName:@"isInteractable" block:^BOOL{
        // Fails if element is not interactable
        NSError *error;
        [[EarlGrey selectElementWithMatcher:grey_text(NSLocalizedString(@"register.success", @"Registered successfully, please log in"))] assertWithMatcher:grey_sufficientlyVisible() error:&error];
        
        if (error) {
            return NO;
        } else {
            [[EarlGrey selectElementWithMatcher:grey_text(@"OK")] performAction:grey_tap()];
            return YES;
        }}];
    
    if (![registCondition waitWithTimeout:kDefault_test_timeout]) {
        GREYFail(@"testRegistAccount failed");
    }
    
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(@"loginButton")] performAction:grey_tap()];
    
    GREYCondition *myCondition = [GREYCondition conditionWithName:@"Login condition"
                                                            block:^BOOL {
                                                                return [EMClient sharedClient].isLoggedIn;
                                                            }];
    // Wait for my condition to be satisfied or timeout after 5 seconds.
    BOOL success = [myCondition waitWithTimeout:kDefault_test_timeout];
    if (!success) {
        // Handle condition timeout.
        GREYFail(@"Login timeout");
        [[TestHelper shareHelper] saveError:@"Login timeout"];
    }
    
    [[TestHelper shareHelper] logoutDemo];
}

@end
