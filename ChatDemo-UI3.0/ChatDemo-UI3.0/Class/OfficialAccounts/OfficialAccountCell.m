//
//  OfficialAccountCell.m
//  ChatDemo-UI3.0
//
//  Created by EaseMob on 2017/6/1.
//  Copyright © 2017年 EaseMob. All rights reserved.
//

#import "OfficialAccountCell.h"

#import "OfficialAccountMessage.h"

#define CellPadding 5.f

@interface OfficialAccountItemView : UIView
{
    OfficialAccountMessageItem *_item;
}

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *textLabel;

- (instancetype)initWithItem:(OfficialAccountMessageItem*)item;

@end

@implementation OfficialAccountItemView

- (instancetype)initWithItem:(OfficialAccountMessageItem *)item
{
    self = [super init];
    if (self) {
        _item = item;
        [self addSubview:self.imageView];
        [self addSubview:self.textLabel];
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:item.imgUrl]];
        self.textLabel.text = item.title;
        if (item.showImgInBody == 1) {
            self.textLabel.textColor = [UIColor whiteColor];
        } else {
            self.textLabel.textColor = [UIColor blackColor];
        }
    }
    return self;
}

- (UIImageView*)imageView
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.layer.masksToBounds = YES;
    }
    return _imageView;
}

- (UILabel*)textLabel
{
    if (_textLabel == nil) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.numberOfLines = 2;
        _textLabel.font = [UIFont systemFontOfSize:15];
    }
    return _textLabel;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (_item.showImgInBody == 1) {
        _imageView.frame = CGRectMake(CellPadding, CellPadding, CGRectGetWidth(frame) - CellPadding * 2, CGRectGetHeight(frame) - CellPadding *2);
        _textLabel.frame = CGRectMake(CellPadding, CGRectGetHeight(frame) - 30 - CellPadding, CGRectGetWidth(frame) - CellPadding * 2, 30);
        _textLabel.backgroundColor = RGBACOLOR(0, 0, 0, 0.6);
    } else {
        _imageView.frame = CGRectMake(CGRectGetWidth(frame) - 75 - CellPadding, CellPadding, 75, CGRectGetHeight(frame) - CellPadding * 2);
        _textLabel.frame = CGRectMake(CellPadding, 0, CGRectGetWidth(frame) - 75 - CellPadding, CGRectGetHeight(frame));
        _textLabel.backgroundColor = [UIColor clearColor];
    }
}

@end

@interface OfficialAccountCell ()
{
    OfficialAccountMessage *_officialAccountMessage;
}

@end

@implementation OfficialAccountCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.bubbleView];
    }
    return self;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

#pragma mark - getter

- (UIView*)bubbleView
{
    if (_bubbleView == nil) {
        _bubbleView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, CGRectGetWidth([UIScreen mainScreen].bounds) - 20, CGRectGetHeight(self.frame) - 20)];
        _bubbleView.backgroundColor = RGBACOLOR(248, 248, 248, 1);
    }
    return _bubbleView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(id<IMessageModel>)model
{
    for (UIView *view in [_bubbleView subviews]) {
        [view removeFromSuperview];
    }
    _model = model;
    _officialAccountMessage = [[OfficialAccountMessage alloc] initWithModel:model];
    CGFloat nextHeight = 0.0;
    NSInteger index = 0;
    for (OfficialAccountMessageItem *item in _officialAccountMessage.body.items) {
        if (index == 0) {
            item.showImgInBody = 1;
        }
        OfficialAccountItemView *itemView = [[OfficialAccountItemView alloc] initWithItem:item];
        itemView.tag = index;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectOfficialAccount:)];
        [itemView addGestureRecognizer:tap];
        CGFloat height = item.showImgInBody == 0 ? 60 : 120;
        itemView.frame = CGRectMake(0, nextHeight, CGRectGetWidth(_bubbleView.frame), height);
        nextHeight += height;
        index++;
        [_bubbleView addSubview:itemView];
    }
    CGRect frame = _bubbleView.frame;
    frame.size.height = nextHeight;
    _bubbleView.frame = frame;
}

#pragma mark - action

- (void)didSelectOfficialAccount:(UITapGestureRecognizer *)tapRecognizer
{
    if (tapRecognizer.state == UIGestureRecognizerStateEnded) {
        UIView *view = tapRecognizer.view;
        NSInteger index = view.tag;
        OfficialAccountMessageItem *item = nil;
        if (index < [_officialAccountMessage.body.items count]) {
            item = [_officialAccountMessage.body.items objectAtIndex:index];
        }
        if (_delegate && [_delegate respondsToSelector:@selector(didSelectWithOfficialAccountMessageItem:)]) {
            [_delegate didSelectWithOfficialAccountMessageItem:item];
        }
    }
}

#pragma mark - public

+ (BOOL)isOfficialAccountMessage:(id<IMessageModel>)model
{
    BOOL ret = NO;
    if (model && [model.message.ext objectForKey:@"em_pa_msg"]) {
        NSDictionary *payload = [model.message.ext objectForKey:@"payload"];
        if (payload) {
            NSString *type = [payload objectForKey:@"type"];
            if ([type isKindOfClass:[NSString class]] && ([type isEqualToString:@"single"] || [type isEqualToString:@"multiple"])) {
                ret = YES;
            }
        }
    }
    return ret;
}

+ (NSString *)cellIdentifierWithModel:(id<IMessageModel>)model
{
    return model.isSender ? @"__OfficialAccountCellSendIdentifier__" : @"__OfficialAccountCellReceiveIdentifier__";
}

+ (CGFloat)cellHeightWithModel:(id<IMessageModel>)model
{
    OfficialAccountMessage *officialAccountMessage = [[OfficialAccountMessage alloc] initWithModel:model];
    CGFloat nextHeight = 0.0;
    NSInteger index = 0;
    for (OfficialAccountMessageItem *item in officialAccountMessage.body.items) {
        if (index == 0) {
            item.showImgInBody = 1;
        }
        nextHeight += item.showImgInBody == 0 ? 60 : 120;
        index ++;
    }
    return nextHeight + 20;
}

@end
