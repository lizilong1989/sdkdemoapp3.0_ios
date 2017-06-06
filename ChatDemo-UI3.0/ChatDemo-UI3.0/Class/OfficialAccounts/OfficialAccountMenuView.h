//
//  OfficialAccountMenuView.h
//  ChatDemo-UI3.0
//
//  Created by EaseMob on 2017/5/31.
//  Copyright © 2017年 EaseMob. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OfficialAccountMenu;
@protocol OfficialAccountMenuViewDelegate <NSObject>

@optional

- (void)didSelectnWithMenu:(OfficialAccountMenu *)menu;

@end

@interface OfficialAccountMenuView : UIView

@property (nonatomic, weak) id<OfficialAccountMenuViewDelegate> delegate;

- (instancetype)initWithMenu:(OfficialAccountMenu *)menu;

@end
