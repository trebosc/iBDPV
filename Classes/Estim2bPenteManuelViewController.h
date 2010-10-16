//
//  Estim2PenteViewController.h
//  iBDPV
//
//  Created by jmd on 01/08/10.
//  Copyright 2010 __MaCoDa__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Estim2bPenteManuelView.h"


@class Estim2bPenteManuelView;


@interface Estim2bPenteManuelViewController : UIViewController  <QuartzViewProtocol>{

    Estim2bPenteManuelView *estim2bPenteManuelView;
	UISlider *slider;

}


@property (nonatomic,retain) UISlider *slider;

-(void)fixeAngleToit:(id)sender;

-(void)angleToitModifie:(float)newAngle;

//Action Back
-(void)actBack:(id)sender;

//Action Validate
-(void)actValidate:(id)sender;


@end
