 //
 // Estim3OrientView.m
 //  iBDPV
 // JMD & DTR


#import "math.h"

#import "Estim3OrientView.h"
#import "Estim3OrientViewController.h"
#import <QuartzCore/QuartzCore.h>



CGFloat DegreesToRadians2(CGFloat degrees) {return degrees * M_PI / 180;};
CGFloat RadiansToDegrees2(CGFloat radians) {return radians * 180/M_PI;};


//-------------------------------------------------------------------------------------------------------------------------------
float FctModulo360(float angle) {
	//NSLog(@"Angle in :%0.0f",angle);
    
	if (angle <0) 
		angle = 360 + angle;
	else { // Avec le if (angle <0) 
		if (angle >=360) 
			angle = angle - 360;
	} // Fin du if (angle <0) 
	
	//NSLog(@"Angle Out :%0.0f",angle);
    
	return angle;
	
} // Fin de FctModulo360

//-------------------------------------------------------------------------------------------------------------------------------
float CalculeAngle(CGPoint position, float angleInit) {
	
	//NSLog(@"Posisiont X:%0.0f Y:%0.0f",position.x,position.y);
	float diffX =  position.x - 160.0;  // ATTENTION, IL FAUDRA PRENDRE LE CENTRE RELLE DE L'IMAGE par CODE
	float diffY =  214.0 - position.y;  // Comme cela on pourra modifier inteface sans touchez ces valeurs.
	// Hypothénuse
	float rayonTouche =sqrt(diffX*diffX +diffY*diffY);
	float angleX = RadiansToDegrees2(acos(diffX/rayonTouche));
	float angleY = RadiansToDegrees2(acos(diffY/rayonTouche));
	float angleResult;
    
	if (angleY >=90.0)
		angleResult  = angleX+90.0;
	else {
		if (angleX > 90.0)
			angleResult = 360 - angleY;
		else
			angleResult = angleY;
	} // Fin du if (angleY >=90.0)
    
	// On repositionne l'angle par rapport à l'angle de départ (touch initial)
	angleResult = FctModulo360(angleResult - angleInit);
	
	return angleResult;
    
} // Fin du float CalculeAngle(CGPoint position, float angleInit) {



//-------------------------------------------------------------------------------------------------------------------------------


@interface Estim3OrientView (PrivateMethods)
- (void)setupSubviewsWithContentFrame:(CGRect)frameRect;
// Private Methods
-(void)dispatchFirstTouchAtPoint:(CGPoint)touchPoint forEvent:(UIEvent *)event;
-(void)dispatchTouchMoveEvent:(UIView *)theView toPosition:(CGPoint)position;
-(void)dispatchTouchEndEvent:(UIView *)theView toPosition:(CGPoint)position;

@end


@implementation Estim3OrientView

@synthesize viewController;

//#########################################################################################################################################################
//#########################################################################################################################################################
#pragma mark -
#pragma mark === Setting up / Tearing down ===
#pragma mark -

//-------------------------------------------------------------------------------------------------------------------------------
- (id)initWithFrame:(CGRect)frame viewController:(Estim3OrientViewController *)aController {
    self = [super initWithFrame:frame];
    if (self != nil) {
        self.viewController = aController;
        
		[self setupSubviewsWithContentFrame:frame];
    }
    
    return self;
} // Fin du initWithFrame

