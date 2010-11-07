//
//  Estim2aPenteAutoViewController.m
//  iBDPV
// JMD & DTR


#import "Estim2aPenteAutoViewController.h"
#import "Estim3OrientViewController.h"
#import "Estim2aPenteAutoView.h"
#import "UserData.h"

#import "UIAlertImageView.h"
#import "findDeviceType.h"

#define kTransitionDuration	0.75
#define kUpdateFrequency 20  // Hz
#define kFilteringFactor 0.05
#define kNoReadingValue 999

 
@implementation Estim2aPenteAutoViewController

@synthesize calibrationOffset, userData;


//#########################################################################################################################################################
//#########################################################################################################################################################
#pragma mark -
#pragma mark === Setting up / Tearing down ===
#pragma mark -



//-------------------------------------------------------------------------------------------------------------------------------
- init {
	if (self = [super init]) {
        NSLog(@"TODO - init : Appelé une seule fois .... a mettre ailleurs ? ou faire le setDelegate dans le viewWillAppear ?");
        
        UIAlertImageView *alert = [[UIAlertImageView alloc] initWithTitle:@"Etape 2/3 - Pente"
                                                                  message:@"Inclinez votre iPhone afin de faire correspondre votre toit avec son côté, comme sur la photo ci-dessous."
                                                                 delegate:self
                                   //												cancelButtonTitle:@"Cancel"
                                                        cancelButtonTitle:nil
                                                        otherButtonTitles:@"OK", nil];
        NSLog(@"TODO - UIAlertImageView - voir comment lui donner le nom de l'image à télécharger (un attribut ?)");
        
        [alert show];
        [alert release];

	} // Fin du if (self = [super init]) {
	return self;
} // Fin du - init {


//-------------------------------------------------------------------------------------------------------------------------------
// Implement viewWillAppear 
- (void)viewWillAppear:(BOOL)animated {
    	[self.navigationController setNavigationBarHidden:YES];  
        [self.navigationController setToolbarHidden:YES animated:YES];
    
        // On lance l'accéléromètre ici pour qu'il soit lancé à chaque fois.
        [[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / kUpdateFrequency)];
        [[UIAccelerometer sharedAccelerometer] setDelegate:self];

        [super viewWillAppear:animated];
        NSLog(@"TODO - Vérifier que l'on appele les 'super' dans toutes les fonctions dérivées");
} // FIn du - (void)viewWillAppear:(BOOL)animated {



//-------------------------------------------------------------------------------------------------------------------------------
// Implement viewWillDisappear 
- (void)viewWillDisappear:(BOOL)animated {
    //NSLog(@"viewWillDisappear: Arrêt de l'accelerometre");
    [[UIAccelerometer sharedAccelerometer] setDelegate:nil];
    [super viewWillDisappear:animated];
} // Fin  du - (void)viewWillDisappear:(BOOL)animated {


//-------------------------------------------------------------------------------------------------------------------------------
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
    //NSLog(@"viewDidLoad: Estim2PenteViewController");
	
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];

    applicationFrame.origin.y   = 0;   //  Voir le code de Doudou ..... (sur le menu)
    
    
	// 1. Création de la vue racine du controlleur de la taille de l'écran
	UIView *rootView=[[UIView alloc] initWithFrame:applicationFrame];
	//rootView.backgroundColor=[UIColor whiteColor];
    rootView.backgroundColor=[UIColor greenColor];
    rootView.opaque=YES;
	
	// 2. Ajout de subViews
    //NSLog(@"Ne sert à rien puisque la vue est cachée ...");
	CGRect lblRect=CGRectMake(0.0, 0.0, 200, 40);
	UILabel	*lblWelcome=[[UILabel alloc] initWithFrame:lblRect];
	lblWelcome.text=@"Generic View Controller";
	[rootView addSubview:lblWelcome];
	[lblWelcome release];
	
    //***********************************
    //On rajoute une vue qui va afficher tout ce qui concerne la pente (angle, image maison, ...) 
    estim2aPenteAutoView = [[Estim2aPenteAutoView alloc] initWithFrame:applicationFrame viewController:self];
    [rootView addSubview:estim2aPenteAutoView];

    
	// 3. Assignation de la vue racine à la propriété view du controlleur
	self.view=rootView;
	
  
	// 4. Libération de la vue racine
	[rootView release];
	    
    //--------------------------------------------------------------------------------
    //--------------------------------------------------------------------------------
    //--------------------------------------------------------------------------------
    //--------------------------------------------------------------------------------

   // NSLog(@"viewDidLoad - Estim2PenteViewController - UIDEVICE");
	//NSLog(@"PlatformString %@",[[UIDevice currentDevice] platformString]);
	//NSLog(@"Platform : %d",[[UIDevice currentDevice] platformType]);
	//NSLog(@"Capacites : %d",[[UIDevice currentDevice] platformCapabilities]);
	//int essai = UIDeviceBuiltInCamera & [[UIDevice currentDevice] platformCapabilities];
	//if (essai == UIDeviceBuiltInCamera) 
	//	NSLog(@"TODO - Pour la v2 et la gestion de la vue derrière l'iphone - Appareil photo présent sur le device");
	//else 
	//	NSLog(@"Pas d'appareil photo");

    //--------------------------------------------------------------------------------
    //--------------------------------------------------------------------------------

    [super viewDidLoad];
	NSLog(@"TODO - A voir pour TOUS les modules viewDidLoad: appel su  super parce que .... pas fait dans code Doudou ?");
	
} // Fin du - (void)viewDidLoad {



