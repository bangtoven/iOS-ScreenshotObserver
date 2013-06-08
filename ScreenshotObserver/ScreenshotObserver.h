//
//  ScreenshotObserver.h
//  ScreenshotObserver
//
//  Created by Bangtoven on 13. 6. 8..
//  Copyright (c) 2013년 Bangtoven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

//typedef enum Orientation {
//    Portrait = 1<<0,
//    Landscape = 1<<1,
//    Both = Portrait|Landscape
//} ScreenshotObserveOrientation;

@protocol ScreenshotTakenDelegate <NSObject>
- (void)screenshotObservationDenied;
- (void)screenshotWasTaken:(UIImage*)image;
@end

@interface ScreenshotObserver : NSObject

//- (id)initWithObserveOrientation:(ScreenshotObserveOrientation)orientation andDelegate:(id<ScreenshotTakenDelegate>)delegate;
- (id)initWithDelegate:(id<ScreenshotTakenDelegate>)delegate;
- (void)startWatching;
- (void)stopWatching;

@end
