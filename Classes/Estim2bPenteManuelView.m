//
// Estim2PenteView.m
//  iBDPV
// JMD & DTR


#import "Estim2bPenteManuelView.h"
#import "Estim2bPenteManuelViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "math.h"


@interface Estim2bPenteManuelView (PrivateMethods)
- (void)setupSubviewsWithContentFrame:(CGRect)frameRect;
@end

CGFloat DegreesToRadians5(CGFloat degrees) {return degrees * M_PI / 180;};
CGFloat RadiansToDegrees5(CGFloat radians) {return radians * 180/M_PI;};
CGFloat DegreesToPourcent5(CGFloat degrees) {return tan(DegreesToRadians5(degrees))*100;};


const float X1=74.0;
const float Y1=182.0;
const float LONGUEUR=90.0;
const float RAYON= 10.0;
const float ANGLE=45.0;



@implementation Estim2bPenteManuelView

@synthesize viewController;

//#########################################################################################################################################################
//#########################################################################################################################################################
#pragma mark -
#pragma mark === Init et affichage ===
#pragma mark -

//-------------------------------------------------------------------------------------------------------------------------------
- (id)initWithFrame:(CGRect)frame viewController:(Estim2bPenteManuelViewController *)aController {
    self = [super initWithFrame:frame];
    if (self != nil) {
        self.viewController = aController;
        angleToit=45.0; // la pente initiale est à 45°

		[self setupSubviewsWithContentFrame:frame];
    } // Fin du     if (self != nil) {

    return self;
} // Fin  du - (id)initWithFrame:(CGRect)frame viewController:(Estim2bPenteManuelViewController *)aController {


//-------------------------------------------------------------------------------------------------------------------------------
- (void)setupSubviewsWithContentFrame:(CGRect)frameRect {
    UILabel	*lblFace;
    lblFace=[[UILabel alloc] initWithFrame:CGRectMake(0.0, 00.0, 320, 20)];
	lblFace.text=@"Indiquez l'angle de votre toit";
    lblFace.textAlignment = UITextAlignmentCenter;
    lblFace.textColor = [UIColor whiteColor];
    lblFace.backgroundColor = [UIColor blackColor];
    [self addSubview:lblFace];
    [lblFace release];
    
    lblFace=[[UILabel alloc] initWithFrame:CGRectMake(0.0, 20.0, 320, 20)];
	lblFace.text=@"avec le point rouge ou la glissière.";
    lblFace.textAlignment = UITextAlignmentCenter;
    lblFace.textColor = [UIColor whiteColor];
    lblFace.backgroundColor = [UIColor blackColor];
    [self addSubview:lblFace];
    [lblFace release];

 
    lblFace=[[UILabel alloc] initWithFrame:CGRectMake(15.0, 330.0, 60, 20)];
	lblFace.text=@"angle :";
    lblFace.textColor = [UIColor whiteColor];
    lblFace.backgroundColor = [UIColor blackColor];
    lblFace.textAlignment = UITextAlignmentCenter;
    [self addSubview:lblFace];
    [lblFace release];
    
    //----------------------------------------
    degreeDisplayView = [[UILabel alloc] initWithFrame:CGRectMake(80, 292, 55, 26)];
    degreeDisplayView.text = @"45°";
    degreeDisplayView.textAlignment = UITextAlignmentRight;
    degreeDisplayView.textColor = [UIColor whiteColor];
    degreeDisplayView.backgroundColor = [UIColor blackColor];
    [self addSubview:degreeDisplayView];
    
    pourcentDisplayView = [[UILabel alloc] initWithFrame:CGRectMake(200, 292, 55, 26)];
    pourcentDisplayView.text = @"100%";
    pourcentDisplayView.textAlignment = UITextAlignmentRight;
    pourcentDisplayView.textColor = [UIColor whiteColor];
    pourcentDisplayView.backgroundColor = [UIColor blackColor];
    [self addSubview:pourcentDisplayView];

    
    //----------------------------------------------
    CGRect frame = CGRectMake(80.0, 330.0, 220.0, 10.0);
    UISlider *slider = [[UISlider alloc] initWithFrame:frame];
    [slider addTarget:self.viewController action:@selector(fixeAngleToit:) forControlEvents:UIControlEventValueChanged];
    [slider setBackgroundColor:[UIColor clearColor]];
    slider.minimumValue = 0.0;
    slider.maximumValue = 90.0;
    slider.continuous = YES;
    slider.value = 45.0;
    [self addSubview:slider];

    self.viewController.slider = slider;
    NSLog(@"TODO - On doit faire un release sur e slider ou pas ??   JE DIRAIS OUI car AddSubView mais comme il est passé à self.viwcontroller :( ");

    
    //---------------------------------
    UIImageView * photographieMaisonView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fond_pente_manuel.png"]];
    photographieMaisonView.center = self.center;
    photographieMaisonView.opaque = YES;
    frame = photographieMaisonView.frame;
    frame.origin.x = 20.0;
    frame.origin.y = 50.0;
    photographieMaisonView.frame = frame;
    [self addSubview:photographieMaisonView];
    [photographieMaisonView release];
 
    
    [self setNeedsDisplay];
    
} // Fin de - (void)setupSubviewsWithContentFrame:(CGRect)frameRect {


