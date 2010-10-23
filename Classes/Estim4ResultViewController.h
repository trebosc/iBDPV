//
//  Estim4ResultViewController.h
//  iBDPV
//
//  Created by jmd on 01/08/10.
//  Copyright 2010 __MaCoDa__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserData.h"

@interface Estim4ResultViewController : UIViewController {
UserData *userData;
}

@property (nonatomic,retain) UserData *userData;

//Action Back
-(void)actBack:(id)sender;
//Action Validate
-(void)actValidate:(id)sender;

@end
