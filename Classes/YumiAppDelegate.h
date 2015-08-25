//
//  YumiAppDelegate.h
//  Yumi
//
//  Created by tech sam on 3/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YumiViewController;

@interface YumiAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    YumiViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet YumiViewController *viewController;

@end

