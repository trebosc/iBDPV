 //
 // Estim3OrientView.h
 //  iBDPV
 // JMD & DTR



#import <UIKit/UIKit.h>

@class Estim3OrientViewController;

@interface Estim3OrientView : UIView {
    Estim3OrientViewController *viewController;
	UIImageView *silhouette_vue_dessusView;
	UIImageView *maison_vue_dessusView;
	UIImageView *boussoleView;
	UILabel *degreeDisplayView;
    
	BOOL bTouchBoussole;  // Est-ce que l'utilisateur a appuyé sur la boussole avec son doigt
    float angleDepartTouch;  // Angle de départ pour pouvoir tourner comme il faut
	float angleActuelAbsolu; // Angle pour faire bouger la bousolle en mode manuel
	float angleAff; // Angle affiché 
}

@property (nonatomic, assign) Estim3OrientViewController *viewController;

- (id)initWithFrame:(CGRect)frame viewController:(Estim3OrientViewController *)aController;
- (void)updateDisplayAngle:(float)rotation;
- (void)updateBoussoleAngle:(float)rotation;
- (int)LectureAngleBoussoleAff;


@end
