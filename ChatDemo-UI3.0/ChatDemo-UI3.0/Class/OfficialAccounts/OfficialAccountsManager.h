//
//  OfficialAccountsManager.h
//  ChatDemo-UI3.0
//
//  Created by EaseMob on 2017/6/2.
//  Copyright © 2017年 EaseMob. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OfficialAccount;
@interface OfficialAccountsManager : NSObject

+ (instancetype)sharedInstance;

- (void)fetchOfficialAccountsWithPage:(NSInteger)aPage
                             pagesize:(NSInteger)aPageSize
                           completion:(void (^)(NSArray *aOfficialAccounts, NSError *aError))aCompletion;

- (void)fetchMyOfficialAccountsWithPage:(NSInteger)aPage
                               pagesize:(NSInteger)aPageSize
                             completion:(void (^)(NSArray *aOfficialAccounts, NSError *aError))aCompletion;

- (void)followOfficialAccountsWithPaid:(NSString *)aPaid
                            completion:(void (^)(NSError *aError))aCompletion;

- (void)unFollowOfficialAccountsWithPaid:(NSString *)aPaid
                              completion:(void (^)(NSError *aError))aCompletion;

- (void)getOfficialAccountsWithPaid:(NSString *)aPaid
                      isIncludeMenu:(BOOL)aIsIncludeMenu
                         completion:(void (^)(OfficialAccount *aOfficialAccount, NSError *aError))aCompletion;

- (void)autoReplyWithPaid:(NSString *)aPaid
                  eventId:(NSString *)aEventId
               completion:(void (^)(NSError *aError))aCompletion;

- (void)increaseReadCountWithPaid:(NSString *)aPaid
                       resourceId:(NSString *)aResourceId
                       completion:(void (^)(NSError *aError))aCompletion;

@end
