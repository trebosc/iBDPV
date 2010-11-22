
  // 
 // Estim2PenteView.m
 //  iBDPV
 // JMD & DTR


#import "math.h"

#import "Estim2aPenteAutoView.h"
#import <QuartzCore/QuartzCore.h>

#define kMaxAngle 90.0

CGFloat DegreesToRadians3(CGFloat degrees) {return degrees * M_PI / 180;};
CGFloat RadiansToDegrees3(CGFloat radians) {return radians * 180/M_PI;};
CGFloat DegreesToPourcent3(CGFloat degrees) {return tan(DegreesToRadians3(degrees))*100;;};


@interface Estim2aPenteAutoView (PrivateMethods)
- (void)setupSubviewsWithContentFrame:(CGRect)frameRect;
@end


@implementation Estim2aPenteAutoView

@synthesize viewController;

//#########################################################################################################################################################
//#########################################################################################################################################################
#pragma mark -
#pragma mark === Init et affichage ===
#pragma mark -

//-------------------------------------------------------------------------------------------------------------------------------
- (id)initWithFrame:(CGRect)frame viewController:(Estim2aPenteAutoViewController *)aController {
    self = [super initWithFrame:frame];
    if (self != nil) {
        self.viewController = aController;
        
		[self setupSubviewsWithContentFrame:frame];
    }
    return self;
} // Fin du - (id)initWithFrame:(CGRect)frame viewController:(Estim2aPenteAutoViewController *)aController {


//-------------------------------------------------------------------------------------------------------------------------------
- (void)setupSubviewsWithContentFrame:(CGRect)frameRect {
    levelFrontDroiteView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"penteBackgroundDroite.png"]];
    levelFrontDroiteView.center = self.center;
    levelFrontDroiteView.opaque = YES;
    
    levelFrontGaucheView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"penteBackgroundGauche.png"]];
    levelFrontGaucheView.center = self.center;
    levelFrontGaucheView.opaque = YES;
        
	
	//-----------------------------
    //  darkTextColor:YES];
	
    // set up shadow degree display, to give displayed text more punch
    // this is an identical text display, but in white and offset 2 pixels
    float displayTextWidth = 180.0;
    float displayTextHeight = 50.0;
    float displayShiftRight = 120.0;
    float displayShiftDown = 374.0;
    UIFont *displayFont = [UIFont fontWithName:@"Helvetica" size:50];
    shadowDegreeDisplayView = [[UILabel alloc] initWithFrame:CGRectMake(displayShiftRight-2.0, displayShiftDown, displayTextWidth, displayTextHeight)];
    shadowDegreeDisplayView.font = displayFont;
    shadowDegreeDisplayView.textColor = [UIColor whiteColor];
    shadowDegreeDisplayView.backgroundColor = [UIColor clearColor];
    shadowDegreeDisplayView.textAlignment = UITextAlignmentCenter;
    
    // set up degree display
    degreeDisplayView = [[UILabel alloc] initWithFrame:CGRectMake(displayShiftRight, displayShiftDown, displayTextWidth, displayTextHeight)];
    degreeDisplayView.font = displayFont;
    degreeDisplayView.textColor = [UIColor colorWithRed:66.0/255.0 green:73.0/255.0 blue:113.0/255.0 alpha:1.0];
    degreeDisplayView.backgroundColor = [UIColor clearColor];
    degreeDisplayView.textAlignment = UITextAlignmentCenter;
    
    // set up pourcent display
    pourcentDisplayView = [[UILabel alloc] initWithFrame:CGRectMake(displayShiftRight, displayShiftDown-100.0, displayTextWidth, displayTextHeight)];
    pourcentDisplayView.font = displayFont;
    pourcentDisplayView.textColor = [UIColor colorWithRed:70.0/255.0 green:73.0/255.0 blue:113.0/255.0 alpha:1.0];
    pourcentDisplayView.backgroundColor = [UIColor clearColor];
    pourcentDisplayView.textAlignment = UITextAlignmentCenter;
    
	shadowPourcentDisplayView = [[UILabel alloc] initWithFrame:CGRectMake(displayShiftRight-2.0, displayShiftDown-100.0, displayTextWidth, displayTextHeight)];
    shadowPourcentDisplayView.font = displayFont;
    shadowPourcentDisplayView.textColor = [UIColor whiteColor];
    shadowPourcentDisplayView.backgroundColor = [UIColor clearColor];
    shadowPourcentDisplayView.textAlignment = UITextAlignmentCenter;
    
    
    #define kStdButtonWidth		106.0
    #define kStdButtonHeight	40.0
    #define okShiftRight        240.0
    #define okShiftDown         45.0

    
    //----------------------------
    // set up OK  button

	UIImage *buttonOkImage = [UIImage imageNamed:@"blueButton.png"];
	UIButton *okButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	okButton.backgroundColor = [UIColor clearColor];
    okButton.frame = CGRectMake(okShiftRight, okShiftDown, kStdButtonWidth, kStdButtonHeight);
	[okButton setTitle:@"Ok" forState:UIControlStateNormal];	
	[okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];	
	[okButton setBackgroundImage:[buttonOkImage stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0] forState:UIControlStateNormal];
	
	[okButton addTarget:self.viewController action:@selector(actValidate:) forControlEvents:UIControlEventTouchUpInside];

    //----------------------------
    // set up Retour button
    float retourShiftRight = 240.0;
    float retourShiftDown = 390.0;
    
	
	UIImage *buttonRetourImage = [UIImage imageNamed:@"whiteButton.png"];
	UIButton *retourButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	retourButton.backgroundColor = [UIColor clearColor];
    retourButton.frame = CGRectMake(retourShiftRight, retourShiftDown, kStdButtonWidth, kStdButtonHeight);
	[retourButton setTitle:@"Retour" forState:UIControlStateNormal];	
	[retourButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];	
	[retourButton setBackgroundImage:[buttonRetourImage stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0] forState:UIControlStateNormal];
	
	
	[retourButton addTarget:self.viewController action:@selector(actBack:) forControlEvents:UIControlEventTouchUpInside];
	
	
	// Transform for rotating textual display
	CATransform3D landscapeTransform = CATransform3DIdentity;
    landscapeTransform = CATransform3DRotate(landscapeTransform, DegreesToRadians3(-90), 0, 0, 1);

    degreeDisplayView.layer.transform = landscapeTransform;
    pourcentDisplayView.layer.transform = landscapeTransform;
    shadowDegreeDisplayView.layer.transform = landscapeTransform;
    shadowPourcentDisplayView.layer.transform = landscapeTransform;
    okButton.layer.transform = landscapeTransform;
    retourButton.layer.transform = landscapeTransform;
 	
    // add view in proper order and location
    [self addSubview:levelFrontDroiteView];
    [self addSubview:levelFrontGaucheView];
    [self addSubview:shadowDegreeDisplayView];
    [self addSubview:shadowPourcentDisplayView];
    [self addSubview:degreeDisplayView];
    [self addSubview:pourcentDisplayView];
    [self addSubview:okButton];
    [self addSubview:retourButton];

    //NSLog(@"TODO - okButton et retourButton ne sont jamais release. Ils sont crées en retain. Faut release ou pas ????");

    
    [self setNeedsDisplay];
} // Fin du - (void)setupSubviewsWithContentFrame:(CGRect)frameRect {


