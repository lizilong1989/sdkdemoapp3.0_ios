//
//  NSDictionary+SafeValue.h
//  ChatDemo-UI3.0
//
//  Created by EaseMob on 2017/6/1.
//  Copyright © 2017年 EaseMob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (SafeValue)

- (NSString *)safeStringValueForKey:(NSString *)key;

- (NSInteger)safeIntegerValueForKey:(NSString *)key;

- (id)safeObjectForKey:(NSString *)key;

@end
