    //
//  Estim3OrientViewController.m
//  iBDPV
//
//  Created by jmd on 01/08/10.
//  Copyright 2010 __MaCoDa__. All rights reserved.
//

#import "Estim3OrientViewController.h"
#import "Estim4ResultViewController.h"

#import "Estim3OrientView.h"


@implementation Estim3OrientViewController

@synthesize locationManager;
@synthesize bBoussoleAutom;


#pragma mark -
#pragma mark === Initialisation diverses ===
#pragma mark -

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


- init {
	if (self = [super init]) {
        
        // setup the location manager
        self.locationManager = [[[CLLocationManager alloc] init] autorelease];

        // check if the hardware has a compass
        NSLog(@"Aie .... fonction Deprecated ... mais cela marche quand même");
        if (locationManager.headingAvailable == NO) {
            // No compass is available. This application cannot function without a compass, 
            // so a dialog will be displayed and no magnetic data will be measured.
            self.locationManager = nil;
            UIAlertView *noCompassAlert = [[UIAlertView alloc] initWithTitle:@"Pas de boussole!" message:@"Pas de boussole disponible." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [noCompassAlert show];
            [noCompassAlert release];
            bBoussoleAutom = false;
            NSLog(@"ViewControlle : Pas de boussolle");
        } else { // Avec le if (locationManager.headingAvailable == NO) {
            bBoussoleAutom = true;
            NSLog(@"ViewControlle : boussolle OK");
            
            // heading service configuration
            locationManager.headingFilter = kCLHeadingFilterNone;
            
            // setup delegate callbacks
            locationManager.delegate = self;
            
        } // Fin du if (locationManager.headingAvailable == NO) {
        
	} // Fin du if (self = [super init]) {

    NSLog(@"PB - Ce code ne semble pas être exécuté à chaque chargement.");
    NSLog (@"Mais attention, comme multiThread, Estim3OrientView est chargé AVANT le loadView ... Ou mettre code Boussole ???");

    NSLog(@"Revoir tout le code pour mettre des commentaires");
    NSLog(@"Revoir tout le code pour mettre des //Fin du ... ");
    NSLog(@"Mettre des pragma Mark et organiser le code dans les .m  ");

	return self;
} // Fin du Init



#pragma mark -
#pragma mark === Chargement des vues ou affichage  ===
#pragma mark -


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {

	// Affichage de la barre de navigation
	[self.navigationController setNavigationBarHidden:NO];
	
	//Titre
	self.title=@"Etape 3 - Orientation";
	
	//Désactivation du bouton Back
	[self.navigationItem setHidesBackButton:YES];

	//Affichage de la toolBar du Navigation Controller
	[self.navigationController setToolbarHidden:NO animated:YES];
	
	//Création des boutons
	//Retour
	UIBarButtonItem *btnBackItem=[[UIBarButtonItem alloc]initWithTitle:@"Retour" style:UIBarButtonItemStyleBordered target:self action:@selector(actBack:)];
	//Espacement
	UIBarButtonItem *flexibleSpaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	//Valider
	UIBarButtonItem *btnValidateItem=[[UIBarButtonItem alloc] initWithTitle:@"Valider" style:UIBarButtonItemStyleDone target:self action:@selector(actValidate:)];
	
	// Ajout des boutons dans la toolBar
	self.toolbarItems=[NSArray arrayWithObjects:btnBackItem,flexibleSpaceButtonItem,btnValidateItem,nil];

	[btnBackItem release];
	[flexibleSpaceButtonItem release];
	
} // Fin du - (void)loadView {


// Implement viewWillAppear 
- (void)viewWillAppear:(BOOL)animated {
    // On relance la boussole si nécessaire.
    if (bBoussoleAutom) {
        locationManager.delegate = self;
        // start the compass
        [locationManager startUpdatingHeading];
    } // Fin duif (bBoussoleAutom) { 
    NSLog(@"Vérifier que l'on appele les 'super' dans toutes les fonctions dérivées");
    [super viewWillAppear:animated];
} // Fin du - (void)viewWillAppear:(BOOL)animated {



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    //[super viewDidLoad];
	
	NSLog(@"viewDidLoad: Estim3OrientViewController");
    
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];

	
	// Création par programme de la hiérarchie de vues (p34) 
	self.wantsFullScreenLayout=YES;
	
	// 1. Création de la vue racine du controlleur de la taille de l'écran
	UIView *rootView=[[UIView alloc] initWithFrame:applicationFrame];
	rootView.backgroundColor=[UIColor blackColor];
    rootView.opaque=YES;
	
	
    //***********************************
    //On rajoute une vue qui va afficher tout ce qui concerne l'orientation
   estim3OrientView = [[Estim3OrientView alloc] initWithFrame:applicationFrame viewController:self];
   [rootView addSubview:estim3OrientView];

	
	// 3. Assignation de la vue racine à la propriété view du controlleur
	self.view=rootView;
	
	// 4. Libération de la vue racine
	[rootView release];
	
    [super viewDidLoad];
	NSLog(@"viewDidLoad: appel su  super parce que .... pas fait dans code Doudou ?");

	
} // Fin du  - (void)viewDidLoad {




