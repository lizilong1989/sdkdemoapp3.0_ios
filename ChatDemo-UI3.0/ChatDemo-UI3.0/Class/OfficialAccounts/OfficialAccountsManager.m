//
//  OfficialAccountsManager.m
//  ChatDemo-UI3.0
//
//  Created by EaseMob on 2017/6/2.
//  Copyright © 2017年 EaseMob. All rights reserved.
//

#import "OfficialAccountsManager.h"

#import <AFNetworking/AFNetworking.h>

#import "OfficialAccount.h"
#import "NSDictionary+SafeValue.h"

#define kHttpRequestTimeout 60.f
#define kHttpRequestMaxOperation 5

#define kAppKeyForDomain [EMClient sharedClient].options.appkey.length > 0 ? [[EMClient sharedClient].options.appkey stringByReplacingOccurrencesOfString:@"#" withString:@"/"] : @""

//#define kAppKeyForDomain @"1102170707012145/pa1-1"

#define kDefaultDomain @"http://118.193.28.212:31060"

static OfficialAccountsManager *sharedInstance = nil;

@interface OfficialAccountsManager ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@property (nonatomic, strong) NSMutableArray *officialAccountsList;

@end

@implementation OfficialAccountsManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _sessionManager = [[AFHTTPSessionManager alloc] init];
        AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
        [securityPolicy setAllowInvalidCertificates:YES];
        [_sessionManager setSecurityPolicy:securityPolicy];
        [_sessionManager.requestSerializer setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"content-type"];
        [_sessionManager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        [_sessionManager.requestSerializer setTimeoutInterval:kHttpRequestTimeout];
        [_sessionManager.operationQueue setMaxConcurrentOperationCount:kHttpRequestMaxOperation];
        _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        _officialAccountsList = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - public

- (void)clearMyOfficialAccounts
{
    [_officialAccountsList removeAllObjects];
}

- (void)fetchAllMyOfficialAccountsFromServer
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *officialAccounts = [NSMutableArray array];
        NSInteger pageNum = 1;
        NSInteger pageSize = 0;
        while (1) {
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            [self fetchMyOfficialAccountsWithPage:pageNum pagesize:10 completion:^(NSArray *aOfficialAccounts, NSError *aError) {
                [officialAccounts addObjectsFromArray:aOfficialAccounts];
                for (OfficialAccount *account in officialAccounts) {
                    [self getOfficialAccountsWithPaid:account.paid isIncludeMenu:YES completion:NULL];
                }
                dispatch_semaphore_signal(semaphore);
            }];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            pageNum ++;
            if ([officialAccounts count] == pageSize) {
                break;
            } else {
                pageSize = [officialAccounts count];
            }
        }
    });
}

- (void)fetchOfficialAccountsWithPage:(NSInteger)aPage
                             pagesize:(NSInteger)aPageSize
                           completion:(void (^)(NSArray *aOfficialAccounts, NSError *aError))aCompletion
{
    NSString *path = [NSString stringWithFormat:@"%@/api/pa/v1/%@/pas", kDefaultDomain, kAppKeyForDomain];
    NSDictionary *parameters = @{@"pagenum":@(aPage),@"pagesize":@(aPageSize)};
    [self _doGetRequestWithPath:path
                     parameters:parameters
                     completion:^(id responseObject, NSError *error) {
                         NSMutableArray *officialAccounts = nil;
                         if (!error) {
                             if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                 NSArray *data = [responseObject objectForKey:@"data"];
                                 officialAccounts = [NSMutableArray array];
                                 for (NSDictionary *dic in data) {
                                     OfficialAccount *officialAccount = [[OfficialAccount alloc] initWithParameters:dic];
                                     [officialAccounts addObject:officialAccount];
                                 }
                             }
                         }
                         if (aCompletion) {
                             aCompletion(officialAccounts, error);
                         }
                     }];
}

