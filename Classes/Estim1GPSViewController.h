//
//  Estim1GPSViewController.h
//  iBDPV
// JMD & DTR


#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "UserData.h"

@interface AddressAnnotation : NSObject<MKAnnotation> {
	
    CLLocationCoordinate2D coordinate;
	NSString *mTitle;
	NSString *mSubTitle;
}

@end

@interface Estim1GPSViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate,NSXMLParserDelegate> {

    MKMapView *mapView;
    
    AddressAnnotation *pinAnnotation;
    
    NSString *menuOrigin;
    
    UIToolbar *toolbarSearchAddress;
    
    NSMutableData *receivedData;
    NSMutableString *currentStringValue;
    
    UserData *userData;
    
    UIBarButtonItem *validateItem;
    
    UIActivityIndicatorView *activityIndicator;
}

@property(nonatomic,retain) MKMapView *mapView;
@property (nonatomic, copy) NSString *menuOrigin;
@property (nonatomic,retain) UIToolbar *toolbarSearchAddress;
@property (nonatomic,retain) UserData *userData;
@property (nonatomic,retain) UIBarButtonItem *validateItem;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;

//Action Back
-(void)actBack:(id)sender;
//Action Validate
-(void)actValidate:(id)sender;
//Action Display Toolbar Search Address
-(void)actDisplayToolbarSearchAddress:(id)sender;
// Action Annuler
-(void)actAnnuler:(id)sender;
//Action Localize
-(void)actLocalize:(id)sender;

-(NSURL *)buildSitesProchesURL;
-(void)displayNextScreen;
    
-(CLLocationCoordinate2D) addressLocation:(NSString *)address;

@end

