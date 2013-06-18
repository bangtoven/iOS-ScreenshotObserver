//
//  ViewController.m
//  ScreenshotTester
//
//  Created by Bangtoven on 13. 6. 8..
//  Copyright (c) 2013년 Bangtoven. All rights reserved.
//

#import "ViewController.h"
#import "ScreenshotObserver.h"

@interface ViewController () <ScreenshotTakenDelegate>{
    ScreenshotObserver *so;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    so = [[ScreenshotObserver alloc] initWithDelegate:self];
}

- (IBAction)switchChangeAction:(UISwitch*)sender{
    if (sender.isOn) {
        [so startWatching];
    }
    else {
        [so stopWatching];
    }
}

- (void)screenshotWasTaken:(UIImage *)image {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Screenshot Taken" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    self.imageView.image = image;
}

- (void)screenshotObservationDenied {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"This happens when user denied access to her/his camera roll." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

@end
