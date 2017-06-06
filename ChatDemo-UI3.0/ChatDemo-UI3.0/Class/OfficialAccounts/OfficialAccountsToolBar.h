//
//  OfficialAccountsToolBar.h
//  ChatDemo-UI3.0
//
//  Created by EaseMob on 2017/5/25.
//  Copyright © 2017年 EaseMob. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OfficialAccountMenu;
@protocol OfficialAccountsToolBarDelegate <NSObject>

@optional

- (void)didSelectWithOfficialAccountMenu:(OfficialAccountMenu *)menu;

@end

@interface OfficialAccountsToolBar : UIView

@property (nonatomic, weak) id<OfficialAccountsToolBarDelegate> delegate;

- (void)setMenus:(NSArray*)menus;

@end
