//
//  Estim1GPSViewController.h
//  iBDPV
//
//  Created by jmd on 01/08/10.
//  Copyright 2010 __MaCoDa__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "UserData.h"

@interface AddressAnnotationView : MKPinAnnotationView {
    @private
    
    CGPoint _startLocation;
    CGPoint _originalCenter;
    bool _isMoving;
    MKMapView *_mapView;
}
@end

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
}

@property(nonatomic,retain) MKMapView *mapView;
@property (nonatomic, copy) NSString *menuOrigin;
@property (nonatomic,retain) UIToolbar *toolbarSearchAddress;
@property (nonatomic,retain) UserData *userData;
@property (nonatomic,retain) UIBarButtonItem *validateItem;

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


-(CLLocationCoordinate2D) addressLocation:(NSString *)address;

@end

