//
//  AppDelegate.h
//  Test7
//
//  Created by OzekiSyunsuke on 12/03/22.
//  Copyright 2dgame.jp 2012年. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
