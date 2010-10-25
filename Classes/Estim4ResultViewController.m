    //
//  Estim4ResultViewController.m
//  iBDPV
//
//  Created by jmd on 01/08/10.
//  Copyright 2010 __MaCoDa__. All rights reserved.
//

#import "Estim4ResultViewController.h"
#import "Estim5ResultDetailViewController.h"


@implementation Estim4ResultViewController

@synthesize userData;

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


//#########################################################################################################################################################
//#########################################################################################################################################################
#pragma mark -
#pragma mark === View lifecycle ===

//-------------------------------------------------------------------------------------------------------------------------------
-(NSURL *)buildURL {
    // Génération de la signature pour le lien http
    NSString *api_sig_a_convertir;
    api_sig_a_convertir = [NSString  stringWithFormat:@"ibdpv_20100712a%dapi_demandeuriBDPVd%dl%fo%fp%duid%@",
                           self.userData.orientation,
                           self.userData.distance,                    
                           self.userData.latitude,
                           self.userData.longitude,
                           self.userData.pente,  
                           self.userData.uniqueIdentifierMD5
                           ];
    
    NSString *api_sig;
    api_sig = [self.userData md5:api_sig_a_convertir];
    
    NSString *sUrl = [NSString  stringWithFormat:@"http://www.bdpv.fr/ajax/iBDPV/r.php?api_sig=%@&api_demandeur=iBDPV&uid=%@&l=%f&o=%f&d=%d&p=%d&a=%d",
                      api_sig,
                      self.userData.uniqueIdentifierMD5,
                      self.userData.latitude,
                      self.userData.longitude,
                      self.userData.distance,
                      self.userData.pente,
                      self.userData.orientation
                      ]; 
    
    NSLog(@"%@",sUrl); 
    
    return [[[NSURL alloc] initWithString:sUrl] autorelease];
    
}

//-------------------------------------------------------------------------------------------------------------------------------
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {

	// Affichage de la barre de navigation
	[self.navigationController setNavigationBarHidden:NO];
	
	//Titre
	self.title=@"Etape 4 - Resultat";
	
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




//-------------------------------------------------------------------------------------------------------------------------------
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    //[super viewDidLoad];
	
	NSLog(@"viewDidLoad: Estim4ResultViewController");
	
    
    /*
	// Création par programme de la hiérarchie de vues (p34) 
	self.wantsFullScreenLayout=YES;
	
	// 1. Création de la vue racine du controlleur de la taille de l'écran
	UIView *rootView=[[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
	rootView.backgroundColor=[UIColor whiteColor];
    rootView.opaque=YES;
	
	// 2. Ajout de subViews
	CGRect lblRect=CGRectMake(50.0, 50.0, 200, 40);
	UILabel	*lblWelcome=[[UILabel alloc] initWithFrame:lblRect];
	lblWelcome.text=@"ETAPE 4";
	[rootView addSubview:lblWelcome];
	[lblWelcome release];
	
	
	
	// 3. Assignation de la vue racine à la propriété view du controlleur
	self.view=rootView;
	
	// 4. Libération de la vue racine
	[rootView release];
	*/
	
	
}


//-------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
        // Lancement du parsing XML (mode SYNCHRONE)
        NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:[self buildURL]];
        
        
        //Set delegate
        [xmlParser setDelegate:self];
        
        NSLog(@"Loading first page synchrone. XML Parsing ...");
        
        //Start parsing the XML file.
       
        BOOL success = [xmlParser parse];
        
        if(success)
            NSLog(@"Loading XML Résultats OK");
        else {
            NSLog(@"Loading XML Résultats NOK");
            
            UIAlertView *alert = [[[UIAlertView alloc] 
                                   initWithTitle:@"Error"
                                   message:@"Loading XML Résultats NOK."
                                   delegate:self
                                   cancelButtonTitle:@"Cancel"
                                   otherButtonTitles:nil]
                                  autorelease];
            [alert show];
            
        } // 
        
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
    [super dealloc];
}

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
	Estim5ResultDetailViewController *newController=[[Estim5ResultDetailViewController alloc] init];
	[self.navigationController pushViewController:newController animated:YES];
	[newController release];
}

//#########################################################################################################################################################
//#########################################################################################################################################################
#pragma mark -
#pragma mark === Table view data source ===

//-------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


//-------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    return 0;
}


//-------------------------------------------------------------------------------------------------------------------------------
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return nil;
}


/*
 //-------------------------------------------------------------------------------------------------------------------------------
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 //-------------------------------------------------------------------------------------------------------------------------------
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */


/*
 //-------------------------------------------------------------------------------------------------------------------------------
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 //-------------------------------------------------------------------------------------------------------------------------------
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


@end
