//
//  OfficialAccountMenu.m
//  ChatDemo-UI3.0
//
//  Created by EaseMob on 2017/5/31.
//  Copyright © 2017年 EaseMob. All rights reserved.
//

#import "OfficialAccountMenu.h"

#import "NSDictionary+SafeValue.h"

@implementation OfficialAccountMenu

- (instancetype)initWithParameter:(NSDictionary*)parameter
{
    self = [super init];
    if (self) {
        _title = [parameter safeStringValueForKey:@"title"];
        _action = [parameter safeStringValueForKey:@"action"];
        _eventid = [parameter safeStringValueForKey:@"eventid"];
        _url = [parameter safeStringValueForKey:@"url"];
        [self setupSubMenu:[parameter safeObjectForKey:@"subMenu"]];
    }
    return self;
}

- (void)setupSubMenu:(NSArray*)parameters
{
    if ([parameters count] == 0) {
        return;
    }
    
    _subMenu = [NSMutableArray array];
    for (NSDictionary *parameter in parameters) {
        OfficialAccountMenu *menu = [[OfficialAccountMenu alloc] initWithParameter:parameter];
        [_subMenu addObject:menu];
    }
}

@end
