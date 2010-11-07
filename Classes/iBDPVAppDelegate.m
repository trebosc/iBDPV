//
//  iBDPVAppDelegat.m
//  iBDPV
// JMD & DTR

#import "iBDPVAppDelegate.h"
#import "MenuViewController.h"


@implementation iBDPVAppDelegate


@synthesize window, navController, userData;

//-------------------------------------------------------------------------------------------------------------------------------
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
	//NSLog(@"didFinishLaunchingWithOptions iPhone");
    
    //Initialisation de la propriété userData
    self.userData=[[UserData alloc] init];
    
    //Cr�ation du MenuViewController = rootViewController
    MenuViewController *menuViewController=[[MenuViewController alloc] init];
    menuViewController.title=@"Menu";
    menuViewController.userData=self.userData;
    
    //Cr�ation du NavigationController
    //Le MenuViewController devient le controller racine du NavigationController
    navController=[[UINavigationController alloc] initWithRootViewController:menuViewController];
    [menuViewController release];
    
    
    //Affectation de la premi√®re View du Navigation Controller √† la Window
    window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [window addSubview:navController.view];
    [window makeKeyAndVisible];
	
	return YES;
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void)applicationWillTerminate:(UIApplication *)application {

    // Save data if appropriate.
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {

    //Libération des objets
	[navController release];
    [userData release];
    
    [window release];
    [super dealloc];
}

@end
