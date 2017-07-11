//
//  OfficialAccountsListViewController.m
//  ChatDemo-UI3.0
//
//  Created by EaseMob on 2017/5/25.
//  Copyright © 2017年 EaseMob. All rights reserved.
//

#import "OfficialAccountsListViewController.h"

#import "BaseTableViewCell.h"
#import "OfficialAccount.h"
#import "OfficialAccountsDetailViewController.h"
#import "OfficialAccountsManager.h"
#import "OfficialAccountsChatViewController.h"

@interface OfficialAccountsListViewController ()

@end

@implementation OfficialAccountsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"title.officialAccountsList", @"Official Accounts");
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    backButton.accessibilityIdentifier = @"back";
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
//    [self setupSearchController];
    
    [self tableViewDidTriggerHeaderRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GroupCell";
    BaseTableViewCell *cell = (BaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    OfficialAccount *officialAccount = [self.dataArray objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"groupPublicHeader"];
    if ([officialAccount.name length]) {
        cell.textLabel.text = officialAccount.name;
    } else {
        cell.textLabel.text = officialAccount.paid;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    OfficialAccount *officialAccount = [self.dataArray objectAtIndex:indexPath.row];
    if ([[OfficialAccountsManager sharedInstance] isOfficialAccountsWithPaid:officialAccount.paid]) {
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
    } else {
        OfficialAccountsDetailViewController *detailView = [[OfficialAccountsDetailViewController alloc] initWithOfficialAccount:officialAccount isFollow:NO];
        [self.navigationController pushViewController:detailView animated:YES];
    }
}

#pragma mark - action

- (void)followAction
{

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
    [[OfficialAccountsManager sharedInstance] fetchOfficialAccountsWithPage:aPage
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

@end
