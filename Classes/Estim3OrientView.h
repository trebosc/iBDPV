/*
 
 File: Estim3OrientView.h
 Abstract: Estim3OrientView builds and displays the primary user interface of the Bubble
 Level application.
 
 Version: 1.8
 
 
 */


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
	float angleActuelAbsolu;


}

@property (nonatomic, assign) Estim3OrientViewController *viewController;

- (id)initWithFrame:(CGRect)frame viewController:(Estim3OrientViewController *)aController;
- (void)updateDisplayAngle:(float)rotation;
- (void)updateBoussoleAngle:(float)rotation;
- (int)LectureAngleBoussole;


@end
