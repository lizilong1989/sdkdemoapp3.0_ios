//
//  OfficialAccountMessage.h
//  ChatDemo-UI3.0
//
//  Created by EaseMob on 2017/6/1.
//  Copyright © 2017年 EaseMob. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OfficialAccountMessageBody;
@interface OfficialAccountMessage : NSObject

/*!
 *   公众号消息类型
 */
@property (nonatomic, copy) NSString *type;

/*!
 *   公众号消息资源ID
 */
@property (nonatomic, copy) NSString *resourceId;

/*!
 *   公众号消息类别
 */
@property (nonatomic, copy) NSString *category;

/*!
 *   公众号消息Body
 */
@property (nonatomic, strong) OfficialAccountMessageBody *body;

/*!
 *  初始化公众号消息实例
 *
 *  @param aParameters  初始化参数
 *
 *  @result 公众号消息实例
 */
- (instancetype)initWithModel:(id<IMessageModel>)model;

@end

@interface OfficialAccountMessageBody : NSObject

/*!
 *   公众号消息Body类型
 */
@property (nonatomic, copy) NSString *type;

/*!
 *   公众号消息Body数据
 */
@property (nonatomic, copy) NSMutableArray *items;

/*!
 *  初始化公众号消息Body实例
 *
 *  @param aParameters  初始化参数
 *
 *  @result 公众号消息Body实例
 */
- (instancetype)initWithParameter:(NSDictionary*)parameter;

@end

@interface OfficialAccountMessageItem : NSObject

/*!
 *   公众号消息元素题目
 */
@property (nonatomic, copy) NSString *title;

/*!
 *   公众号消息元素图面地址
 */
@property (nonatomic, copy) NSString *imgUrl;

/*!
 *   公众号消息元素是否显示大图
 */
@property (nonatomic, assign) NSInteger showImgInBody;

/*!
 *   公众号消息元素动作类型
 */
@property (nonatomic, copy) NSString *action;

/*!
 *   公众号消息元素html
 */
@property (nonatomic, copy) NSString *brief;

/*!
 *   公众号消息元素原始地址
 */
@property (nonatomic, copy) NSString *oriUrl;

/*!
 *   公众号消息元素跳转地址
 */
@property (nonatomic, copy) NSString *jumpUrl;

/*!
 *  初始化公众号消息元素实例
 *
 *  @param aParameters  初始化参数
 *
 *  @result 公众号消息元素实例
 */
- (instancetype)initWithParameter:(NSDictionary*)parameter;

@end

