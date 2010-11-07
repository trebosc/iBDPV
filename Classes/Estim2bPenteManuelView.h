
 //
// Estim2bPenteManuelView.h
 //  iBDPV
 // JMD & DTR



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
-(int)LectureAngleToit;


@end
