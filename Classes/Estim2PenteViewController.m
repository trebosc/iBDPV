    //
//  Estim2PenteViewController.m
//  iBDPV
// JMD & DTR


#import "Estim2PenteViewController.h"
#import "Estim2aPenteAutoViewController.h"
#import "Estim2bPenteManuelViewController.h"


#import "Estim2PenteView.h"

 
@implementation Estim2PenteViewController

@synthesize bPenteVisible, userData;

//#########################################################################################################################################################
//#########################################################################################################################################################
#pragma mark -
#pragma mark === Setting up / Tearing down ===
#pragma mark -

/*
 //-------------------------------------------------------------------------------------------------------------------------------
- init {
	if (self = [super init]) {
	}
	return self;
}
*/

/*
 //-------------------------------------------------------------------------------------------------------------------------------
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/




//-------------------------------------------------------------------------------------------------------------------------------
// Implement viewWillAppear 
- (void)viewWillAppear:(BOOL)animated {
        [self.navigationController setNavigationBarHidden:NO];  
        [self.navigationController setToolbarHidden:NO animated:YES];    
 
        [super viewWillAppear:animated];
 NSLog(@"TODO : Vérifier que l'on appele les 'super' dans toutes les fonctions dérivées");
}


/*
 //-------------------------------------------------------------------------------------------------------------------------------
// Implement viewWillDisappear 
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

}
 */

//-------------------------------------------------------------------------------------------------------------------------------
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    
	// Affichage de la barre de navigation
	[self.navigationController setNavigationBarHidden:NO];
	
	//Titre
	self.title=@"2: Pente de votre toiture";
    
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
	
    
	
}


//-------------------------------------------------------------------------------------------------------------------------------
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {

	
	//NSLog(@"viewDidLoad: Estim2PenteViewController");
	
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];

    applicationFrame.origin.y   = 0;   //  Voir le code de Doudou ..... (sur le menu)
	//NSLog(@"viewDidLoad: Estim2PenteViewController  Bout de code pas beau  : applicationFrame.origin.y = 0");
    
	// Création par programme de la hiérarchie de vues (p34) 
	// Désactivé par Doudou - self.wantsFullScreenLayout=YES;   // Faire une rechercher dans le document PDF  ViewControlletPGforiPhoneOS
	NSLog(@"TODO - Voir le commentatire sur wantsFullScreenLayout - modifs réalisées par Doudou sur le Generic View pas été répercutées sur les EstimXXXX.m ou .h");
    
    
	// 1. Création de la vue racine du controlleur de la taille de l'écran
	UIView *rootView=[[UIView alloc] initWithFrame:applicationFrame];
	//rootView.backgroundColor=[UIColor whiteColor];
    rootView.backgroundColor=[UIColor whiteColor];
    rootView.opaque=YES;
    
    
    //***********************************
    //On rajoute une vue qui va afficher tout ce qui concerne la pente (angle, image maison, ...) 
    estim2PenteView = [[Estim2PenteView alloc] initWithFrame:applicationFrame viewController:self];
    NSLog(@"TODO Je ne comprends pas pourquoi il y a un pb 'incompatible Objectiv-C types' .... pourquoi il attend un Estim2bPenteManuelViewController");
    
    [rootView addSubview:estim2PenteView];

    
	// 3. Assignation de la vue racine à la propriété view du controlleur
	self.view=rootView;
	
  
	// 4. Libération de la vue racine
	[rootView release];
	
    
     

    
    
    [super viewDidLoad];
	NSLog(@"TODO  - Est-ce à la fin des fonctions delegate on doit pas appeler systématiquement le super (pour donner la main au père ?) - viewDidLoad: appel  super parce que .... pas fait dans code Doudou ?");
	
}




/*
 //-------------------------------------------------------------------------------------------------------------------------------
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

//-------------------------------------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


//-------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [estim2PenteView release];
    [super dealloc];
}




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
	//Passage au controleur suivant
    
    if (bPenteVisible)  {
            Estim2aPenteAutoViewController *newController=[[Estim2aPenteAutoViewController alloc] init];
            newController.userData=self.userData;
            [self.navigationController pushViewController:newController animated:YES];
            [newController release];
        } else  { // Avec le if (bPenteVisible)  {
            Estim2bPenteManuelViewController *newController=[[Estim2bPenteManuelViewController alloc] init];
            newController.userData=self.userData;
            [self.navigationController pushViewController:newController animated:YES];
            [newController release];
        } // Fin du if (bPenteVisible)  { 
    
    NSLog(@"TODO - Duplication du cote ...  de 2 variables (une finissant par A et l'autre par B ... on doit pouvoir faire mieux ...");

} // Fin du -(void)actValidate:(id)sender {

@end
