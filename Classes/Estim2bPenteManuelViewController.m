//
//  Estim2PenteViewController.m
//  iBDPV
// JMD & DTR


#import "Estim2bPenteManuelViewController.h"
#import "Estim3OrientViewController.h"
#import "UserData.h"
#import "Estim2bPenteManuelView.h"
 
@implementation Estim2bPenteManuelViewController

@synthesize slider, userData;


//#########################################################################################################################################################
//#########################################################################################################################################################
#pragma mark -
#pragma mark === Initialisation  ===
#pragma mark -

//-------------------------------------------------------------------------------------------------------------------------------
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    
	// Affichage de la barre de navigation
	[self.navigationController setNavigationBarHidden:NO];
	
	//Titre
	self.title=@"Pente toiture";
	
	// Bouton Retour
    self.navigationItem.backBarButtonItem =  [[[UIBarButtonItem alloc] initWithTitle:@"Retour" style: UIBarButtonItemStylePlain target:nil action:nil] autorelease];
    
	//Affichage de la toolBar du Navigation Controller
	[self.navigationController setToolbarHidden:NO animated:YES];
	
	//Création des boutons
	//Espacement
	UIBarButtonItem *flexibleSpaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	//Valider
	UIBarButtonItem *btnValidateItem=[[UIBarButtonItem alloc] initWithTitle:@"Valider" style:UIBarButtonItemStyleDone target:self action:@selector(actValidate:)];
	
	// Ajout des boutons dans la toolBar
	self.toolbarItems=[NSArray arrayWithObjects:flexibleSpaceButtonItem,btnValidateItem,nil];
    
	[flexibleSpaceButtonItem release];

} // Fin du - (void)loadView {





//-------------------------------------------------------------------------------------------------------------------------------
// Implement viewWillAppear 
- (void)viewWillAppear:(BOOL)animated {
        [self.navigationController setNavigationBarHidden:NO];  
        [self.navigationController setToolbarHidden:NO animated:YES];
    
         [super viewWillAppear:animated];
} // Fin du - (void)viewWillAppear:(BOOL)animated {



//-------------------------------------------------------------------------------------------------------------------------------
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {

	
	//NSLog(@"viewDidLoad: Estim2PenteViewController");
	
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    applicationFrame.origin.y   = 0;   //  Voir le code de Doudou ..... (sur le menu)
    
    
	// 1. Création de la vue racine du controlleur de la taille de l'écran
	UIView *rootView=[[UIView alloc] initWithFrame:applicationFrame];
	rootView.backgroundColor=[UIColor whiteColor];	
    rootView.opaque=YES;
	    

    //***********************************
    //On rajoute une vue qui va afficher tout ce qui concerne la pente (angle, image maison, ...) 
    estim2bPenteManuelView = [[Estim2bPenteManuelView alloc] initWithFrame:applicationFrame viewController:self];
    [rootView addSubview:estim2bPenteManuelView];

    
	// 3. Assignation de la vue racine à la propriété view du controlleur
	self.view=rootView;
	
  
	// 4. Libération de la vue racine
	[rootView release];
	
    
} // Fin du - (void)viewDidLoad {



//#########################################################################################################################################################
//#########################################################################################################################################################
#pragma mark -
#pragma mark === Traitement divers  ===
#pragma mark -
//-------------------------------------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
} // Fin du - (void)didReceiveMemoryWarning {


//#########################################################################################################################################################
//#########################################################################################################################################################
#pragma mark -
#pragma mark === Fin de vie  ===
#pragma mark -

//-------------------------------------------------------------------------------------------------------------------------------
// Implement viewWillDisappear 
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
} // Fin du - (void)viewWillDisappear:(BOOL)animated {


//-------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
} // Fin du - (void)viewDidUnload {


//-------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [estim2bPenteManuelView release];
    [super dealloc];
} // Fin du - (void)dealloc {



//#########################################################################################################################################################
//#########################################################################################################################################################
#pragma mark -
#pragma mark === Gestion de l'angle de vue Slider / Touch ===
#pragma mark -

//-------------------------------------------------------------------------------------------------------------------------------
-(IBAction)fixeAngleToit:(id)sender  // appele quand on bouge le slider de la vue
{
	//CGFloat newAngle=(CGFloat)[sender value];
	
	UISlider *senderSlider=(UISlider *)sender;
	[estim2bPenteManuelView setAngleToit:senderSlider.value];
	
	//NSLog(@"fixeAngleToit: %f",senderSlider.value);
} // Fin -(IBAction)fixeAngleToit:(id)sender  // appele quand on bouge le slider de la vue


//-------------------------------------------------------------------------------------------------------------------------------
-(void)angleToitModifie:(float)newAngle {
	//NSLog(@"angleToitModifie: %f - %f",newAngle,slider.value);
	[slider setValue:newAngle animated:NO];
} // Fin du -(void)angleToitModifie:(float)newAngle {


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
}// Fin du -(void)actBack:(id)sender {


//-------------------------------------------------------------------------------------------------------------------------------
//Action Validate
-(void)actValidate:(id)sender {
    
    // Stockage de la pente  dans la classe UserData qui est utilisée partout.
    self.userData.pente =  [estim2bPenteManuelView LectureAngleToit];

	//Passage au controleur suivant
	Estim3OrientViewController *newController=[[Estim3OrientViewController alloc] init];
    newController.userData=self.userData;
	[self.navigationController pushViewController:newController animated:YES];
	[newController release];
} // Fin du -(void)actValidate:(id)sender {


@end
