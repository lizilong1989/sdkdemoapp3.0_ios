//
//  OfficialAccountCell.h
//  ChatDemo-UI3.0
//
//  Created by EaseMob on 2017/6/1.
//  Copyright © 2017年 EaseMob. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OfficialAccountMessageItem;
@protocol OfficialAccountCellDelegate <NSObject>

- (void)didSelectWithOfficialAccountMessageItem:(OfficialAccountMessageItem*)item;

@end

@interface OfficialAccountCell : UITableViewCell

@property (weak, nonatomic) id<OfficialAccountCellDelegate> delegate;

@property (strong, nonatomic) id<IMessageModel> model;

@property (strong, nonatomic) UIView *bubbleView;

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier;

- (void)setModel:(id<IMessageModel>)model;

+ (BOOL)isOfficialAccountMessage:(id<IMessageModel>)model;

+ (NSString *)cellIdentifierWithModel:(id<IMessageModel>)model;

+ (CGFloat)cellHeightWithModel:(id<IMessageModel>)model;

@end
