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

@property (nonatomic, copy) NSString *paid;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, copy) NSString *logo;

@property (nonatomic, copy) NSString *agentuser;

@property (nonatomic, copy) NSArray *menus;

- (instancetype)initWithParameters:(NSDictionary*)aParameters;

@end
