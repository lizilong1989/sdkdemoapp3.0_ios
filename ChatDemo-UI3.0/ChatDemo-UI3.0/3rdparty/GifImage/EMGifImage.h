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
#import <ImageIO/ImageIO.h>

@interface EMGifImage : UIImage

@property (nonatomic, readonly) NSTimeInterval *frameDurations;
@property (nonatomic, readonly) NSTimeInterval totalDuration;
@property (nonatomic, readonly) NSUInteger loopCount;

- (NSTimeInterval)frameDurationWithIndex:(NSInteger)index;
@end
