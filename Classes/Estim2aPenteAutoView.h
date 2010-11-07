
 // Estim2aPenteAutoView.h
 // iBDPV
 // JMD & DTR



#import <UIKit/UIKit.h>


@class Estim2aPenteAutoViewController;

@interface Estim2aPenteAutoView : UIView {
    Estim2aPenteAutoViewController *viewController;
	UIImageView *levelFrontDroiteView;
	UIImageView *levelFrontGaucheView;
	UILabel *degreeDisplayView;
	UILabel *shadowDegreeDisplayView;
	UILabel *pourcentDisplayView;
	UILabel *shadowPourcentDisplayView;
    int Pente;
}

@property (nonatomic, assign) Estim2aPenteAutoViewController *viewController;

- (id)initWithFrame:(CGRect)frame viewController:(Estim2aPenteAutoViewController *)aController;
- (void)updateToInclinationInRadians:(float)rotation;
- (int)LectureAngleDegre;

@end
