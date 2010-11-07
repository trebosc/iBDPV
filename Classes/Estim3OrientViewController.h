//
//  Estim3OrientViewController.h
//  iBDPV
// JMD & DTR


#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "UserData.h"

@class Estim3OrientView;

@interface Estim3OrientViewController : UIViewController  <CLLocationManagerDelegate>  {
    Estim3OrientView *estim3OrientView;

	CLLocationManager *locationManager;

	CLLocationDirection Orientation; // Direction de la bousolle en degré par rapport au vrai Nord.
    BOOL bBoussoleAutom; // A vrai si le device à la capacité "Boussole"
    UserData *userData;
    
}
@property (nonatomic, retain) CLLocationManager *locationManager;
@property  BOOL bBoussoleAutom;
@property  CLLocationDirection Orientation;
@property (nonatomic,retain) UserData *userData;

//Action Back
-(void)actBack:(id)sender;
//Action Validate
-(void)actValidate:(id)sender;

//Build URLs
-(NSURL *)buildURL;

@end
