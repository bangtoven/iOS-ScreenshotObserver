//
//  ViewController.h
//  ScreenshotTester
//
//  Created by Bangtoven on 13. 6. 8..
//  Copyright (c) 2013년 Bangtoven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)switchChangeAction:(UISwitch*)sender;

@end