- (void)fetchMyOfficialAccountsWithPage:(NSInteger)aPage
                               pagesize:(NSInteger)aPageSize
                             completion:(void (^)(NSArray *aOfficialAccounts, NSError *aError))aCompletion
{
    NSString *path = [NSString stringWithFormat:@"%@/api/pa/v1/%@/pas", kDefaultDomain, kAppKeyForDomain];
    NSDictionary *parameters = @{@"pagenum":@(aPage),@"pagesize":@(aPageSize),@"username":[EMClient sharedClient].currentUsername};
    if (aPage == 1) {
        [_officialAccountsList removeAllObjects];
    }
    __weak typeof(self) weakSelf = self;
    [self _doGetRequestWithPath:path
                     parameters:parameters
                     completion:^(id responseObject, NSError *error) {
                         NSMutableArray *officialAccounts = nil;
                         if (!error) {
                             if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                 NSArray *data = [responseObject objectForKey:@"data"];
                                 officialAccounts = [NSMutableArray array];
                                 for (NSDictionary *dic in data) {
                                     OfficialAccount *officialAccount = [[OfficialAccount alloc] initWithParameters:dic];
                                     [officialAccounts addObject:officialAccount];
                                 }
                                 [weakSelf.officialAccountsList addObjectsFromArray:officialAccounts];
                             }
                         }
                         if (aCompletion) {
                             aCompletion(officialAccounts, error);
                         }
                     }];
}

- (void)followOfficialAccountsWithPaid:(NSString *)aPaid
                            completion:(void (^)(NSError *aError))aCompletion
{
    NSString *path = [NSString stringWithFormat:@"%@/api/pa/v1/%@/pas/%@/followers", kDefaultDomain, kAppKeyForDomain, aPaid];
    NSDictionary *parameters = @{@"username":[EMClient sharedClient].currentUsername};
    [self _doPostRequestWithPath:path
                      parameters:parameters
                      completion:^(id responseObject, NSError *error) {
                          if (aCompletion) {
                              aCompletion(error);
                          }
                      }];
}

- (void)unFollowOfficialAccountsWithPaid:(NSString *)aPaid
                              completion:(void (^)(NSError *aError))aCompletion
{
    NSString *path = [NSString stringWithFormat:@"%@/api/pa/v1/%@/pas/%@/followers/%@", kDefaultDomain, kAppKeyForDomain, aPaid, [EMClient sharedClient].currentUsername];
    [self _doDeleteRequestWithPath:path
                        parameters:nil
                        completion:^(id responseObject, NSError *error) {
                            if (aCompletion) {
                                aCompletion(error);
                            }
                        }];
}

- (void)getOfficialAccountsWithPaid:(NSString *)aPaid
                      isIncludeMenu:(BOOL)aIsIncludeMenu
                         completion:(void (^)(OfficialAccount *aOfficialAccount, NSError *aError))aCompletion
{
    NSString *path = [NSString stringWithFormat:@"%@/api/pa/v1/%@/pas/%@", kDefaultDomain, kAppKeyForDomain, aPaid];
    if (aIsIncludeMenu) {
        path = [path stringByAppendingString:@"?detail=yes"];
    }
    __weak typeof(self) weakSelf = self;
    [self _doGetRequestWithPath:path
                     parameters:nil
                     completion:^(id responseObject, NSError *error) {
                         OfficialAccount *officialAccount = nil;
                         if (!error) {
                             if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                 NSDictionary *data = [responseObject safeObjectForKey:@"data"];
                                 if (data) {
                                     officialAccount = [[OfficialAccount alloc] initWithParameters:data];
                                     if (officialAccount.agentuser.length > 0) {
                                         [weakSelf _removeOfficialAccountsWithPaid:officialAccount.paid];
                                         [weakSelf.officialAccountsList addObject:officialAccount];
                                     }
                                 }
                             }
                         }
                         
                         if (aCompletion) {
                             aCompletion(officialAccount, error);
                         }
                     }];
}

- (void)autoReplyWithPaid:(NSString *)aPaid
                  eventId:(NSString *)aEventId
               completion:(void (^)(NSError *aError))aCompletion
{
    NSString *path = [NSString stringWithFormat:@"%@/api/pa/v1/%@/pas/%@/menu/automsg", kDefaultDomain, kAppKeyForDomain, aPaid];
    NSDictionary *parameters = @{@"username":[EMClient sharedClient].currentUsername,@"eventid":aEventId};
    [self _doPostRequestWithPath:path
                      parameters:parameters
                      completion:^(id responseObject, NSError *error) {
                          if (aCompletion) {
                              aCompletion(error);
                          }
                      }];
}

