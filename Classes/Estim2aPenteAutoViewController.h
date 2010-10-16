//
//  Estim2aPenteAutoViewController.h
//  iBDPV
//
//  Created by jmd on 01/08/10.
//  Copyright 2010 __MaCoDa__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Estim2aPenteAutoView;


@interface Estim2aPenteAutoViewController : UIViewController  <UIAccelerometerDelegate> {
    UIAccelerationValue accelerationX;
    UIAccelerationValue accelerationY;

    Estim2aPenteAutoView *estim2aPenteAutoView;

    float currentRawReading;
    float calibrationOffset;

}

@property float calibrationOffset;

//Action Back
-(void)actBack:(id)sender;

//Action Validate
-(void)actValidate:(id)sender;


@end
