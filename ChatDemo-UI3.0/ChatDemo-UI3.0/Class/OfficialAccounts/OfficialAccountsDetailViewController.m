//
//  OfficialAccountsDetailViewController.m
//  ChatDemo-UI3.0
//
//  Created by EaseMob on 2017/6/1.
//  Copyright © 2017年 EaseMob. All rights reserved.
//

#import "OfficialAccountsDetailViewController.h"

#import "OfficialAccount.h"
#import "OfficialAccountsManager.h"
#import "OfficialAccountsChatViewController.h"

@interface OfficialAccountsDetailViewController ()
{
    OfficialAccount *_offcialAccount;
    BOOL _isFollow;
}

@property (nonatomic, strong) UIView *footerView;

@end

@implementation OfficialAccountsDetailViewController

- (instancetype)initWithOfficialAccount:(OfficialAccount *)officialAccount isFollow:(BOOL)isFollow
{
    self = [super init];
    if (self) {
        _offcialAccount = officialAccount;
        _isFollow = isFollow;
    }
    return self;
}

- (OfficialAccount*)officialAccount
{
    return _offcialAccount;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"title.officialAccount", @"Official Account");
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = self.footerView;
    self.tableView.allowsSelection = NO;
    
    [self setupBarButtonItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setup

- (void)setupBarButtonItem
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    backButton.accessibilityIdentifier = @"back";
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
}

#pragma mark - getter

- (UIView *)footerView
{
    if (_footerView == nil) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
        _footerView.backgroundColor = [UIColor clearColor];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, 0, _footerView.frame.size.width - 10, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [_footerView addSubview:line];
        
        UIButton *followButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, _footerView.frame.size.width - 20, 45)];
        if (!_isFollow) {
            [followButton setBackgroundColor:RGBACOLOR(0x1f, 0xb9, 0x22, 1)];
            [followButton setTitle:NSLocalizedString(@"officialAccount.follow", @"Follow") forState:UIControlStateNormal];
            [followButton addTarget:self action:@selector(followAction) forControlEvents:UIControlEventTouchUpInside];
        } else {
            [followButton setTitle:NSLocalizedString(@"officialAccount.unfollow", @"UnFollow") forState:UIControlStateNormal];
            [followButton setBackgroundColor:RGBACOLOR(0xfe, 0x64, 0x50, 1)];
            [followButton addTarget:self action:@selector(unFollowAction) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_footerView addSubview:followButton];
    }
    
    return _footerView;
}

#pragma mark - Table view datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    if (indexPath.row == 0) {
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:_offcialAccount.logo] placeholderImage:[UIImage imageNamed:@"chatListCellHead"]];
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
        cell.imageView.layer.masksToBounds = YES;
    } else if (indexPath.row == 1) {
        cell.textLabel.text = NSLocalizedString(@"officialAccount.name", @"Name");
        cell.detailTextLabel.text = _offcialAccount.name.length > 0 ? _offcialAccount.name : _offcialAccount.paid;
    } else if (indexPath.row == 2) {
        cell.textLabel.text = NSLocalizedString(@"officialAccount.desc", @"Description");
        cell.detailTextLabel.text = _offcialAccount.desc;
    }
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 80;
    }
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - action

- (void)followAction
{
    [self hideHud];
    [self showHudInView:self.view hint:@"Follow..."];
    __weak typeof(self) weakSelf = self;
    
    dispatch_block_t block = ^{
        [[OfficialAccountsManager sharedInstance] getOfficialAccountsWithPaid:[weakSelf officialAccount].paid
                                                                isIncludeMenu:YES
                                                                   completion:^(OfficialAccount *aOfficialAccount, NSError *aError) {
                                                                       [weakSelf hideHud];
                                                                       if (!aError) {
                                                                           NSMutableArray *array = [NSMutableArray arrayWithArray:[weakSelf.navigationController viewControllers]];
                                                                           if ([array count] > 0) {
                                                                               [array removeLastObject];
                                                                           }
                                                                           OfficialAccountsChatViewController *chatView = [[OfficialAccountsChatViewController alloc] initWithOfficialAccount:aOfficialAccount];
                                                                           [array addObject:chatView];
                                                                           [weakSelf.navigationController setViewControllers:array animated:YES];
                                                                       }
                                                                   }];
    };
    
    [[OfficialAccountsManager sharedInstance] followOfficialAccountsWithPaid:_offcialAccount.paid
                                                                  completion:^(NSError *aError) {
                                                                      [weakSelf hideHud];
                                                                      if (!aError) {
                                                                          block();
                                                                      } else {
                                                                          [weakSelf showHint:@"Follow failed"];
                                                                      }
                                                                }];
}

- (void)unFollowAction
{
    [self hideHud];
    [self showHudInView:self.view hint:@"unFollow..."];
    __weak typeof(self) weakSelf = self;
    [[OfficialAccountsManager sharedInstance] unFollowOfficialAccountsWithPaid:_offcialAccount.paid
                                                                    completion:^(NSError *aError) {
                                                                        [weakSelf hideHud];
                                                                        if (!aError) {
                                                                            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                                                                            [[EMClient sharedClient].chatManager deleteConversation:[weakSelf officialAccount].agentuser isDeleteMessages:YES completion:nil];
                                                                        } else {
                                                                             [weakSelf showHint:@"unFollow failed"];
                                                                        }
                                                                    }];
}

@end
