//
//  OfficialAccountsChatViewController.m
//  ChatDemo-UI3.0
//
//  Created by EaseMob on 2017/5/25.
//  Copyright © 2017年 EaseMob. All rights reserved.
//

#import "OfficialAccountsChatViewController.h"

#import "OfficialAccountsToolBar.h"
#import "OfficialAccountMenu.h"
#import "OfficialAccountMenuView.h"
#import "EaseChatToolbar.h"
#import "OfficialAccountsDetailViewController.h"
#import "OfficialAccountWebViewController.h"
#import "OfficialAccountCell.h"
#import "OfficialAccountMessage.h"
#import "OfficialAccount.h"
#import "OfficialAccountsManager.h"

#define kDefault_Button_Width 60.f

@interface OfficialAccountsChatViewController () <OfficialAccountsToolBarDelegate,OfficialAccountMenuViewDelegate,OfficialAccountCellDelegate>
{
    OfficialAccount *_officialAccount;
}

@property (nonatomic, strong) OfficialAccountsToolBar *toolBar;
@property (nonatomic, strong) EaseChatToolbar *oldToolBar;
@property (nonatomic, strong) UIButton *newKeyboardBtn;
@property (nonatomic, strong) UIButton *oldKeyboardBtn;
@property (nonatomic, strong) OfficialAccountMenuView *menuView;

@end

@implementation OfficialAccountsChatViewController