#pragma mark -
#pragma mark === Fin de vie ou d'affichage ===
#pragma mark -

//--------------------------------------------------
// Implement viewWillDisappear 
- (void)viewWillDisappear:(BOOL)animated {
    // Stop the compass
    if (bBoussoleAutom) {
        [locationManager stopUpdatingHeading];
     } // Fin du if (bBoussoleAutom) {
    NSLog(@"viewWillDisappear: Arrêt de la boussole");
    NSLog(@"PS : Virer les NSLOG car ils apparaissent dans la console de xCode");
} // Fin du - (void)viewWillDisappear:(BOOL)animated {


//--------------------------------------------------
- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
} // Fin du - (void)viewDidUnload {


//--------------------------------------------------
- (void)dealloc {
    [estim3OrientView release];
    [locationManager release];
    [super dealloc];
} // - (void)dealloc {

#pragma mark -
#pragma mark === Gestion des évènements Boussole ===
#pragma mark -

// This delegate method is invoked when the location manager has heading data.
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)heading {
    // Update the labels with the raw x, y, and z values.
	CLLocationDirection Orientation = heading.trueHeading;
    //	NSLog(@"  Orientation: %@",Orientation);
	
	    
    // Compute and display the magnitude (size or strength) of the vector.
	//      magnitude = sqrt(x^2 + y^2 + z^2)
    //[magnitudeLabel setText:[NSString stringWithFormat:@"%.1f", magnitude]];
	// ATD - A effacer [magnitudeLabel setText:[NSString stringWithFormat:@"Nord %.2f", Orientation]];
    [estim3OrientView updateDisplayAngle:Orientation];
    [estim3OrientView updateBoussoleAngle: -(Orientation)];
    NSLog(@"Flemme de corriger, mais il y a un blemme. L'orientation fournie n'est pas coorecte (style 270° au lieu de 90)");


} // Fin de - (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)heading {


// This delegate method is invoked when the location managed encounters an error condition.
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if ([error code] == kCLErrorDenied) {
        // This error indicates that the user has denied the application's request to use location services.
        [manager stopUpdatingHeading];
    } else if ([error code] == kCLErrorHeadingFailure) {
        // This error indicates that the heading could not be determined, most likely because of strong magnetic interference.
    }
}


#pragma mark -
#pragma mark === Fonctions NavigationBar (Retour et Valider) ===
#pragma mark -


//Action Back
-(void)actBack:(id)sender {
    NSLog(@"Top: @%",self.navigationController.topViewController);
	
	//Retour au controleur précédent
	[self.navigationController popViewControllerAnimated:YES];
} // Fin du -(void)actBack:(id)sender {


//Action Validate
-(void)actValidate:(id)sender {
	//Passage au controleur suivant
	Estim4ResultViewController *newController=[[Estim4ResultViewController alloc] init];

	[self.navigationController pushViewController:newController animated:YES];
	[newController release];
} // Fin du -(void)actValidate:(id)sender {


#pragma mark -
#pragma mark === Divers non gérés ===
#pragma mark -

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
} // Fin du - (void)didReceiveMemoryWarning {


@end