//#########################################################################################################################################################
//#########################################################################################################################################################
#pragma mark Gestion du changement d'angle du toit

//-----------------------------------------------------------------------------------------------------------------
-(void)setAngleToit:(CGFloat)phase // appelé quand on affecte une valeur à angleToit
{
	
	if(phase != angleToit)
	{
		if ( (phase<=90.0) || (isnan(phase)) ) {
			if (phase>=0.0) {
				angleToit = phase;
			} else { // Avec le if (phase>=0.0) {
				angleToit = 0.0;
			} // Fin du if (phase>=0.0) {
			
		} else { // Avec le if (phase<=90.0) {
			//Limitation à 90° pour ne pas sortir de la vue
			angleToit=90.0;
		} // Fin du if (phase<=90.0) {
        
        CGFloat anglePourcent = DegreesToPourcent5(angleToit);
        if ( (angleToit >= 90) || (anglePourcent > 100))  anglePourcent = 100;

        NSString *newAngleString = [NSString stringWithFormat:@"%0.0f", angleToit];
        NSString *newAnglePourcentString = [NSString stringWithFormat:@"%0.0f", anglePourcent];
        NSString *angleStringWithDegree = [newAngleString stringByAppendingString:@"º"];
        NSString *angleStringWithPourcent = [newAnglePourcentString stringByAppendingString:@"%"];
        degreeDisplayView.text = angleStringWithDegree;
        pourcentDisplayView.text = angleStringWithPourcent;

		
		[self setNeedsDisplay];
	} //Fin du if(phase != angleToit)
    
} // Fin du -(void)setAngleToit:(CGFloat)phase // appelé quand on affecte une valeur à angleToit

//-----------------------------------------------------------------------------------------------------------------
-(int)LectureAngleToit
{
    return angleToit; 
} // Fin du -(int)LectureAngleToit


//-----------------------------------------------------------------------------------------------------------------
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

 - (void)drawRect:(CGRect)rect {
	//NSLog(@"drawRect");
	
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
	
    // Fond blanc
	[[UIColor colorWithRed:212/255.0 green:225/255.0 blue:249/255.0 alpha:1] set];
	//UIRectFill([self bounds]);
	
     UIRectFill(CGRectMake(72,57,160,125));
     
	
	// Draw a horizontal line, vertical line, rectangle and circle for comparison
	float debutLigneToitX = X1;
	float debutLigneToitY = Y1;
	float longueurLigneToit = LONGUEUR;
	float rayonRondBout = RAYON;
	float rotationValue = angleToit;
	

     // Drawing lines with a white stroke color
     CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);

     
     //----------------------------------------------------------------
	// On fait la rotation correspondant à l'angle demandé par l'utilisateur
	CGContextTranslateCTM(context, debutLigneToitX, debutLigneToitY);
	CGContextRotateCTM (context, DegreesToRadians5(-rotationValue));
	CGContextTranslateCTM(context, -debutLigneToitX, -debutLigneToitY);
	
	//on trace le "toit"
	CGContextMoveToPoint(context, debutLigneToitX, debutLigneToitY);
	CGContextAddLineToPoint(context, debutLigneToitX+longueurLigneToit, debutLigneToitY);
	
	// On fixe l'épaisseur et on trace le "path"
	CGContextSetLineWidth(context, 2.0);
	CGContextStrokePath(context);
	
    // on rajoute un point en fin de ligne (pour poouvoir l'accrocher avec le doigt)
   CGContextSetFillColorWithColor(context, [[UIColor redColor] CGColor]);
	CGContextFillEllipseInRect(context, CGRectMake(debutLigneToitX+longueurLigneToit-rayonRondBout, debutLigneToitY-rayonRondBout, rayonRondBout*2, rayonRondBout*2));
	
	// And width 2.0 so they are a bit more visible
	CGContextSetLineWidth(context, 2.0);
     
     // On écrit réellement le "chemin" (donc on dessine).
	CGContextStrokePath(context);
    
} // Fin du - (void)drawRect:(CGRect)rect {

