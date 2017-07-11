//
//  OfficialAccountWebViewController.m
//  ChatDemo-UI3.0
//
//  Created by EaseMob on 2017/6/21.
//  Copyright © 2017年 EaseMob. All rights reserved.
//

#import "OfficialAccountWebViewController.h"

#import "OfficialAccountMessage.h"

@interface OfficialAccountWebViewController ()
{
    OfficialAccountMessageItem *_item;
}

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation OfficialAccountWebViewController

- (instancetype)initWithItem:(OfficialAccountMessageItem *)aItem
{
    self = [super init];
    if (self) {
        _item = aItem;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = _item.title;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    backButton.accessibilityIdentifier = @"back";
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [addButton setTitle:NSLocalizedString(@"officialAccount.origin", @"Origin") forState:UIControlStateNormal];
    addButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [addButton addTarget:self action:@selector(openOriginUrlAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    [self.navigationItem setRightBarButtonItem:addItem];
    
    [self.view addSubview:self.webView];
}

#pragma mark - getter

- (UIWebView*)webView
{
    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
        [_webView loadHTMLString:_item.brief baseURL:nil];
    }
    return _webView;
}

#pragma mark - action

- (void)openOriginUrlAction
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_item.oriUrl]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
