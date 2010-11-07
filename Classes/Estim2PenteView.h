 //
 //Estim2PenteView.h
 //  iBDPV
 // JMD & DTR



#import <UIKit/UIKit.h>

@class Estim2PenteViewController;

@interface Estim2PenteView : UIView {
    Estim2PenteViewController *viewController;
    
    UISegmentedControl *choixVisible;
}

@property (nonatomic, assign) Estim2PenteViewController *viewController;

- (id)initWithFrame:(CGRect)frame viewController:(Estim2PenteViewController *)aController;

@end