//#########################################################################################################################################################
//#########################################################################################################################################################
#pragma mark Gestion des Touch Event

//-----------------------------------------------------------------------------------------------------------------
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	// Draw a horizontal line, vertical line, rectangle and circle for comparison
	float debutLigneToitX = X1;
	float debutLigneToitY = Y1;
	float longueurLigneToit = LONGUEUR;
	float rayonRondBout = RAYON;
	
	for (UITouch *touch in touches) {
		// Send to the dispatch method, which will make sure the appropriate subview is acted upon
		//QuartzDashView *ldv = (QuartzDashView*)[touch view];
		
		CGPoint positionDoigt = [touch locationInView:self];
		
		//NSString *newAngleString = [NSString stringWithFormat:@"X:%0.0f Y:%0.0f", positionDoigt.x,positionDoigt.y];
		//NSLog(newAngleString);
		float xPosBoutLigne = debutLigneToitX+(longueurLigneToit)*cos(DegreesToRadians5(angleToit));
		float yPosBoutLigne = debutLigneToitY-(longueurLigneToit)*sin(DegreesToRadians5(angleToit));
		
		//NSString *newAngleString2 = [NSString stringWithFormat:@"X:%0.0f Y:%0.0f", xPosBoutLigne,yPosBoutLigne];
		//NSLog(newAngleString2);
		
		if ( 	( (xPosBoutLigne-rayonRondBout*2) < positionDoigt.x)
			& ( (xPosBoutLigne+rayonRondBout*2) > positionDoigt.x)
			& ( (yPosBoutLigne-rayonRondBout*2) < positionDoigt.y)
			& ( (yPosBoutLigne+rayonRondBout*2) > positionDoigt.y)
			)
		{
			//NSLog(@"Sur Bout ligne");
			bTrackTouche = YES;
		} else { // Avec le if ( 	( (xPosBoutLigne-
			//NSLog(@"Hors ligne");
		} // Fin du if ( 	( (xPosBoutLigne-
		
	} // Fin du for (UITouch *touch in touches) {
	
	
} //Fin du -(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {


//-----------------------------------------------------------------------------------------------------------------
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	for (UITouch *touch in touches) {
		// Send to the dispatch method, which will make sure the appropriate subview is acted upon
		
		CGPoint position=[touch locationInView:self];
		
		
		if (bTrackTouche == YES) {
			//NSLog(@"X= %d Y= %d",position.x,position.y);
			
			float debutLigneToitX = X1;
			float longueurLigneToit = LONGUEUR;
			
			//float oi = cos(DegreesToRadians(ldv.angleToit));
			//float ao = RadiansToDegrees(acos(oi));
			float oi = (position.x-debutLigneToitX)/longueurLigneToit;
			
			//float yPosBoutLigne = debutLigneToitY-(longueurLigneToit)*sin(DegreesToRadians(ldv.angleToit));
			//angleToit = RadiansToDegrees(acos(oi));	
			[self setAngleToit:	RadiansToDegrees5(acos(oi))];
			
			//Mise à jour du slider
			[self.viewController angleToitModifie:angleToit];
			
			//NSLog(@"Nouvel angle: %f",angleToit);
		} // Fin du if (bTrackTouche == YES) {
        
	} // Fin du for (UITouch *touch in touches) {
	
} // Fin du -(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {


//-----------------------------------------------------------------------------------------------------------------
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //NSLog(@"touchesEnded");
	bTrackTouche = NO;
} //Fin du -(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {


//-----------------------------------------------------------------------------------------------------------------
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    //NSLog(@"touchesCancelled");
	bTrackTouche = NO;
	
} // Fin du -(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {




//#########################################################################################################################################################
//#########################################################################################################################################################
#pragma mark -
#pragma mark === Fin de vie de la classe ===
#pragma mark -


//-------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [degreeDisplayView release];
    [pourcentDisplayView release];
    [super dealloc];
} // Fin du - (void)dealloc {


@end
