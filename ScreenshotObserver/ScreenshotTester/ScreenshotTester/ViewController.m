//
//  ViewController.m
//  ScreenshotTester
//
//  Created by Xeron on 13. 6. 8..
//  Copyright (c) 2013년 Bangtoven. All rights reserved.
//

#import "ViewController.h"
#import "ScreenshotObserver.h"

@interface ViewController () {
    ScreenshotObserver *so;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    so = [[ScreenshotObserver alloc] init];
}

- (IBAction)getLatestAction:(id)sender {
    UIImage *image = [so lastestScreenshot];
    self.imageView.image = image;
}

@end
