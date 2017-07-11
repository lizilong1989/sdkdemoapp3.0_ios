//
//  OfficialAccount.m
//  ChatDemo-UI3.0
//
//  Created by EaseMob on 2017/5/31.
//  Copyright © 2017年 EaseMob. All rights reserved.
//

#import "OfficialAccount.h"

#import "NSDictionary+SafeValue.h"
#import "OfficialAccountMenu.h"

@implementation OfficialAccount

- (instancetype)initWithParameters:(NSDictionary*)aParameters
{
    self = [super init];
    if (self) {
        _paid = [aParameters safeStringValueForKey:@"paid"];
        _name = [aParameters safeStringValueForKey:@"name"];
        _desc = [aParameters safeStringValueForKey:@"description"];
        _logo = [aParameters safeStringValueForKey:@"logo"];
        _agentuser = [[aParameters safeStringValueForKey:@"agentUser"] lowercaseString];
        
        NSArray *menus = [aParameters safeObjectForKey:@"menu"];
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dic in menus) {
            OfficialAccountMenu *menu = [[OfficialAccountMenu alloc] initWithParameter:dic];
            [array addObject:menu];
        }
        _menus = [array copy];
    }
    return self;
}

@end
