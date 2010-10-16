//
//  iBDPVAppDelegate.h
//  iBDPV
//
//  Created by jmd on 16/10/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserData.h"

@interface iBDPVAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    
    UINavigationController *navController;
    UserData *userData;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic,retain) UINavigationController *navController;
@property (nonatomic, retain) UserData *userData;

@end