- (void)increaseReadCountWithPaid:(NSString *)aPaid
                       resourceId:(NSString *)aResourceId
                       completion:(void (^)(NSError *aError))aCompletion
{
    NSString *path = [NSString stringWithFormat:@"%@/api/pa/v1/pas/%@/msgread", kDefaultDomain, aPaid];
    NSDictionary *parameters = @{@"appkey":[EMClient sharedClient].options.appkey,@"username":[EMClient sharedClient].currentUsername,@"resource_id":aResourceId};
    [self _doPostRequestWithPath:path
                      parameters:parameters
                      completion:^(id responseObject, NSError *error) {
                          if (aCompletion) {
                              aCompletion(error);
                          }
                      }];

}

- (BOOL)isOfficialAccountsWithAgentUser:(NSString *)aAgentUser;
{
    BOOL ret = NO;
    if (aAgentUser.length > 0) {
        for (OfficialAccount *account in _officialAccountsList) {
            if ([account.agentuser isEqualToString:aAgentUser]) {
                ret = YES;
                break;
            }
        }
    }
    return ret;
}

- (BOOL)isOfficialAccountsWithPaid:(NSString *)aPaid
{
    BOOL ret = NO;
    for (OfficialAccount *account in _officialAccountsList) {
        if ([account.paid isEqualToString:aPaid]) {
            ret = YES;
            break;
        }
    }
    return ret;
}

- (OfficialAccount *)getOfficialAccountWithAgentUser:(NSString *)aAgentUser
{
    OfficialAccount *officialAccount = nil;
    for (OfficialAccount *account in _officialAccountsList) {
        if ([account.agentuser isEqualToString:aAgentUser]) {
            officialAccount = account;
            break;
        }
    }
    return officialAccount;
}

- (void)_removeOfficialAccountsWithPaid:(NSString *)aPaid
{
    for (OfficialAccount *account in _officialAccountsList) {
        if ([account.paid isEqualToString:aPaid]) {
            [_officialAccountsList removeObject:account];
            break;
        }
    }
}
#pragma mark - private

- (void)_doGetRequestWithPath:(NSString*)path
                   parameters:(NSDictionary*)parameters
                   completion:(void (^)(id responseObject, NSError *error))completion
{
    [self _setHeaderToken];
//    [self _clearHeaderToken];
    [_sessionManager GET:path
              parameters:parameters
                progress:^(NSProgress * _Nonnull downloadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    if (completion) {
                        completion(responseObject, nil);
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    if (completion) {
                        completion(nil, error);
                    }
                }];
}

- (void)_doPostRequestWithPath:(NSString*)path
                    parameters:(NSDictionary*)parameters
                    completion:(void (^)(id responseObject, NSError *error))completion
{
    [self _setHeaderToken];
    [_sessionManager POST:path
               parameters:parameters
                 progress:nil
                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                      if (completion) {
                          completion(responseObject, nil);
                      }
                  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                      if (completion) {
                          completion(nil, error);
                      }
                  }];
}

- (void)_doDeleteRequestWithPath:(NSString*)path
                      parameters:(NSDictionary*)parameters
                      completion:(void (^)(id responseObject, NSError *error))completion
{
    [self _setHeaderToken];
    [_sessionManager DELETE:path
                 parameters:parameters
                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        if (completion) {
                            completion(responseObject, nil);
                        }
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        if (completion) {
                            completion(nil, error);
                        }
                    }];
}

- (void)_setHeaderToken
{
//    [[_sessionManager requestSerializer] setValue:[NSString stringWithFormat:@"Bearer %@", [self _getUserToken]] forHTTPHeaderField:@"Authorization"];
}

- (void)_clearHeaderToken
{
    [[_sessionManager requestSerializer] setValue:@"" forHTTPHeaderField:@"Authorization"];
}

- (NSString*)_getUserToken
{
    NSString *userToken = nil;
    BOOL isRefresh = NO;
    EMClient *client = [EMClient sharedClient];
    SEL selector = NSSelectorFromString(@"getUserToken:");
    if ([client respondsToSelector:selector]) {
        IMP imp = [client methodForSelector:selector];
        NSString *(*func)(id, SEL, NSNumber *) = (void *)imp;
        userToken = func(client, selector, @(isRefresh));
    }
    return userToken;
}

@end