//#########################################################################################################################################################
//#########################################################################################################################################################
#pragma mark -
#pragma mark === Fin de vie de la classe ===
#pragma mark -

//-------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
	[levelFrontDroiteView release];
	[levelFrontGaucheView release];
    [shadowDegreeDisplayView release];
    [shadowPourcentDisplayView release];
    [degreeDisplayView release];
    [pourcentDisplayView release];
    [super dealloc];
} // Fin du - (void)dealloc {



//#########################################################################################################################################################
//#########################################################################################################################################################
#pragma mark -
#pragma mark === Gestion des mise à jour des angles ===
#pragma mark -

//-------------------------------------------------------------------------------------------------------------------------------
// Change la photo du fond (maison) suivant si l'iphone est inclinée vers la gauche ou vers la droite
- (void)updateArrowsForAngle:(float)angle {
    if (angle < 0.0) {
		levelFrontDroiteView.hidden = YES;
		levelFrontGaucheView.hidden = NO;
		
    } else if (angle > 0.0) {
		levelFrontDroiteView.hidden = NO;
		levelFrontGaucheView.hidden = YES;
    } else {  // turn off the arrows if we're level
		levelFrontDroiteView.hidden = NO;
		levelFrontGaucheView.hidden = YES;
    }
} // Fin du - (void)updateArrowsForAngle:(float)angle {



//-------------------------------------------------------------------------------------------------------------------------------
// Met à jour l'affichage texte de l'écran
- (void)updateReadoutForAngle:(float)angle {
    
    // On prend la valeur absolu car l'angle est toujorus positif sous BDPV.
    angle = abs(angle);
    
	CGFloat anglePourcent = DegreesToPourcent3(angle);
	if ( (angle >= 90) || (anglePourcent > 100))  anglePourcent = 100;
    NSString *newAngleString = [NSString stringWithFormat:@"%0.0f", angle];
    NSString *newAnglePourcentString = [NSString stringWithFormat:@"%0.0f", anglePourcent];
    NSString *angleStringWithDegree = [newAngleString stringByAppendingString:@"º"];
    NSString *angleStringWithPourcent = [newAnglePourcentString stringByAppendingString:@"%"];
    shadowDegreeDisplayView.text = angleStringWithDegree;
    degreeDisplayView.text = angleStringWithDegree;
    pourcentDisplayView.text = angleStringWithPourcent;
    shadowPourcentDisplayView.text = angleStringWithPourcent;
    [degreeDisplayView setNeedsDisplay];
    [pourcentDisplayView setNeedsDisplay];
    [shadowDegreeDisplayView setNeedsDisplay];
    [shadowPourcentDisplayView setNeedsDisplay];
} // Fin du - (void)updateReadoutForAngle:(float)angle {


//-------------------------------------------------------------------------------------------------------------------------------
// L'angle de l'iphone a changé - Appel de cette fonction
- (void)updateToInclinationInRadians:(float)rads {
    
    // L'angle de l'accéléromètre étant en radians, on converti en degré
    float rotation = -RadiansToDegrees3(rads);
    // On limite les angles accepté
    if (rotation > kMaxAngle) rotation = kMaxAngle;
    if (rotation < -kMaxAngle) rotation = -kMaxAngle;
    
    Pente = abs(rotation);
    
	[self updateReadoutForAngle:rotation];
	[self updateArrowsForAngle:rotation];    
} // Fin du - (void)updateToInclinationInRadians:(float)rads {

//-------------------------------------------------------------------------------------------------------------------------------
// Pour récupérer l'angle de la pente
- (int)LectureAngleDegre {
    return Pente; 
} // Fin du - (int)LectureAngleDegre: {


@end
