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

@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *resourceId;
@property (nonatomic, copy) NSString *category;

@property (nonatomic, strong) OfficialAccountMessageBody *body;

- (instancetype)initWithModel:(id<IMessageModel>)model;

@end

@interface OfficialAccountMessageBody : NSObject

@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSMutableArray *items;

- (instancetype)initWithParameter:(NSDictionary*)parameter;

@end

@interface OfficialAccountMessageItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, assign) NSInteger showImgInBody;
@property (nonatomic, copy) NSString *action;
@property (nonatomic, copy) NSString *bodyText;
@property (nonatomic, copy) NSString *oriUrl;
@property (nonatomic, copy) NSString *jumpUrl;

- (instancetype)initWithParameter:(NSDictionary*)parameter;

@end

