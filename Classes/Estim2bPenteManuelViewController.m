    //
//  Estim2PenteViewController.m
//  iBDPV
//
//  Created by jmd on 01/08/10.
//  Copyright 2010 __MaCoDa__. All rights reserved.
//

#import "Estim2bPenteManuelViewController.h"
#import "Estim3OrientViewController.h"

#import "Estim2bPenteManuelView.h"
 
@implementation Estim2bPenteManuelViewController

@synthesize slider, userData;


#pragma mark -
#pragma mark === Initialisation  ===
#pragma mark -

/*
- init {
	if (self = [super init]) {
	}
	return self;
}
*/

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    
	// Affichage de la barre de navigation
	[self.navigationController setNavigationBarHidden:NO];
	
	//Titre
	self.title=@"Etape 2 - Pente de la toiture";
	
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
	
    
	
}




// Implement viewWillAppear 
- (void)viewWillAppear:(BOOL)animated {
    	NSLog(@"viewWillAppear: Estim2PenteViewController - la navigation Bar doit pas apparaitre !");
        NSLog(@"Pas fait sur Etape 3 (mais que sur 1 et 2)");
        [self.navigationController setNavigationBarHidden:NO];  
        [self.navigationController setToolbarHidden:NO animated:YES];
    
         [super viewWillAppear:animated];
 NSLog(@"Vérifier que l'on appele les 'super' dans toutes les fonctions dérivées");
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {

	
	NSLog(@"viewDidLoad: Estim2PenteViewController");
	
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];

    NSLog(@"UIScreen mainScreen : Ne retourne pas le bon chiffre :(  ");
    applicationFrame.origin.y   = 0;   //  Voir le code de Doudou ..... (sur le menu)
	NSLog(@"viewDidLoad: Estim2PenteViewController  Bout de code pas beau  : applicationFrame.origin.y = 0");
    
	// Création par programme de la hiérarchie de vues (p34) 
	// Désactivé par Doudou - self.wantsFullScreenLayout=YES;   // Faire une rechercher dans le document PDF  ViewControlletPGforiPhoneOS
	NSLog(@"modifs réalisées par Doudou sur le Generic View pas été répercutées sur les EstimXXXX.m ou .h");
    
    
	// 1. Création de la vue racine du controlleur de la taille de l'écran
	UIView *rootView=[[UIView alloc] initWithFrame:applicationFrame];
	rootView.backgroundColor=[UIColor whiteColor];	
    rootView.opaque=YES;
	
	// 2. Ajout de subViews
    NSLog(@"Ne sert à rien puisque la vue est cachée ...");
	CGRect lblRect=CGRectMake(0.0, 0.0, 200, 40);
	UILabel	*lblWelcome=[[UILabel alloc] initWithFrame:lblRect];
	lblWelcome.text=@"Generic View Controller";
	[rootView addSubview:lblWelcome];
	[lblWelcome release];
	
    
    NSLog(@"Penser à modifier les boutons valider et retour de la vue GPS");
    NSLog(@"Mettre les boutons de la vue Orientation comme ceux des autres vues ou alors rajouter une toolbar");
    NSLog(@"Est-ce qu'il faudrait pas mettre un bouton (i) pour chaque écran pour expliquer ce qu'il faut faire ? Avec une photo et un texte simple ?");

    //***********************************
    //On rajoute une vue qui va afficher tout ce qui concerne la pente (angle, image maison, ...) 
    estim2bPenteManuelView = [[Estim2bPenteManuelView alloc] initWithFrame:applicationFrame viewController:self];
    [rootView addSubview:estim2bPenteManuelView];

    
	// 3. Assignation de la vue racine à la propriété view du controlleur
	self.view=rootView;
	
  
	// 4. Libération de la vue racine
	[rootView release];
	
    
   }


#pragma mark -
#pragma mark === Traitement divers  ===
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
}

#pragma mark -
#pragma mark === Fin de vie  ===
#pragma mark -

// Implement viewWillDisappear 
- (void)viewWillDisappear:(BOOL)animated {
    NSLog(@"viewWillDisappear: Arrêt de l'accelerometre");
    [[UIAccelerometer sharedAccelerometer] setDelegate:nil];
    [super viewWillDisappear:animated];
    
}



- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [estim2bPenteManuelView release];
    [super dealloc];
}


#pragma mark -
#pragma mark === Gestion de l'angle de vue Slider / Touch ===
#pragma mark -

-(IBAction)fixeAngleToit:(id)sender  // appele quand on bouge le slider de la vue
{
	//CGFloat newAngle=(CGFloat)[sender value];
	
	UISlider *senderSlider=(UISlider *)sender;
	[estim2bPenteManuelView setAngleToit:senderSlider.value];
	
	NSLog(@"fixeAngleToit: %f",senderSlider.value);
}

-(IBAction)fixeAngleSlider:(float)angle {
	//NSLog(@"fixeAngleSlider");
    NSLog(@"Sert à quoi ???");

}


-(void)angleToitModifie:(float)newAngle {
	//NSLog(@"angleToitModifie: %f - %f",newAngle,slider.value);
	
	[slider setValue:newAngle animated:NO];
	
	
}

#pragma mark -
#pragma mark === Gestion des boutons de la toolbar Navigation  ===
#pragma mark -


//Action Back
-(void)actBack:(id)sender {
			NSLog(@"Top: @%",self.navigationController.topViewController);
 	
	//Retour au controlleur précédent
	[self.navigationController popViewControllerAnimated:YES];
}

//Action Validate
-(void)actValidate:(id)sender {
	//Passage au controleur suivant
	Estim3OrientViewController *newController=[[Estim3OrientViewController alloc] init];
    newController.userData=self.userData;
	[self.navigationController pushViewController:newController animated:YES];
	[newController release];
}

@end
