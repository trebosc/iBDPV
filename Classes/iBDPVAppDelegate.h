//
//  iBDPVAppDelegat.h
//  iBDPV
// JMD & DTR


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
