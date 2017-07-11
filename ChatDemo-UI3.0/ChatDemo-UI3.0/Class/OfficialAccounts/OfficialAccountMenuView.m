//
//  OfficialAccountMenuView.m
//  ChatDemo-UI3.0
//
//  Created by EaseMob on 2017/5/31.
//  Copyright © 2017年 EaseMob. All rights reserved.
//

#import "OfficialAccountMenuView.h"

#import "OfficialAccountMenu.h"

@interface OfficialAccountMenuView ()
{
    OfficialAccountMenu *_menu;
    CGFloat _left;
    CGFloat _width;
}

@property (nonatomic, strong) UIView *contentView;

@end

@implementation OfficialAccountMenuView

- (instancetype)initWithMenu:(OfficialAccountMenu *)menu left:(CGFloat)left width:(CGFloat)width
{
    self = [super init];
    if (self) {
        _menu = menu;
        _left = left;
        
        CGFloat maxWidh = 0;
        for (OfficialAccountMenu *officialAccountMenu in menu.subMenu) {
            NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:officialAccountMenu.title];
            [text addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, text.length)];
            CGRect rect = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 45) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil];
            if (maxWidh < CGRectGetWidth(rect)) {
                maxWidh = CGRectGetWidth(rect);
            }
        }
        
        _width = MAX(maxWidh + 10, width);
        self.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds));
        self.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenAction)];
        [self addGestureRecognizer:tap];
        [self addSubview:self.contentView];
        [self setupView:menu];
    }
    return self;
}

- (void)setupView:(OfficialAccountMenu *)menu
{
    CGFloat height = 45 * [menu.subMenu count];
    _contentView.frame = CGRectMake(_left, CGRectGetHeight([UIScreen mainScreen].bounds) - height, _width, height);
    int index = 0;
    
    for (OfficialAccountMenu *officialAccountMenu in menu.subMenu) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(0, index * 45, _width, 45);
        button.tag = index;
        button.layer.borderWidth = 1.f;
        button.layer.borderColor = RGBACOLOR(0xf3, 0xf3, 0xf3, 1).CGColor;
        [button setTitle:officialAccountMenu.title forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(menuButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        index ++;
        [_contentView addSubview:button];
    }
}

#pragma mark - getter

- (UIView*)contentView
{
    if (_contentView == nil) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = RGBACOLOR(0xf8, 0xf8, 0xf8, 1);
    }
    return _contentView;
}

#pragma mark - action

- (void)hiddenAction
{
    [self removeFromSuperview];
}

- (void)menuButtonAction:(id)sender
{
    UIButton *button = (UIButton*)sender;
    NSInteger index = button.tag;
    OfficialAccountMenu *menu = nil;
    if (index < [_menu.subMenu count]) {
        menu = [_menu.subMenu objectAtIndex:index];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectnWithMenu:)]) {
        [_delegate didSelectnWithMenu:menu];
    }
    [self removeFromSuperview];
}

@end
