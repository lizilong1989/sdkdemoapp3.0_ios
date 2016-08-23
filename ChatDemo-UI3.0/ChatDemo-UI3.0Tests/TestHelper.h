//
//  TestManager.h
//  ChatDemo-UI3.0
//
//  Created by EaseMob on 16/8/4.
//  Copyright © 2016年 EaseMob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (EnterMessage)

- (NSString*)enterMessage;

@end

@interface TestHelper : NSObject

@property (nonatomic, copy) NSString *groupName;
@property (nonatomic, copy) NSString *testMessage;

+ (instancetype)shareHelper;

- (void)loginDemo;

- (void)loginDemoOther;

- (void)loginDemoOtherFriend;

- (void)logoutDemo;

- (void)startCase;

- (void)saveError:(NSString*)error;

- (void)backAction;

- (BOOL)isReceiveMessageFromChatroom;

//辅助测试

- (void)sendLocationMessage:(NSString*)username
                 completion:(void (^)(BOOL flag))aCompletion;

- (void)sendImageMessage:(NSString*)username
              completion:(void (^)(BOOL flag))aCompletion;

@end
