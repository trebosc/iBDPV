/*
 
 File: Estim2PenteView.h
 Abstract: Estim2PenteView builds and displays the primary user interface of the Bubble
 Level application.
 
 Version: 1.8
 
 
 */


#import <UIKit/UIKit.h>

@class Estim2PenteViewController;

@interface Estim2PenteView : UIView {
    Estim2PenteViewController *viewController;
    
    UISegmentedControl *choixVisible;
}

@property (nonatomic, assign) Estim2PenteViewController *viewController;

- (id)initWithFrame:(CGRect)frame viewController:(Estim2PenteViewController *)aController;

@end
