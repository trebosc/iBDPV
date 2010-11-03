/*
 
 File: Estim2PenteView.m
 Abstract: Estim2PenteView builds and displays the primary user interface of the Bubble
 Level application.
 
 Version: 1.8
 
 
 */

#import "Estim2PenteView.h"
#import "Estim2PenteViewController.h"


@interface Estim2PenteView (PrivateMethods)
- (void)setupSubviewsWithContentFrame:(CGRect)frameRect;
@end


@implementation Estim2PenteView

@synthesize viewController;

//#########################################################################################################################################################
//#########################################################################################################################################################
#pragma mark -
#pragma mark === Init et affichage ===
#pragma mark -

//-------------------------------------------------------------------------------------------------------------------------------
- (id)initWithFrame:(CGRect)frame viewController:(Estim2PenteViewController *)aController {
    self = [super initWithFrame:frame];
    if (self != nil) {
        self.viewController = aController;
        
		[self setupSubviewsWithContentFrame:frame];
    }
    
    aController.bPenteVisible = true;
    
    return self;
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void)setupSubviewsWithContentFrame:(CGRect)frameRect {
    UIImageView * photographieMaisonView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"explication_pente_accelerometre.png"]];
    photographieMaisonView.center = self.center;
    photographieMaisonView.opaque = YES;
    CGRect frame = photographieMaisonView.frame;
    frame.origin.x = 42.0;
    frame.origin.y = 20.0;
    photographieMaisonView.frame = frame;
  	
    // add view in proper order and location
    [self addSubview:photographieMaisonView];

    [photographieMaisonView release];

    // Texte d'explication
    UILabel	*lblFace=[[UILabel alloc] initWithFrame:CGRectMake(0.0, 220.0, 320, 20)];
	lblFace.text=@"Voyez-vous le côté de votre toiture";
    lblFace.textAlignment = UITextAlignmentCenter;
    [self addSubview:lblFace];
    [lblFace release];

    // Texte d'explication
    lblFace=[[UILabel alloc] initWithFrame:CGRectMake(0.0, 240.0, 320, 20)];
	lblFace.text=@"comme sur cette photographie ?";
    lblFace.textAlignment = UITextAlignmentCenter;
    [self addSubview:lblFace];
    [lblFace release];
    
    NSArray *itemArray = [NSArray arrayWithObjects: @"Oui", @"Non", nil];
    choixVisible = [[UISegmentedControl alloc] initWithItems:itemArray];

    choixVisible.frame = CGRectMake(80, 275, 160, 40);
    choixVisible.segmentedControlStyle = UISegmentedControlStylePlain;
    choixVisible.selectedSegmentIndex = 0; // Choix "Oui"

    [choixVisible addTarget:self
                         action:@selector(pickOne:)
               forControlEvents:UIControlEventValueChanged];

    [self addSubview:choixVisible];
    [choixVisible release];
    NSLog(@"TODO - Faire un release après tous les addSubView !");

    
    //----------------------------------------
    [self setNeedsDisplay];
}


//-------------------------------------------------------------------------------------------------------------------------------
//Action method executes when user touches the button
- (void) pickOne:(id)sender{
	UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    //NSLog(@"Choix de l'utilisateur : %d",[segmentedControl selectedSegmentIndex]);
    if ([segmentedControl selectedSegmentIndex] == 0)
            self.viewController.bPenteVisible = true;
        else
            self.viewController.bPenteVisible = false;
} 


//#########################################################################################################################################################
//#########################################################################################################################################################
#pragma mark -
#pragma mark === Fin de vie de la classe ===
#pragma mark -


//-------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}


@end
