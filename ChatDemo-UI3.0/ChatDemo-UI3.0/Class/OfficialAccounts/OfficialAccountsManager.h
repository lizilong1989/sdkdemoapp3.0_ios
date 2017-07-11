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

/*!
 *  获取实例
 */
+ (instancetype)sharedInstance;

/*!
 *  清除本地数据
 */
- (void)clearMyOfficialAccounts;

/*!
 *  获取所有关注的公众号
 */
- (void)fetchAllMyOfficialAccountsFromServer;

/*!
 *  获取公众号列表
 *
 *  @param aPage        页数
 *  @param aPageSize    期待返回数量
 *  @param aCompletion  完成的回调
 */
- (void)fetchOfficialAccountsWithPage:(NSInteger)aPage
                             pagesize:(NSInteger)aPageSize
                           completion:(void (^)(NSArray *aOfficialAccounts, NSError *aError))aCompletion;

/*!
 *  获取自己关注的公众号列表
 *
 *  @param aPage        页数
 *  @param aPageSize    期待返回数量
 *  @param aCompletion  完成的回调
 */
- (void)fetchMyOfficialAccountsWithPage:(NSInteger)aPage
                               pagesize:(NSInteger)aPageSize
                             completion:(void (^)(NSArray *aOfficialAccounts, NSError *aError))aCompletion;

/*!
 *  关注公众号
 *
 *  @param aPaid        公众号ID
 *  @param aCompletion  完成的回调
 */
- (void)followOfficialAccountsWithPaid:(NSString *)aPaid
                            completion:(void (^)(NSError *aError))aCompletion;

/*!
 *  取消关注公众号
 *
 *  @param aPaid        公众号ID
 *  @param aCompletion  完成的回调
 */
- (void)unFollowOfficialAccountsWithPaid:(NSString *)aPaid
                              completion:(void (^)(NSError *aError))aCompletion;

/*!
 *   获取公众号详情
 *
 *  @param aPaid            公众号ID
 *  @param aIsIncludeMenu   是否包含菜单信息
 *  @param aCompletion      完成的回调
 */
- (void)getOfficialAccountsWithPaid:(NSString *)aPaid
                      isIncludeMenu:(BOOL)aIsIncludeMenu
                         completion:(void (^)(OfficialAccount *aOfficialAccount, NSError *aError))aCompletion;

/*!
 *   自动回复
 *
 *  @param aPaid            公众号ID
 *  @param aEventId         事件ID
 *  @param aCompletion      完成的回调
 */
- (void)autoReplyWithPaid:(NSString *)aPaid
                  eventId:(NSString *)aEventId
               completion:(void (^)(NSError *aError))aCompletion;

/*!
 *   增加页面访问量
 *
 *  @param aPaid            公众号ID
 *  @param aResourceId      资源ID
 *  @param aCompletion      完成的回调
 */
- (void)increaseReadCountWithPaid:(NSString *)aPaid
                       resourceId:(NSString *)aResourceId
                       completion:(void (^)(NSError *aError))aCompletion;

/*!
 *   判断是否是公众号
 *
 *  @param aAgentUser       公众号对应的环信用户ID
 *
 *  @return 是否是公众号
 */
- (BOOL)isOfficialAccountsWithAgentUser:(NSString *)aAgentUser;

/*!
 *   判断是否是已经关注公众号
 *
 *  @param aPaid       公众号ID
 *
 *  @return 是否是公众号
 */
- (BOOL)isOfficialAccountsWithPaid:(NSString *)aPaid;

/*!
 *   根据环信用户ID获取本地公众号
 *
 *  @param aAgentUser       公众号对应的环信用户ID
 *
 *  @return 公众号
 */
- (OfficialAccount *)getOfficialAccountWithAgentUser:(NSString *)aAgentUser;

@end
