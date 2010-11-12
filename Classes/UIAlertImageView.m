//
//  UIAlertImageView.m
//  iBDPV
// JMD & DTR


#import "UIAlertImageView.h"

#define kImagePadding 8.0f


@interface UIAlertView (private)
- (void)layoutAnimated:(BOOL)fp8;
@end

@implementation UIAlertImageView

@synthesize imageHeight;
@synthesize imageView;
@synthesize imageWidth;



//-------------------------------------------------------------------------------------------------------------------------------
- (void)layoutAnimated:(BOOL)fp8 {
	[super layoutAnimated:fp8];
	[self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y - imageExtHeight/2, self.frame.size.width, self.frame.size.height + imageExtHeight)];
	
	// We get the lowest non-control view (i.e. Labels) so we can place the image view just below
	UIView *lowestView;
	int i = 0;
	while (![[self.subviews objectAtIndex:i] isKindOfClass:[UIControl class]]) {
		lowestView = [self.subviews objectAtIndex:i];
		i++;
	}
	
	// imageWidth = 262.0f;
	CGFloat PosGauche = (262.0f - imageWidth)/2;
	//imageView.frame = CGRectMake(11.0f, lowestView.frame.origin.y + lowestView.frame.size.height + 2 * kImagePadding, imageWidth, imageHeight);
	imageView.frame = CGRectMake(PosGauche, lowestView.frame.origin.y + lowestView.frame.size.height + 2 * kImagePadding, imageWidth, imageHeight);
	
	for (UIView *sv in self.subviews) {
		// Move all Controls down
		if ([sv isKindOfClass:[UIControl class]]) {
			sv.frame = CGRectMake(sv.frame.origin.x, sv.frame.origin.y + imageExtHeight, sv.frame.size.width, sv.frame.size.height);
		}
	}
	
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void)show{
	[self prepare];
    [super show];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void)prepare {	
	UIImage *imageChargee = [UIImage imageNamed:@"explication_pente_accelerometre.png"];

	imageView = [[UIImageView alloc] initWithImage:imageChargee];
	
    CGSize imgSize = imageChargee.size;
    CGFloat fltHeight = imgSize.height;
    CGFloat fltWidth = imgSize.width;
    CGFloat ratio = fltHeight / fltWidth;
    fltWidth = 170;
	fltHeight = fltWidth *ratio;
    imageHeight = fltHeight;
	imageWidth = fltWidth;
	imageExtHeight = fltHeight + 2 * kImagePadding;

		
	[self insertSubview:imageView atIndex:0];
	
	[self setNeedsLayout];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
	[imageView release];
    [super dealloc];
} // Fin du - (void)dealloc {


@end