//#########################################################################################################################################################
//#########################################################################################################################################################
#pragma mark -
#pragma mark === Calibration ===
#pragma mark -
//-------------------------------------------------------------------------------------------------------------------------------
- (float)calibratedAngleFromAngle:(float)rawAngle {
    float calibratedAngle = calibrationOffset + rawAngle;
   // NSLog(@"Toute la partie calibration a été virée (sauf cette fonction)");

    return calibratedAngle;
} // Fin du - (float)calibratedAngleFromAngle:(float)rawAngle {




//#########################################################################################################################################################
//#########################################################################################################################################################
#pragma mark -
#pragma mark === Responding to accelerations ===
#pragma mark -
//-------------------------------------------------------------------------------------------------------------------------------
// UIAccelerometer delegate method, which delivers the latest acceleration data.
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    
   // NSLog(@"Réception info accéléromètre");

    // Use a basic low-pass filter to only keep the gravity in the accelerometer values for the X and Y axes
    accelerationX = acceleration.x * kFilteringFactor + accelerationX * (1.0 - kFilteringFactor);
    accelerationY = acceleration.y * kFilteringFactor + accelerationY * (1.0 - kFilteringFactor);
    
    // keep the raw reading, to use during calibrations
    currentRawReading = atan2(accelerationY, accelerationX);
    
    float calibratedAngle = [self calibratedAngleFromAngle:currentRawReading];    
    [estim2aPenteAutoView updateToInclinationInRadians:calibratedAngle];
 
} // Fin du - (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {



//-------------------------------------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
} // Fin du - (void)didReceiveMemoryWarning {


//-------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
} // Fin du - (void)viewDidUnload {



//-------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [estim2aPenteAutoView release];
    [super dealloc];
} // Fin du - (void)dealloc {


//#########################################################################################################################################################
//#########################################################################################################################################################
#pragma mark -
#pragma mark === Fonctions NavigationBar (Retour et Valider) ===
#pragma mark -


//-------------------------------------------------------------------------------------------------------------------------------
//Action Back
-(void)actBack:(id)sender {
    //NSLog(@"Top: @%",self.navigationController.topViewController);
 	
	//Retour au controlleur précédent
	[self.navigationController popViewControllerAnimated:YES];
} // Fin du -(void)actBack:(id)sender {


//-------------------------------------------------------------------------------------------------------------------------------
//Action Validate
-(void)actValidate:(id)sender {
    
    // Stockage de la pente  dans la classe UserData qui est utilisée partout.
    self.userData.pente =  [estim2aPenteAutoView LectureAngleDegre];
    
	//Passage au controleur suivant
	Estim3OrientViewController *newController=[[Estim3OrientViewController alloc] init];
    newController.userData=self.userData;
	[self.navigationController pushViewController:newController animated:YES];
	[newController release];
} // Fin du -(void)actValidate:(id)sender {


@end
