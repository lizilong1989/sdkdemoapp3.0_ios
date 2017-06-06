//
//  OfficialAccountMenu.h
//  ChatDemo-UI3.0
//
//  Created by EaseMob on 2017/5/31.
//  Copyright © 2017年 EaseMob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OfficialAccountMenu : NSObject

@property (nonatomic, copy) NSString *title;

/*
 *  [auto_msg | link]
 */
@property (nonatomic, copy) NSString *action;

@property (nonatomic, copy) NSString *eventid;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSMutableArray *subMenu;

- (instancetype)initWithParameter:(NSDictionary*)parameter;

@end
