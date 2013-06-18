//
//  ScreenshotObserver.h
//  ScreenshotObserver
//
//  Created by Bangtoven on 13. 6. 8..
//  Copyright (c) 2013 Bangtoven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

#define DEBUG_LOG 0

@protocol ScreenshotTakenDelegate <NSObject>
- (void)screenshotWasTaken:(UIImage*)image;
- (void)screenshotObservationDenied;
@end

@interface ScreenshotObserver : NSObject

@property NSUInteger observationInterval; // default: 2sec

- (id)initWithDelegate:(id<ScreenshotTakenDelegate>)delegate;
- (void)startWatching;
- (void)stopWatching;

@end
