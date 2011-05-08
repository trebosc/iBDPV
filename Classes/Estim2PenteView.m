//
// Estim2PenteView.m
//  iBDPV
// JMD & DTR


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
} // Fin du - (id)initWithFrame:(CGRect)frame viewController:(Estim2PenteViewController *)aController {


//-------------------------------------------------------------------------------------------------------------------------------
- (void)setupSubviewsWithContentFrame:(CGRect)frameRect {
    NSString *sTexteOui = NSLocalizedString(@"Yes","");
    NSString *sTexteNon = NSLocalizedString(@"No","");

    // L''image de la maison (en fond)
    UIImageView * photographieMaisonView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"explication_pente_accelerometre.png"]];
    photographieMaisonView.center = self.center;
    photographieMaisonView.opaque = YES;
    CGRect frame = photographieMaisonView.frame;
    frame.origin.x = 42.0;
    frame.origin.y = 20.0;
    photographieMaisonView.frame = frame;
    [self addSubview:photographieMaisonView];
    [photographieMaisonView release];

    // Texte d'explication
    UILabel	*lblFace=[[UILabel alloc] initWithFrame:CGRectMake(0.0, 220.0, 320, 20)];
	lblFace.text= NSLocalizedString(@"Do you see your roof side","");
    lblFace.textAlignment = UITextAlignmentCenter;
    [self addSubview:lblFace];
    [lblFace release];

    // Texte d'explication
    lblFace=[[UILabel alloc] initWithFrame:CGRectMake(0.0, 240.0, 320, 20)];
	lblFace.text=NSLocalizedString(@"like on the picture ?","");
    lblFace.textAlignment = UITextAlignmentCenter;
    [self addSubview:lblFace];
    [lblFace release];
    
    NSArray *itemArray = [NSArray arrayWithObjects: sTexteOui, sTexteNon, nil];
    choixVisible = [[UISegmentedControl alloc] initWithItems:itemArray];
    choixVisible.frame = CGRectMake(80, 275, 160, 40);
    choixVisible.segmentedControlStyle = UISegmentedControlStylePlain;
    choixVisible.selectedSegmentIndex = 0; // Choix "Oui"
    [choixVisible addTarget:self action:@selector(pickOne:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:choixVisible];
    [choixVisible release];
    
    //----------------------------------------
    [self setNeedsDisplay];
} // Fin du - (void)setupSubviewsWithContentFrame:(CGRect)frameRect {



//-------------------------------------------------------------------------------------------------------------------------------
//Action method executes when user touches the button
- (void) pickOne:(id)sender{
	UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    //NSLog(@"Choix de l'utilisateur : %d",[segmentedControl selectedSegmentIndex]);
    if ([segmentedControl selectedSegmentIndex] == 0)
            self.viewController.bPenteVisible = true;
        else
            self.viewController.bPenteVisible = false;
} // Fin du - (void) pickOne:(id)sender{



//#########################################################################################################################################################
//#########################################################################################################################################################
#pragma mark -
#pragma mark === Fin de vie de la classe ===
#pragma mark -


//-------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
} // Fin du - (void)dealloc {


@end