- (instancetype)initWithOfficialAccount:(OfficialAccount *)aOfficialAccount
{
    self = [super initWithConversationChatter:aOfficialAccount.agentuser conversationType:EMConversationTypeChat];
    if (self) {
        _officialAccount = aOfficialAccount;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = _officialAccount.name.length > 0 ? _officialAccount.name : _officialAccount.agentuser;
    [self setChatToolbar:self.toolBar];
    [self.view addSubview:self.newKeyboardBtn];
    
    [self _setupBarButtonItem];
    
    [self.toolBar setMenus:_officialAccount.menus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
//    [[EMClient sharedClient].chatManager deleteConversation:self.conversation.conversationId isDeleteMessages:NO completion:NULL];
}

- (void)_setupBarButtonItem
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    backButton.accessibilityIdentifier = @"back";
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    UIButton *detailButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    detailButton.accessibilityIdentifier = @"detail";
    [detailButton setImage:[UIImage imageNamed:@"group_detail"] forState:UIControlStateNormal];
    [detailButton addTarget:self action:@selector(showGroupDetailAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:detailButton];
}

#pragma mark - getter

- (EaseChatToolbar*)oldToolBar
{
    if (_oldToolBar == nil) {
        CGFloat chatbarHeight = [EaseChatToolbar defaultHeight];
        _oldToolBar = [[EaseChatToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - chatbarHeight, self.view.frame.size.width, chatbarHeight) type:EMChatToolbarTypeGroup];
        _oldToolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        NSMutableArray *leftItems = [NSMutableArray arrayWithArray:_oldToolBar.inputViewLeftItems];
        EaseChatToolbarItem *keyBoardItem = [[EaseChatToolbarItem alloc] initWithButton:self.oldKeyboardBtn withView:nil];
        [leftItems insertObject:keyBoardItem atIndex:0];
        [_oldToolBar setInputViewLeftItems:leftItems];
    }
    return _oldToolBar;
}

- (UIButton*)oldKeyboardBtn
{
    if (_oldKeyboardBtn == nil) {
        _oldKeyboardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _oldKeyboardBtn.frame = CGRectMake(0, CGRectGetMinY(self.chatToolbar.frame), kDefault_Button_Width, [EaseChatToolbar defaultHeight]);
        _oldKeyboardBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [_oldKeyboardBtn setImage:[UIImage imageNamed:@"EaseUIResource.bundle/chatBar_keyboard"] forState:UIControlStateNormal];
//        [_oldKeyboardBtn setTitle:@"board" forState:UIControlStateNormal];
//        [_oldKeyboardBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_oldKeyboardBtn addTarget:self action:@selector(keyboardBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _oldKeyboardBtn;
}

- (UIButton*)newKeyboardBtn
{
    if (_newKeyboardBtn == nil) {
        _newKeyboardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _newKeyboardBtn.frame = CGRectMake(0, CGRectGetMinY(self.chatToolbar.frame), kDefault_Button_Width, [EaseChatToolbar defaultHeight]);
        _newKeyboardBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [_newKeyboardBtn setImage:[UIImage imageNamed:@"EaseUIResource.bundle/chatBar_keyboard"] forState:UIControlStateNormal];
//        [_newKeyboardBtn setTitle:@"board" forState:UIControlStateNormal];
//        [_newKeyboardBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_newKeyboardBtn addTarget:self action:@selector(keyboardBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _newKeyboardBtn;
}

- (OfficialAccountsToolBar*)toolBar
{
    if (_toolBar == nil) {
        _toolBar = [[OfficialAccountsToolBar alloc] initWithFrame:CGRectMake(kDefault_Button_Width, CGRectGetMinY(self.chatToolbar.frame), CGRectGetWidth(self.chatToolbar.frame) - kDefault_Button_Width, CGRectGetHeight(self.chatToolbar.frame))];
        _toolBar.delegate = self;
        _toolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    }
    return _toolBar;
}

#pragma mark - OfficialAccountsToolBarDelegate

- (void)didSelectWithOfficialAccountMenu:(OfficialAccountMenu *)menu
{
    [self _dealWithMenu:menu];
}

#pragma mark - OfficialAccountMenuViewDelegate

- (void)didSelectnWithMenu:(OfficialAccountMenu *)menu
{
    [self _dealWithMenu:menu];
}

#pragma mark - OfficialAccountCellDelegate

- (void)didSelectWithOfficialAccountMessageItem:(OfficialAccountMessageItem *)item
{
    if ([item.action isEqualToString:@"link"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:item.jumpUrl]];
    } else {
        OfficialAccountWebViewController *webView = [[OfficialAccountWebViewController alloc] initWithItem:item];
        [self.navigationController pushViewController:webView animated:YES];
    }
}

#pragma mark - EaseMessageViewControllerDelegate

- (UITableViewCell *)messageViewController:(UITableView *)tableView
                       cellForMessageModel:(id<IMessageModel>)messageModel
{
    if ([OfficialAccountCell isOfficialAccountMessage:messageModel]) {
        OfficialAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:[OfficialAccountCell cellIdentifierWithModel:messageModel]];
        if (!cell) {
            cell = [[OfficialAccountCell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:[OfficialAccountCell cellIdentifierWithModel:messageModel]];
        }
        [cell setModel:messageModel];
        cell.delegate = self;
        return cell;
    }
    return nil;
}

- (CGFloat)messageViewController:(EaseMessageViewController *)viewController
           heightForMessageModel:(id<IMessageModel>)messageModel
                   withCellWidth:(CGFloat)cellWidth
{
    if ([OfficialAccountCell isOfficialAccountMessage:messageModel]) {
        return [OfficialAccountCell cellHeightWithModel:messageModel];
    }
    return 0.f;
}

- (BOOL)messageViewController:(EaseMessageViewController *)viewController
   didLongPressRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [self.dataArray objectAtIndex:indexPath.row];
    if (![object isKindOfClass:[NSString class]]) {
        if ([OfficialAccountCell isOfficialAccountMessage:object]) {
            OfficialAccountCell *cell = (OfficialAccountCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            [cell becomeFirstResponder];
            self.menuIndexPath = indexPath;
            [self showMenuViewController:cell.bubbleView andIndexPath:indexPath messageType:EMMessageBodyTypeFile];
        } else {
            EaseMessageCell *cell = (EaseMessageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            [cell becomeFirstResponder];
            self.menuIndexPath = indexPath;
            [self showMenuViewController:cell.bubbleView andIndexPath:indexPath messageType:cell.model.bodyType];
        }
    }
    return YES;
}

#pragma mark - Action

- (void)keyboardBtnAction:(id)sender
{
    UIButton *button = (UIButton*)sender;
    if (button == self.oldKeyboardBtn) {
        [self setChatToolbar:self.toolBar];
    } else {
        [self setChatToolbar:self.oldToolBar];
        self.dataSource = self;
    }
}

- (void)showGroupDetailAction
{
    [self.view endEditing:YES];
    OfficialAccountsDetailViewController *detailView = [[OfficialAccountsDetailViewController alloc] initWithOfficialAccount:_officialAccount isFollow:YES];
    [self.navigationController pushViewController:detailView animated:YES];
}

- (void)cancelAction
{

}

#pragma mark - private

- (void)_dealWithMenu:(OfficialAccountMenu *)menu
{
    if ([menu.action isEqualToString:@"link"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:menu.url]];
        if (_menuView) {
            [_menuView removeFromSuperview];
            _menuView = nil;
        }
    } else if ([menu.action isEqualToString:@"auto_msg"]) {
        [[OfficialAccountsManager sharedInstance] autoReplyWithPaid:_officialAccount.paid
                                                            eventId:menu.eventid
                                                         completion:^(NSError *aError) {
                                                             if (aError) {
                                                             
                                                             }
                                                         }];
        if (_menuView) {
            [_menuView removeFromSuperview];
            _menuView = nil;
        }
    } else if ([menu.subMenu count] > 0){
        if (_menuView) {
            [_menuView removeFromSuperview];
            _menuView = nil;
        } else {
            NSInteger index = [self _indexWithMenu:menu];
            CGFloat width = (CGRectGetWidth([UIScreen mainScreen].bounds) - kDefault_Button_Width)/[_officialAccount.menus count];
            CGFloat left = kDefault_Button_Width + width * index;
            _menuView = [[OfficialAccountMenuView alloc] initWithMenu:menu left:left width:width];
            CGRect frame = _menuView.frame;
            frame.origin.y = CGRectGetMinY(self.chatToolbar.frame) - CGRectGetHeight(_menuView.frame);
            _menuView.frame = frame;
            _menuView.delegate = self;
            [self.view addSubview:_menuView];
        }
    }
}

- (NSInteger)_indexWithMenu:(OfficialAccountMenu *)menu
{
    NSInteger index = 0;
    if (menu !=nil) {
        index = [_officialAccount.menus indexOfObject:menu];
    }
    return index;
}

#pragma mark - override

- (void)sendTextMessage:(NSString *)text
{
    [self sendTextMessage:text withExt:@{@"em_pa_msg":@(YES)}];
}

@end
