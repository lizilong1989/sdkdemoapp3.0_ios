//
//  EMBaseRefreshTableController.m
//  ChatDemo-UI3.0
//
//  Created by EaseMob on 16/10/3.
//  Copyright © 2016年 easemob. All rights reserved.
//

#import "EMBaseRefreshTableController.h"

#define KEM_BASE_REFRESH_TINTCOLOR   [UIColor colorWithRed:82.0/255.0 green:210.0/255.0 blue:0.0/255.0 alpha:1.0]
#define KEM_BASE_REFRESH_ATTRIBUTES  @{NSForegroundColorAttributeName:KEM_BASE_REFRESH_TINTCOLOR}

#define KEM_BASE_REFRESH_DROPDOWN    NSLocalizedString(@"loading.dropdown", @"Drop down loading...")
#define KEM_BASE_REFRESH_START       NSLocalizedString(@"loading.start", @"Start loading...")
#define KEM_BASE_REFRESH_END         NSLocalizedString(@"loading.end", @"Loading completed...")


@interface EMBaseRefreshTableController ()

@property (nonatomic, strong) UIRefreshControl *footRefreshControl;

@end

@implementation EMBaseRefreshTableController
{
    CGPoint _defaultOffset;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _defaultOffset = self.tableView.contentOffset;
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)] && self.edgesForExtendedLayout == UIRectEdgeAll) {
        _defaultOffset.y = -64;
    }
    [self setupRefreshControl];

}

- (void)setupRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = KEM_BASE_REFRESH_TINTCOLOR;
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:KEM_BASE_REFRESH_DROPDOWN
                                                                          attributes:KEM_BASE_REFRESH_ATTRIBUTES];
    [self.refreshControl addTarget:self action:@selector(refreshHeaderAction) forControlEvents:UIControlEventValueChanged];
}

- (void)endHeaderRefresh {
    if (self.refreshControl.isRefreshing) {
        [self.refreshControl endRefreshing];
        [self.tableView setContentOffset:_defaultOffset animated:YES];
    }
    else {
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:KEM_BASE_REFRESH_END
                                                                              attributes:KEM_BASE_REFRESH_ATTRIBUTES];
    }
}

- (void)refreshHeaderAction {
    if (self.refreshControl.refreshing) {
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:KEM_BASE_REFRESH_START
                                                                              attributes:KEM_BASE_REFRESH_ATTRIBUTES];
        if (self.headerRefresh) {
            self.headerRefresh(self.refreshControl.refreshing);
        }
        else {
            [self.refreshControl endRefreshing];
            self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:KEM_BASE_REFRESH_END
                                                                                      attributes:KEM_BASE_REFRESH_ATTRIBUTES];
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.refreshControl.refreshing && scrollView.contentOffset.y == _defaultOffset.y) {
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:KEM_BASE_REFRESH_DROPDOWN
                                                                                  attributes:KEM_BASE_REFRESH_ATTRIBUTES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}


@end
