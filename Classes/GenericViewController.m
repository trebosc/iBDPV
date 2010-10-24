    //
//  GenericViewController.m
//  iBDPV
//
//  Created by jmd on 01/08/10.
//  Copyright 2010 __MaCoDa__. All rights reserved.
//

#import "GenericViewController.h"


@implementation GenericViewController

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
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {

	// Affichage de la barre de navigation
	[self.navigationController setNavigationBarHidden:NO];
	
	//Titre
	self.title=@"Generic Title";
	
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
	UIBarButtonItem *btnValidateItem=[[UIBarButtonItem alloc] initWithTitle:@"Valider" style:UIBarButtonItemStyleBordered target:self action:@selector(actValidate:)];
	
	// Ajout des boutons dans la toolBar
	self.toolbarItems=[NSArray arrayWithObjects:btnBackItem,flexibleSpaceButtonItem,btnValidateItem,nil];

	[btnBackItem release];
	[flexibleSpaceButtonItem release];
	
    //Création de la hiérarchie des Views
    // 1. Création de la vue racine du controlleur de la taille de l'écran
	// Background
    UIImageView *rootView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fond_menu.png"]];
    rootView.userInteractionEnabled=YES;    //NO by default and YES for a UIView
    rootView.opaque = YES;
    
	// 2. Ajout de subViews
	CGRect lblRect=CGRectMake(50.0, 50.0, 200, 40);
	UILabel	*lblWelcome=[[UILabel alloc] initWithFrame:lblRect];
	lblWelcome.text=@"Generic View Controller";
	[rootView addSubview:lblWelcome];
	[lblWelcome release];
	
	
	
	// 3. Assignation de la vue racine à la propriété view du controlleur
	self.view=rootView;
	
	// 4. Libération de la vue racine
	[rootView release];
    
    
	
}

/*
 //-------------------------------------------------------------------------------------------------------------------------------
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    //[super viewDidLoad];
	
	NSLog(@"viewDidLoad: GenericViewController");
	
	// Création par programme de la hiérarchie de vues (p34) 
		

}
/*

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
    [super dealloc];
}


//#########################################################################################################################################################
//#########################################################################################################################################################
#pragma mark -
#pragma mark === Actions ===
//-------------------------------------------------------------------------------------------------------------------------------
//Action Back
-(void)actBack:(id)sender {
			NSLog(@"Top: @%",self.navigationController.topViewController);
	
	//Retour au controlleur précédent
	[self.navigationController popViewControllerAnimated:YES];
	//[self.navigationController dismissModalViewControllerAnimated:YES];
}

//-------------------------------------------------------------------------------------------------------------------------------
//Action Validate
-(void)actValidate:(id)sender {
	//Passage au controleur suivant
	//Exemple
	GenericViewController *newController=[[GenericViewController alloc] init];
	[self.navigationController pushViewController:newController animated:YES];
	[newController release];
}

@end
