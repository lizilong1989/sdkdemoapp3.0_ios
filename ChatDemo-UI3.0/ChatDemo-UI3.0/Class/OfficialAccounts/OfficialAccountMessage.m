//
//  OfficialAccountMessage.m
//  ChatDemo-UI3.0
//
//  Created by EaseMob on 2017/6/1.
//  Copyright © 2017年 EaseMob. All rights reserved.
//

#import "OfficialAccountMessage.h"

#import "NSDictionary+SafeValue.h"

@implementation OfficialAccountMessage

- (instancetype)initWithModel:(id<IMessageModel>)model
{
    self = [super init];
    if (self) {
        NSDictionary *payload = [model.message.ext safeObjectForKey:@"payload"];
        _type = [payload safeStringValueForKey:@"type"];
        _resourceId = [payload safeStringValueForKey:@"resource_id"];
        _category = [payload safeStringValueForKey:@"category"];
        _body = [[OfficialAccountMessageBody alloc] initWithParameter:[payload safeObjectForKey:@"body"]];
    }
    return self;
}

@end

@implementation OfficialAccountMessageBody

- (instancetype)initWithParameter:(NSDictionary *)parameter
{
    self = [super init];
    if (self) {
        _type = [parameter safeStringValueForKey:@"type"];
        _items = [NSMutableArray array];
        NSArray *array = [parameter safeObjectForKey:@"items"];
        for (NSDictionary *para in array) {
            OfficialAccountMessageItem *item = [[OfficialAccountMessageItem alloc] initWithParameter:para];
            [_items addObject:item];
        }
    }
    return self;
}

@end

@implementation OfficialAccountMessageItem

- (instancetype)initWithParameter:(NSDictionary *)parameter
{
    self = [super init];
    if (self) {
        _title = [parameter safeStringValueForKey:@"title"];
        _imgUrl = [parameter safeStringValueForKey:@"imgUrl"];
        _showImgInBody = [parameter safeIntegerValueForKey:@"showImgInBody"];
        _action = [parameter safeStringValueForKey:@"action"];
        _bodyText = [parameter safeStringValueForKey:@"bodyText"];
        _oriUrl = [parameter safeStringValueForKey:@"oriUrl"];
        _jumpUrl = [parameter safeStringValueForKey:@"jumpUrl"];
        
    }
    return self;
}

@end
