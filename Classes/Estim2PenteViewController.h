//
//  Estim2PenteViewController.h
//  iBDPV
//
//  Created by jmd on 01/08/10.
//  Copyright 2010 __MaCoDa__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Estim2PenteView;


@interface Estim2PenteViewController : UIViewController  {
    Estim2PenteView *estim2PenteView;
    
    BOOL bPenteVisible;

}

@property BOOL bPenteVisible;


//Action Back
-(void)actBack:(id)sender;

//Action Validate
-(void)actValidate:(id)sender;


@end
