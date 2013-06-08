//
//  ScreenshotObserver.h
//  ScreenshotObserver
//
//  Created by Xeron on 13. 6. 8..
//  Copyright (c) 2013년 Bangtoven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@protocol ScreenshotTakenDelegate <NSObject>
- (void)screenshotWasTaken:(UIImage*)image;
@end

@interface ScreenshotObserver : NSObject
@property (nonatomic,weak) id<ScreenshotTakenDelegate> delegate;
- (UIImage*)lastestScreenshot;
@end
