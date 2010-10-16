//
//  iBDPVAppDelegate.m
//  iBDPV
//
//  Created by jmd on 16/10/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "iBDPVAppDelegate.h"

@implementation iBDPVAppDelegate


@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // Override point for customization after application launch.
    [window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {

    // Save data if appropriate.
}

- (void)dealloc {

    [window release];
    [super dealloc];
}

@end
