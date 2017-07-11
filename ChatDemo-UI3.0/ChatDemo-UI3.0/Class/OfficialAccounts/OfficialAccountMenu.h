//
//  OfficialAccountMenu.h
//  ChatDemo-UI3.0
//
//  Created by EaseMob on 2017/5/31.
//  Copyright © 2017年 EaseMob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OfficialAccountMenu : NSObject

/*
 *  公众号菜单题目
 */
@property (nonatomic, copy) NSString *title;

/*
 *  公众号菜单动作
 *  [auto_msg | link]
 */
@property (nonatomic, copy) NSString *action;

/*
 *  公众号菜单时间ID
 */
@property (nonatomic, copy) NSString *eventid;

/*
 *  公众号菜单链接地址
 */
@property (nonatomic, copy) NSString *url;

/*
 *  公众号菜单的子菜单
 */
@property (nonatomic, copy) NSMutableArray *subMenu;


/*!
 *  初始化公众号菜单实例
 *
 *  @param aParameters  初始化参数
 *
 *  @result 公众号菜单实例
 */
- (instancetype)initWithParameter:(NSDictionary*)parameter;

@end
