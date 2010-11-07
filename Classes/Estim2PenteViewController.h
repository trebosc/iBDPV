//
//  Estim2PenteViewController.h
//  iBDPV
// JMD & DTR

#import <UIKit/UIKit.h>
#import "UserData.h"

@class Estim2PenteView;


@interface Estim2PenteViewController : UIViewController  {
    Estim2PenteView *estim2PenteView;
    
    BOOL bPenteVisible;
    
    UserData *userData;

}

@property BOOL bPenteVisible;
@property (nonatomic,retain) UserData *userData;

//Action Back
-(void)actBack:(id)sender;

//Action Validate
-(void)actValidate:(id)sender;


@end
