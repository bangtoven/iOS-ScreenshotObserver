//
//  ScreenshotObserver.m
//  ScreenshotObserver
//
//  Created by Bangtoven on 13. 6. 8..
//  Copyright (c) 2013년 Bangtoven. All rights reserved.
//

#import "ScreenshotObserver.h"
#define PRINT_LOG 1

@interface ScreenshotObserver () {
    id<ScreenshotTakenDelegate> delegate;
    //    ScreenshotObserveOrientation orientation;
    CGSize deviceSize;
    CGSize rotatedDeviceSize;
    
    BOOL isWatching;
    dispatch_semaphore_t semaphore;
    NSDate *latestDate;
}

@end
@implementation ScreenshotObserver

- (id)initWithDelegate:(id<ScreenshotTakenDelegate>)_delegate{
    if (self = [super init]) {
        delegate = _delegate;
        deviceSize = [self determineDeivceSize];
        rotatedDeviceSize = CGSizeMake(deviceSize.height, deviceSize.width);
    }
    return self;
}

- (CGSize)determineDeivceSize {
    CGSize size = [UIScreen mainScreen].bounds.size;
    if ([UIScreen instancesRespondToSelector:@selector(scale)] && [[UIScreen mainScreen] scale]>1) {
        size = CGSizeMake(size.width*2, size.height*2);
    }
    return size;
}

- (void)startWatching {
    if (isWatching)
        return;
    
    if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied) {
        [delegate screenshotObservationDenied];
        return;
    }
    
    isWatching = YES;
    latestDate = [NSDate date];
    if (!semaphore)
        semaphore = dispatch_semaphore_create(0);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        while (isWatching) {
            [self watchForLastestScreenshot];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            sleep(2);
        }
        semaphore = NULL;
    });
}

- (void)stopWatching {
    isWatching = NO;
}

- (void)watchForLastestScreenshot {
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:
     ^(ALAssetsGroup *group, BOOL *stop) {
         [group setAssetsFilter:[ALAssetsFilter allPhotos]];
         if ([group numberOfAssets] <= 0) {
             [self sendSignalToRepeatWatchingWithLog:@"No assets" andLatestDate:nil];
             return;
         }
         
         [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:[group numberOfAssets] - 1] options:0 usingBlock:
          ^(ALAsset *alAsset, NSUInteger index, BOOL *innerStop) {
              if (alAsset == nil){
                  [self sendSignalToRepeatWatchingWithLog:@"Nil asset" andLatestDate:nil];
                  return;
              }
              
              NSDate *date = [alAsset valueForProperty:ALAssetPropertyDate];
              if ([date timeIntervalSinceDate:latestDate]<=0){
                  [self sendSignalToRepeatWatchingWithLog:@"Nothing taken" andLatestDate:nil];
                  return;
              }
              
              ALAssetRepresentation *representation = [alAsset defaultRepresentation];
              if ([representation.filename hasSuffix:@".PNG"]==NO && [representation.filename hasSuffix:@".png"]==NO){
                  [self sendSignalToRepeatWatchingWithLog:@"Not PNG file" andLatestDate:date];
                  return;
              }
              
              if (CGSizeEqualToSize(representation.dimensions, deviceSize)==NO && CGSizeEqualToSize(representation.dimensions, rotatedDeviceSize)==NO) {
                  NSLog(@"%f %f || %f %f",representation.dimensions.width, representation.dimensions.height, deviceSize.width, deviceSize.height);
                  [self sendSignalToRepeatWatchingWithLog:@"Wrong size" andLatestDate:date];
                  return;
              }
              
              dispatch_async(dispatch_get_main_queue(), ^{
                  [delegate screenshotWasTaken:[UIImage imageWithCGImage:[representation fullScreenImage]]];
              });
              [self sendSignalToRepeatWatchingWithLog:@"Screenshot taken!" andLatestDate:date];
          }];
     } failureBlock:nil];
}

- (void)sendSignalToRepeatWatchingWithLog:(NSString*)log andLatestDate:(NSDate*)date{
#if PRINT_LOG
    NSLog(@"%@", log);
#endif
    if (date)
        latestDate = date;
    dispatch_semaphore_signal(semaphore);
}

@end