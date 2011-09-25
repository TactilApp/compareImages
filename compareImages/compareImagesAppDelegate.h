//
//  compareImagesAppDelegate.h
//  compareImages
//
//  Created by Jorge Maroto García on 25/09/11.
//  Copyright 2011 http://www.tactilapp.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class compareImagesViewController;

@interface compareImagesAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet compareImagesViewController *viewController;

@end
