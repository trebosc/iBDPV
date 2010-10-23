//
//  Estim3OrientViewController.h
//  iBDPV
//
//  Created by jmd on 01/08/10.
//  Copyright 2010 __MaCoDa__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "UserData.h"

@class Estim3OrientView;

@interface Estim3OrientViewController : UIViewController  <CLLocationManagerDelegate>  {
    Estim3OrientView *estim3OrientView;

	CLLocationManager *locationManager;
    BOOL bBoussoleAutom; // A vrai si le device à la capacité "Boussole"
    UserData *userData;
    
}
@property (nonatomic, retain) CLLocationManager *locationManager;
@property  BOOL bBoussoleAutom;
@property (nonatomic,retain) UserData *userData;

//Action Back
-(void)actBack:(id)sender;
//Action Validate
-(void)actValidate:(id)sender;

@end
