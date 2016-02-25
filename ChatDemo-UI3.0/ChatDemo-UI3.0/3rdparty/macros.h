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

#import "XDDefine.h"
#ifndef Hyphenate_macros_h
#define Hyphenate_macros_h


#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

typedef enum _BasicViewControllerInfo {
    eBasicControllerInfo_Title,
    eBasicControllerInfo_ImageName,
    eBasicControllerInfo_BadgeString
}BasicViewControllerInfo;



#pragma mark - runtime macros
// check if runs on iPad
#define IS_IPAD_RUNTIME (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

// version check
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:       NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:       NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:       NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:       NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:       NSNumericSearch] != NSOrderedDescending)

#define NTF_WILLSENDMESSAGETOJID                @"NTF_WILLSENDMESSAGETOJID"
#define WILLSENDMESSAGETOJID                    @"WILLSENDMESSAGETOJID"
#define WILLSENDMESSAGETOJID_CHATROOMMESSAGE    @"WILLSENDMESSAGETOJID_CHATROOMMESSAGE"
#define WILLSENDMESSAGETOJID_CHATDATA           @"WILLSENDMESSAGETOJID_CHATDATA"

#define NTF_FINISHED_LOAD_DATA_FROM_DB  @"NTF_FINISHED_LOAD_DATA_FROM_DB"

// used in settings.
typedef enum _playSoundMode {
    ePlaySoundMode_AutoDetect,
    ePlaySoundMode_Speaker,
    ePlaySoundMode_Handset
}PlaySoundMode;

// exception macros
#define NOT_IMPLEMENTED_EXCEPTION   @"NOT_IMPLEMENTED_EXCEPTION"


#endif



