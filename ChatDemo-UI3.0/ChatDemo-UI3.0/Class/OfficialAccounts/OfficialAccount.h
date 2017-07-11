//
//  OfficialAccount.h
//  ChatDemo-UI3.0
//
//  Created by EaseMob on 2017/5/31.
//  Copyright © 2017年 EaseMob. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OfficialAccountMenu;
@interface OfficialAccount : NSObject

/*!
 *   公众号id
 */
@property (nonatomic, copy) NSString *paid;

/*!
 *   公众号名称
 */
@property (nonatomic, copy) NSString *name;

/*!
 *   公众号描述
 */
@property (nonatomic, copy) NSString *desc;

/*!
 *   公众号logo
 */
@property (nonatomic, copy) NSString *logo;

/*!
 *   公众号对应环信用户ID
 */
@property (nonatomic, copy) NSString *agentuser;

/*!
 *   公众号菜单
 */
@property (nonatomic, copy) NSArray *menus;

/*!
 *  初始化公众号实例
 *
 *  @param aParameters  初始化参数
 *
 *  @result 公众号实例
 */
- (instancetype)initWithParameters:(NSDictionary*)aParameters;

@end