//-------------------------------------------------------------------------------------------------------------------------------
- (void)setupSubviewsWithContentFrame:(CGRect)frameRect {
    CGRect frame;

    
    maison_vue_dessusView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"maison_vue_dessus.png"]];
    maison_vue_dessusView.opaque = YES;
    frame = maison_vue_dessusView.frame;
    frame.origin.x = 55.0;
    frame.origin.y = -90.0;
    maison_vue_dessusView.frame = frame;

    silhouette_vue_dessusView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"silhouette_vue_dessus.png"]];
    silhouette_vue_dessusView.opaque = YES;
    frame = silhouette_vue_dessusView.frame;
    frame.origin.x = 137.0;
    frame.origin.y = 40.0;
    silhouette_vue_dessusView.frame = frame;
    
    
    UILabel	*lblFace=[[UILabel alloc] initWithFrame:CGRectMake(0.0, 88.0, 320, 20)];
	lblFace.text=@"Mettez-vous face à votre toiture";
    lblFace.textColor = [UIColor whiteColor];
    lblFace.backgroundColor = [UIColor blackColor];
    lblFace.textAlignment = UITextAlignmentCenter;
    [self addSubview:lblFace];
    [lblFace release];
    
    
    boussoleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"boussole.png"]];
    boussoleView.opaque = YES;
    frame = boussoleView.frame;
    frame.origin.x = 77.0;
    frame.origin.y = 130.0;
    boussoleView.frame = frame;
    
    lblFace=[[UILabel alloc] initWithFrame:CGRectMake(0.0, 300.0, 320, 20)];
    if (self.viewController.bBoussoleAutom) 
        lblFace.text=@"Attendez que la boussole s'arrête";
    else
        lblFace.text=@"Indiquez le Nord sur la boussole";

    lblFace.textColor = [UIColor whiteColor];
    lblFace.backgroundColor = [UIColor blackColor];
    lblFace.textAlignment = UITextAlignmentCenter;
    [self addSubview:lblFace];
    [lblFace release];

    lblFace=[[UILabel alloc] initWithFrame:CGRectMake(0.0, 320.0, 320, 20)];
    if (self.viewController.bBoussoleAutom) 
        lblFace.text=@"puis appuyez sur le bouton 'Valider'";
    else
        lblFace.text=@"en la faisant tourner avec votre doigt";
    lblFace.textColor = [UIColor whiteColor];
    lblFace.backgroundColor = [UIColor blackColor];
    lblFace.textAlignment = UITextAlignmentCenter;
    [self addSubview:lblFace];
    [lblFace release];
    
    degreeDisplayView = [[UILabel alloc] initWithFrame:CGRectMake(245, 266, 55, 26)];
    degreeDisplayView.text = @"0°";
    degreeDisplayView.textAlignment = UITextAlignmentRight;


 	
    // add view in proper order and location
    [self addSubview:maison_vue_dessusView];
    [self addSubview:silhouette_vue_dessusView];
    [self addSubview:boussoleView];    
    [self addSubview:degreeDisplayView];

    
    [self setNeedsDisplay];
    
} // Fin du - (void)setupSubviewsWithContentFrame:(CGRect)frameRect {


//-------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
	[maison_vue_dessusView release];
	[silhouette_vue_dessusView release];
	[boussoleView release];
    [degreeDisplayView release];
    [super dealloc];
} // Fin du - (void)dealloc {



//#########################################################################################################################################################
//#########################################################################################################################################################
#pragma mark -
#pragma mark ===  Gestion des Touch Events ===
#pragma mark -


//-------------------------------------------------------------------------------------------------------------------------------
// Handles the start of a touch
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	// Enumerate through all the touch objects.
	NSUInteger touchCount = 0;
	for (UITouch *touch in touches) {
		// Send to the dispatch method, which will make sure the appropriate subview is acted upon
		[self dispatchFirstTouchAtPoint:[touch locationInView:self] forEvent:nil];
		touchCount++;  
	} // Fin du for (UITouch *touch in touches) {

} // Fin du -(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event


//-------------------------------------------------------------------------------------------------------------------------------
// Checks to see which view, or views, the point is in and then calls a method to perform the opening animation,
// which  makes the piece slightly larger, as if it is being picked up by the user.
-(void)dispatchFirstTouchAtPoint:(CGPoint)touchPoint forEvent:(UIEvent *)event
{
    
	if (CGRectContainsPoint([boussoleView frame], touchPoint)) {
        //		NSLog(@"BEGIN >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
		bTouchBoussole = YES;
        
		// On la position du point 'Touch' en terme d'angle
		float angleResult = CalculeAngle(touchPoint,angleActuelAbsolu);
		angleDepartTouch = angleResult;
        //		NSLog(@" =>AngleDepartTouch  : %0.0f ",angleResult);
		
	} // Fin du if (CGRectContainsPoint([boussoleView frame], touchPoint)) {
    
    // Si la boussole est en mode automatique, on ne gère pas les Touch Events
    if (self.viewController.bBoussoleAutom)
        bTouchBoussole = NO;
    
} // Fin du -(void)dispatchFirstTouchAtPoint:(CGPoint)touchPoint forEvent:(UIEvent *)event


//-------------------------------------------------------------------------------------------------------------------------------
// Handles the continuation of a touch.
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{  
	
	// Enumerates through all touch objects
	for (UITouch *touch in touches) {
		// Send to the dispatch method, which will make sure the appropriate subview is acted upon
		[self dispatchTouchMoveEvent:[touch view] toPosition:[touch locationInView:self]];
	} // Fin du 	for (UITouch *touch in touches) {

} // Fin du -(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event


