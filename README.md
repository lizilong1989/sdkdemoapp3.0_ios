# 公众号Demo
## 产品介绍
### 介绍
环信公众号是由环信SDK和环信公众号管理后台共同组成，是专门为公众号业务提供的产品（此Demo是基于环信3.x SDK实现的）
### 特点
1. 开放API接口，快速集成与业务融合，提供完整demo示例、集成文档和完善的后台管理功能；
2. 移动端SDK采用模块化设计，提供清晰简明的接口，方便用户使用单一模块实现特定功能；
3. SDK提供完善的会话管理、连接管理、Android智能心跳以及APNs和GCM等推送功能；
4. 分别为Android和iOS平台提供功能完整的开源Demo，采用分层及模块化实现，方便用户直接参考使用；
5. 提供移动端的开源EaseUI库，封装常用的基础功能控件，帮助开发者完成快速集成；

## iOS客户端集成
### 前期准备
首先开发者需要在环信管理后台注册，[注册流程说明](http://docs.easemob.com/im/000quickstart/10register)

### iOS SDK介绍
环信即时通讯SDK和公众号管理后台共同构成公众号服务的解决方案，环信即时通讯SDK负责公众号消息的接收，公众号管理后台负责设置公众号相关信息（包括功能菜单，自动回复内容）

环信即时通讯[SDK介绍](http://docs.easemob.com/im/300iosclientintegration/20iossdkimport)

#### iOS SDK导入

#####使用CocoaPods导入SDK

1.CocoaPods安装

如果已经安装了CocoaPods，直接进入下一步即可。

```
sudo gem install cocoapods
```

2.使用CocoaPods导入环信SDK

```
pod 'Hyphenate'	// 包含实时音视频

pod 'HyphenateLite'	// 不包含实时音视频
```

#####初始化SDK

第 1 步：引入相关头文件

```
#import <Hyphenate/Hyphenate.h>	// 包含实时音视频头文件

#import <HyphenateLite/HyphenateLite.h>	// 不包含实时音视频头文件
```

第 2 步：在工程的 AppDelegate 中的以下方法中，调用 SDK 对应方法

```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //AppKey:注册的AppKey，详细见下面注释。
    //apnsCertName:推送证书名（不需要加后缀），详细见下面注释。
    EMOptions *options = [EMOptions optionsWithAppkey:@"douser#istore"];
    options.apnsCertName = @"istore_dev";
    [[EMClient sharedClient] initializeSDKWithOptions:options];

    return YES;
}

// APP进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}

// APP将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}

```

第 3 步：注册&登录

```
//注册
EMError *error = [[EMClient sharedClient] registerWithUsername:@"8001" password:@"111111"];
if (error==nil) {
    NSLog(@"注册成功");
}

//登录
EMError *error = [[EMClient sharedClient] loginWithUsername:@"8001" password:@"111111"];
if (!error) {
    NSLog(@"登录成功");
}
```

### Demo源码

具体功能介绍，[公众号Demo源码](https://github.com/easemob/sdkdemoapp3.0_ios/tree/subscription_sdk3.x.git)，Demo中实现了获取公众号列表，关注公众号，取消关注，展示公众号图文消息等功能。此Demo基于环信3.x SDK Full版本

| 文件       | 功能    |
| ------------- |:-------------:| 
|	OfficialAccountsListViewController	|	公众号列表页面	|
|	OfficialAccountsChatViewController	|	公众号聊天页面	|
|	OfficialAccountsDetailViewController	|	公众号详情页面	|
|	OfficialAccountsManager	|	公众号相关接口	|

### 基础功能

1.获取公众号列表
	
```	
//OfficialAccountsManager.h

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
                           

```

2.获取关注公众号列表
	
```	
//OfficialAccountsManager.h

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
```

3.关注公众号

```
//OfficialAccountsManager.h

/*!
 *  关注公众号
 *
 *  @param aPaid        公众号ID
 *  @param aCompletion  完成的回调
 */
- (void)followOfficialAccountsWithPaid:(NSString *)aPaid
                            completion:(void (^)(NSError *aError))aCompletion;
```

4.取消关注公众号

```
//OfficialAccountsManager.h

/*!
 *  取消关注公众号
 *
 *  @param aPaid        公众号ID
 *  @param aCompletion  完成的回调
 */
- (void)unFollowOfficialAccountsWithPaid:(NSString *)aPaid
                              completion:(void (^)(NSError *aError))aCompletion;
```

5.获取公众号详情

```
//OfficialAccountsManager.h

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
```

6.自动回复(点击公众号菜单自动回复api)

```
//OfficialAccountsManager.h

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
```

7.增加页面访问量(用户后台统计，类似于文章的阅读数)

```
//OfficialAccountsManager.h

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
```

### 接收消息

1.设置消息监听，公众号的消息接收和正常消息一样。每一个公众号对应一个环信用户（公众号中的agentUser），用户可以通过判断消息的from判断是否是公众号消息和是由哪个公众号发来的消息。

```
 //示例代码
 [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
 
 
- (void)messagesDidReceive:(NSArray *)aMessages
{
//收到普通消息
//消息中扩展字段如果包含"em_pa_msg"认为是公众消息
//样例："ext":{"em_pa_msg": true}

}

- (void)cmdMessagesDidReceive:(NSArray *)aCmdMessages
{
//收到cmd消息
}
```
