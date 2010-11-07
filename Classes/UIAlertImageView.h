//
//  UIAlertImageView.h
//  iBDPV
// JMD & DTR


#import <UIKit/UIKit.h>

@class UIAlertView;

@interface UIAlertImageView : UIAlertView {
	// The Alert View to decorate
    UIAlertView *alertView;
	
	// The Image View to display
	UIImageView *imageView;
	
	// Hauteur of the image
	int imageHeight;
	
	// Lartgeur of the image
	int imageWidth;
	
	// Space the Image requires (incl. padding)
	int imageExtHeight;
	
}


@property (nonatomic, readonly) UIImageView *imageView;
@property (nonatomic, assign) int imageHeight;
@property (nonatomic, assign) int imageWidth;

- (void)prepare;

@end