//-------------------------------------------------------------------------------------------------------------------------------
// Checks to see which view, or views, the point is in and then sets the center of each moved view to the new postion.
// If views are directly on top of each other, they move together.
-(void)dispatchTouchMoveEvent:(UIView *)theView toPosition:(CGPoint)position
{
	if (bTouchBoussole) {
		//NSLog(@"Phase: Touches moved");
		float angleResult = CalculeAngle(position,angleDepartTouch);
        //		NSLog(@"angleActuelAbsolu :%0.0f",angleActuelAbsolu);
        [self updateBoussoleAngle:angleResult];
        
        angleResult = 360-angleResult;
        [self updateDisplayAngle:angleResult];

	} // Fin du if (bTouchBoussole) {
} // Fin du -(void)dispatchTouchMoveEvent:(UIView *)theView toPosition:(CGPoint)position


//-------------------------------------------------------------------------------------------------------------------------------
// Handles the end of a touch event.
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (bTouchBoussole) {
		//touchPhaseText.text = @"Phase: Touches ended";
		//NSLog(@"--------------");
		for (UITouch *touch in touches) {
			// Send to the dispatch method, which will make sure the appropriate subview is acted upon
			[self dispatchTouchEndEvent:[touch view] toPosition:[touch locationInView:self]];
		}
		bTouchBoussole = NO;
        //		NSLog(@"<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<END");
        
	} // Fin de if (bTouchBoussole) {
} // Fin du -(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event




//-------------------------------------------------------------------------------------------------------------------------------
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (bTouchBoussole) {
		//NSLog(@"Phase: Touches cancelled");
		//NSLog(touchPhaseText.text);
		for (UITouch *touch in touches) {
			// Send to the dispatch method, which will make sure the appropriate subview is acted upon
			[self dispatchTouchEndEvent:[touch view] toPosition:[touch locationInView:self]];
		}
		bTouchBoussole = NO;
        //		NSLog(@"<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<END");
        
	} // Fin de if (bTouchBoussole) {
} // Fin du -(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event


//-------------------------------------------------------------------------------------------------------------------------------
// Checks to see which view, or views, the point is in and then sets the center of each moved view to the new postion.
// If views are directly on top of each other, they move together.
-(void)dispatchTouchEndEvent:(UIView *)theView toPosition:(CGPoint)position
{
	if (bTouchBoussole) {
		//NSLog(@"Phase: Touches END !!!");
		float angleResult = CalculeAngle(position,angleDepartTouch);
        angleActuelAbsolu = angleResult;
		angleActuelAbsolu = FctModulo360(angleActuelAbsolu);
//        [self updateDisplayAngle:angleResult];  IMPORTANT - Mauvais affichage et je comprends pas pourquoi. A corrgier un jour car décalage 1° entre aff et resultat simul
 		return;		
	} // Fin du 	if (bTouchBoussole) {

} // Fin du -(void)dispatchTouchEndEvent:(UIView *)theView toPosition:(CGPoint)position

//#########################################################################################################################################################
//#########################################################################################################################################################
#pragma mark -
#pragma mark ===  Gestion des Update (aussi appelé par Boussole 3GS ou 4G ...) ===
#pragma mark -


//-------------------------------------------------------------------------------------------------------------------------------
- (void)updateDisplayAngle:(float)angle {
    

//    if (!self.viewController.bBoussoleAutom) angle = round(360-angle);
    angleAff = angle; // Stockage pour pouvoir ressortir cette valeur en fin "d'action boussole"
    
    NSString *newAngleString = [NSString stringWithFormat:@"%0.0f", angle];
    NSString *angleStringWithDegree = [newAngleString stringByAppendingString:@"º"];
    degreeDisplayView.text = angleStringWithDegree;
    [degreeDisplayView setNeedsDisplay];
} // Fin du - (void)updateDisplayAngle:(float)angle {


//-------------------------------------------------------------------------------------------------------------------------------
- (void)updateBoussoleAngle:(float)angle {
    [UIView beginAnimations:@"rotate_blipView" context:nil];
    [UIView setAnimationDuration:0];	
    [UIView setAnimationDelegate:self];
    [UIView setAnimationRepeatCount:0];
    boussoleView.transform = CGAffineTransformMakeRotation(DegreesToRadians2(angle));
    [UIView commitAnimations];
} // Fin du - (void)updateBoussoleAngle:(float)angle {

//-------------------------------------------------------------------------------------------------------------------------------
- (int)LectureAngleBoussoleAff {
    return (int)angleAff;
} // Fin du - (int)LectureAngleBoussoleAff {


@end
