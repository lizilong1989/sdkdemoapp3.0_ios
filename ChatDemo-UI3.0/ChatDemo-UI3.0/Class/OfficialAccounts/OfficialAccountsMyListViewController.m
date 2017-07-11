//
//  OfficialAccountsMyListViewController.m
//  ChatDemo-UI3.0
//
//  Created by EaseMob on 2017/6/13.
//  Copyright © 2017年 EaseMob. All rights reserved.
//

#import "OfficialAccountsMyListViewController.h"

#import "OfficialAccountsListViewController.h"
#import "OfficialAccountsChatViewController.h"
#import "OfficialAccountsManager.h"
#import "OfficialAccount.h"

@interface OfficialAccountsMyListViewController ()

@end

@implementation OfficialAccountsMyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"title.myOfficialAccounts", @"Official My Accounts");
    
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [addButton setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(followAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    [self.navigationItem setRightBarButtonItem:addItem];
    
    self.page = 1;
    self.showRefreshHeader = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OfficialAccount *officialAccount = [self.dataArray objectAtIndex:indexPath.row];
    [self hideHud];
    [self showHudInView:self.view hint:NSLocalizedString(@"loadData", @"Load data...")];
    __weak typeof(self) weakSelf = self;
    [[OfficialAccountsManager sharedInstance] getOfficialAccountsWithPaid:officialAccount.paid
                                                            isIncludeMenu:YES
                                                               completion:^(OfficialAccount *aOfficialAccount, NSError *aError) {
                                                                   [weakSelf hideHud];
                                                                   if (!aError) {
                                                                       OfficialAccountsChatViewController *chatView = [[OfficialAccountsChatViewController alloc] initWithOfficialAccount:aOfficialAccount];
                                                                       [weakSelf.navigationController pushViewController:chatView animated:YES];
                                                                   }
                                                               }];
}

#pragma mark - data

- (void)tableViewDidTriggerHeaderRefresh
{
    self.page = 1;
    [self fetchOfficialAccountsWithPage:self.page isHeader:YES];
}

- (void)tableViewDidTriggerFooterRefresh
{
    self.page += 1;
    [self fetchOfficialAccountsWithPage:self.page isHeader:NO];
}

- (void)fetchOfficialAccountsWithPage:(NSInteger)aPage
                             isHeader:(BOOL)aIsHeader
{
    [self hideHud];
    [self showHudInView:self.view hint:NSLocalizedString(@"loadData", @"Load data...")];
    __weak typeof(self) weakSelf = self;
    [[OfficialAccountsManager sharedInstance] fetchMyOfficialAccountsWithPage:aPage
                                                                     pagesize:10
                                                                   completion:^(NSArray *aOfficialAccounts, NSError *aError) {
                                                                       if (weakSelf) {
                                                                           OfficialAccountsListViewController *strongSelf = weakSelf;
                                                                           [strongSelf hideHud];
                                                                           if (!aError) {
                                                                               if (aIsHeader) {
                                                                                   [strongSelf.dataArray removeAllObjects];
                                                                               }
                                                                               [strongSelf.dataArray addObjectsFromArray:aOfficialAccounts];
                                                                               [strongSelf.tableView reloadData];
                                                                               if (aOfficialAccounts.count > 0) {
                                                                                   strongSelf.showRefreshFooter = YES;
                                                                               } else {
                                                                                   strongSelf.showRefreshFooter = NO;
                                                                               }
                                                                           }
                                                                           [strongSelf tableViewDidFinishTriggerHeader:aIsHeader reload:NO];
                                                                       }
                                                                   }];
}

#pragma mark - action

- (void)followAction
{
    OfficialAccountsListViewController *listview = [[OfficialAccountsListViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:listview animated:YES];
}

@end
