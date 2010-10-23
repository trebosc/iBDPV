/*
 
 File: Estim2PenteView.h
 Abstract: Estim2PenteView builds and displays the primary user interface of the Bubble
 Level application.
 
 Version: 1.8
 
 
 */


#import <UIKit/UIKit.h>


@class Estim2bPenteManuelViewController;

@protocol QuartzViewProtocol

-(void)angleToitModifie:(float)newAngle;

@end


@interface Estim2bPenteManuelView : UIView {
    Estim2bPenteManuelViewController *viewController;
	bool bTrackTouche;
	CGFloat angleToit;
    UILabel *degreeDisplayView;
	UILabel *pourcentDisplayView;

}

@property (nonatomic, assign) Estim2bPenteManuelViewController *viewController;

- (id)initWithFrame:(CGRect)frame viewController:(Estim2bPenteManuelViewController *)aController;
-(void)setAngleToit:(CGFloat)phase;


@end
