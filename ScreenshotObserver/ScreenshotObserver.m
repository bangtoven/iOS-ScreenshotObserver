//
//  ScreenshotObserver.m
//  ScreenshotObserver
//
//  Created by Xeron on 13. 6. 8..
//  Copyright (c) 2013년 Bangtoven. All rights reserved.
//

#import "ScreenshotObserver.h"

@implementation ScreenshotObserver

- (UIImage*)lastestScreenshot {
    __block UIImage *latestPhoto;
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        if ([group numberOfAssets] > 0) {
            [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:[group numberOfAssets] - 1] options:0 usingBlock:^(ALAsset *alAsset, NSUInteger index, BOOL *innerStop) {
                if (alAsset) {
                    ALAssetRepresentation *representation = [alAsset defaultRepresentation];
                    NSLog(@"%@",representation.filename);
                    NSLog(@"%.0f * %.0f",representation.dimensions.width, representation.dimensions.height);
                    latestPhoto = [UIImage imageWithCGImage:[representation fullScreenImage]];
                }
            }];
        }
    } failureBlock:nil];
    
    return latestPhoto;
}

@end
