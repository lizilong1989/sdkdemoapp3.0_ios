/************************************************************
  *  * Hyphenate CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2015-2016 Hyphenate Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of Hyphenate Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from Hyphenate Technologies.
  */

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "ApplyViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, EMChatManagerDelegate>
{
    EMConnectionState _connectionState;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MainViewController *mainController;

@end
