//
//  MenuViewController.m
//  iBDPV
//
//  Created by jmd on 31/07/10.
//  Copyright (c) 2010 __MaCoDa__. All rights reserved.
//

#import "MenuViewController.h"
#import "GenericViewController.h"
#import "Estim1GPSViewController.h"
#import "FichesProchesTableViewController.h"

@implementation MenuViewController


#import <CommonCrypto/CommonDigest.h>

@synthesize userData;

// Différent état de la connexion au serveur BDPV.fr
const int CNX_RIEN = 0;
const int CNX_DEBUT = 2;
const int CNX_EN_COURS_DOWNLOAD = 2;
const int CNX_EN_COURS_PARSING = 2;
const int CNX_OK = 1;
const int CNX_BAD = -1;
const int CNX_VERSION_OBSOLETE = -2;

//--------------------
NSString* md5( NSString *str )
{
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), result );
    NSLog(@"Mettre dans une classe OUTILS  avec cryptage signature");
    
    return [NSString  stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4],
            result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12],
            result[13], result[14], result[15]
            ];
}



 - init {
 if (self = [super init]) {
     NSLog(@"Premiere initialisation");
     iEtatConnexion = CNX_RIEN;
 }
 return self;
 }


/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
		NSLog(@"initWithNibName");
		
				
		
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    //[super viewDidLoad];
    NSLog(@"viewDidLoad: MenuViewController");
	
	// Création par programme de la hiérarchie de vues (p34) 
    
	// 1. Création de la vue racine du controlleur de la taille de l'écran
    // Background
    UIImageView *rootView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fond_menu.png"]];
    rootView.userInteractionEnabled=YES;    //NO by default and YES for a UIView
    //rootView.center = self.parentViewController.view.center;
    rootView.opaque = YES;
    

    // 2. Ajout de subViews             
	float btnX = 40.0;
	float btnFirstY=160.0;
	float btnWidth= 250.0;
	float btnHeight = 40.0;
	float btnInterval = 10.0;
	
	// ----- Bouton Estimer ma production
	CGRect btnRect= CGRectMake(btnX, btnFirstY, btnWidth, btnHeight);
	//UIButton *btnEstimer=[[UIButton alloc] initWithFrame:btnRect];
	UIButton *btnEstimer=[[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];	// retain???
	//btnEstimer.backgroundColor=[UIColor clearColor];
	btnEstimer.frame=btnRect;
	[btnEstimer setTitle:@"Estimer ma production" forState:UIControlStateNormal];
	//[btnEstimer setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
	[btnEstimer addTarget:self action:@selector(actEstimer:) forControlEvents:UIControlEventTouchUpInside];
	[rootView addSubview:btnEstimer];
	[btnEstimer release];
	
	// ----- Bouton Fiches proches
	btnRect= CGRectMake(btnX, btnFirstY + btnHeight + btnInterval, btnWidth, btnHeight);
	UIButton *btnFichesProches=[[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];	// retain???
	btnFichesProches.frame=btnRect;
	[btnFichesProches setTitle:@"Fiches proches" forState:UIControlStateNormal];
	[btnFichesProches addTarget:self action:@selector(actFichesProches:) forControlEvents:UIControlEventTouchUpInside];
	[rootView addSubview:btnFichesProches];
	[btnFichesProches release];
	
	// ----- Bouton Options
	btnRect= CGRectMake(btnX, btnFirstY + (btnHeight + btnInterval)*2, btnWidth, btnHeight);
	UIButton *btnOptions=[[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];	// retain???
	btnOptions.frame=btnRect;
	[btnOptions setTitle:@"Options" forState:UIControlStateNormal];
	[btnOptions addTarget:self action:@selector(actOptions:) forControlEvents:UIControlEventTouchUpInside];
	[rootView addSubview:btnOptions];
	[btnOptions release];
	
	// ----- Bouton A propos
	btnRect= CGRectMake(btnX, btnFirstY + (btnHeight + btnInterval)*3, btnWidth, btnHeight);
	UIButton *btnAPropos=[[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];	// retain???
	btnAPropos.frame=btnRect;
	[btnAPropos setTitle:@"A propos" forState:UIControlStateNormal];
	[btnAPropos addTarget:self action:@selector(actAPropos:) forControlEvents:UIControlEventTouchUpInside];
	[rootView addSubview:btnAPropos];
	[btnAPropos release];

    NSLog (@"Rajouter le numéro de version actelle sous les boutons");
    NSLog (@"et indiquer (lien cliquable ?)  'obsolète' ou 'nouvelle version disponible'");
    
	// 3. Assignation de la vue racine à la propriété view du controlleur
	self.view=rootView;
	
    
    //-------------------------------------------------------
    alertAttenteTestCnx = [[[UIAlertView alloc] initWithTitle:@"Vérification connexion BDPV.fr\nVeuillez patienter ..." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] autorelease];    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [alertAttenteTestCnx show];
  
    // Adjust the indicator so it is up a few pixels from the bottom of the alert
    indicator.center = CGPointMake(alertAttenteTestCnx.bounds.size.width / 2, alertAttenteTestCnx.bounds.size.height - 50);
    [indicator startAnimating];
    [alertAttenteTestCnx addSubview:indicator];
    [indicator release];
    
	// 4. Libération de la vue racine
	[rootView release];
    
    
    //************************************************************************************
    //************************************************************************************
    //************************************************************************************
    //************************************************************************************
    //************************************************************************************
    //************************************************************************************
    
    //---------------------
    NSLog(@"Il faut que l'api_secret soit stocké dans un fichier qui n'est donné à personne.");
    
    //
	// Divers PLIST - A noter quelque part !!!!
	//UIDeviceFamily (Number or Array - iPhone OS) specifies the underlying hardware type on which this application is designed to run.
	// Important: Do not insert this key manually into your Info.plist files. Xcode inserts it automatically based on the value in the Targeted Device Family build setting.
	//You should use that build setting to change the value of the key.
    NSLog(@"Voir les commentaires dans ReachabilityAppDelegate.m");
	//UIRequiredDeviceCapabilities
	// wifi  et/ou 3G ??
	// accelerometer
	// location-services  <- A vérifier si cela ne gène pas sur iTouch ou iPad <- Je dirais non !!
	//
    //---------------------
    
    // Pour récupérer le num de version dans le .plist    
    
    NSString *sVersion;
    sVersion = [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    NSLog(@"Num_versionUID (trouvé dans le .plist): %@",sVersion);
    
    //-----------------------------------------------------------------------
    // Récupération de diverses informations sur le disque de l'Iphone
    NSArray *arrayPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [arrayPaths objectAtIndex:0];
    
    // Fichier stocké dans /Users/David/Librady/Application Support/iPhone Simulator/4.0/Applications/73D27347-097D-49BA-8CA3-D2CDA234C7A5/Documents
    NSString *filePath = [docDirectory stringByAppendingString:@"/iBDPV_infos.txt"];
    NSString *fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    NSString *uniqueIdentifierMD5;
    if (fileContents == nil) {
        NSLog(@"Pas de fichier - On doit générer un ID Unique");
        //-----------------------------------------------------------------------
        // Génération d'un identifiant Unique pour ce device
        UIDevice *device = [UIDevice currentDevice];
        NSString *uniqueIdentifier = [device uniqueIdentifier];
        [device release];
        NSLog(@"  UID du device: %@",uniqueIdentifier);
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HHmmss"];
        NSString * sHeure = [dateFormatter stringFromDate:[NSDate date]];    
        [dateFormatter release];
        NSLog(@"  sHeure: %@",sHeure);
        
        NSString *uniqueIdentifier_a_convertir = [NSString  stringWithFormat:@"%@%@",uniqueIdentifier,sHeure];
        NSLog(@"  uniqueIdentifier_a_convertir: %@",uniqueIdentifier_a_convertir);
        
        uniqueIdentifierMD5 = md5(uniqueIdentifier_a_convertir);
        NSLog(@"  UID du device MD5: %@",uniqueIdentifierMD5);
        uniqueIdentifierMD5 = [uniqueIdentifierMD5 substringToIndex:8];
        NSLog(@"  UID du device MD5 (8 premiers): %@",uniqueIdentifierMD5);
        
        //--------
        // Stockage de l'information UID Unique dans un fichier dans l'iPhone
        NSLog(@"Ecriture du UID dans le fichier de préférences");
        NSString *string = [NSString  stringWithFormat:@"UID:%@",uniqueIdentifierMD5];
        [string writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
    } else {    
        NSLog(@"Contenu du fichier : %@", fileContents);
        uniqueIdentifierMD5 = [fileContents substringFromIndex:4];
        NSLog(@"UID du device MD5: %@",uniqueIdentifierMD5);
        
    } // Fin du if (fileContents == nil) {
    
    self.userData.uniqueIdentifierMD5=uniqueIdentifierMD5;
    
    //-----------------------------------------------------------------------
    // -------
    // Génération de la signature pour le lien http
    NSString *api_sig_a_convertir;
    api_sig_a_convertir = [NSString  stringWithFormat:@"ibdpv_20100712api_demandeuriBDPVn%@uid%@",sVersion,uniqueIdentifierMD5];
    NSLog(@"api_sig_a_convertir: %@",api_sig_a_convertir);
    
    NSString *api_sig;
    api_sig = md5(api_sig_a_convertir);
    NSLog(@"api_sig: %@",api_sig);
    
    
    //URL
    NSString *sUrl = [NSString  stringWithFormat:@"http://www.bdpv.fr/ajax/iBDPV/v.php?api_sig=%@&api_demandeur=iBDPV&uid=%@&n=%@",api_sig,uniqueIdentifierMD5,sVersion];
    NSLog(@"Tester les cas erreurs : Mauvais arguments, mauvaise signature, version sup à celle du serveur, ...");
    NSURL *url = [[NSURL alloc] initWithString:sUrl];
    NSLog(@"Récupération des infos de l'URL: %@",sUrl);
    

    NSLog(@"--------------------------");
    // Create the request.
     NSURLRequest *theRequest=[NSURLRequest requestWithURL:url
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
    NSLog(@"Apres requestWithURL");
    // create the connection with the request
    // and start loading the data
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    NSLog(@"apres NSURLConnection");
    iEtatConnexion = CNX_DEBUT;

    NSLog(@"Est-ce qu'il faut prévoir un timeout sur la connexion avec un NSTimer qui arrête tout ?");
    
    if (theConnection) {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        NSLog(@"dans the Connexion 1");
        receivedData = [[NSMutableData data] retain];
        NSLog(@"dans the Connexion 2");
    } else {
        // Inform the user that the connection failed.
        NSLog(@"ERREUR dans the Connexion");
    }
    

    //************************************************************************************
    //************************************************************************************
    //************************************************************************************
    //************************************************************************************
    //************************************************************************************
    //************************************************************************************
    
	

}

//AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    NSLog(@"ATD - Succeeded! Received %d bytes of data",[receivedData length]);
    iEtatConnexion = CNX_EN_COURS_PARSING;

    
    [alertAttenteTestCnx dismissWithClickedButtonIndex:0 animated:YES];
    
    
        //--------------
     // Lancement du parsing XML
     NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:receivedData];
     
     NSLog(@"Ici xmlParser contient le contenu data qui a été téléchargé");
     NSLog(@"Aucun rapport, mais voir Dictionary keys for the UIRequiredDeviceCapabilities key");
    
    
     //---------------------------------------------------
     //Set delegate
     NSLog(@"On indique qui va traiter le retour XML");
     [xmlParser setDelegate:self];
     
     NSLog(@"Parse du XML");
     
     //Start parsing the XML file.
     BOOL success = [xmlParser parse];
     
     if(success)
         NSLog(@"No Errors");
     else {
         NSLog(@"Error Error Error!!! - Soit erreur dans le XML, soit erreur de connexion Internet");
         
         UIAlertView *alert = [[[UIAlertView alloc] 
                                initWithTitle:@"Error"
                                message:@"Pb du parsing XML"
                                delegate:self
                                cancelButtonTitle:@"Cancel"
                                otherButtonTitles:nil]
                               autorelease];
         [alert show];

     } // fin du if(success)
    
    
    // release the connection, and the data object
    [connection release];
    [receivedData release];
} // Fin du - (void)connectionDidFinishLoading:(NSURLConnection *)connection


//************************************************************************************
//************************************************************************************
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response

{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    // receivedData is an instance variable declared elsewhere.
    [receivedData setLength:0];
    iEtatConnexion = CNX_DEBUT;

}

//************************************************************************************
//************************************************************************************
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data

{
    
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [receivedData appendData:data];
    iEtatConnexion = CNX_EN_COURS_DOWNLOAD;

}




//************************************************************************************
//************************************************************************************
- (void)connection:(NSURLConnection *)connection

  didFailWithError:(NSError *)error

{
    // release the connection, and the data object
    [connection release];
    
    // receivedData is declared as a method instance elsewhere
    [receivedData release];
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",[error localizedDescription],
          [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
    
    iEtatConnexion = CNX_BAD;

    
    [alertAttenteTestCnx dismissWithClickedButtonIndex:0 animated:YES];
     
    UIAlertView *alert = [[[UIAlertView alloc] 
                           initWithTitle:@"Bad connexion"
                           message:@"Connexion BAD"
                           delegate:self
                           cancelButtonTitle:@"Cancel"
                           otherButtonTitles:nil]
                          autorelease];
    
    
    [alert show];
        
    
}
//************************************************************************************
//************************************************************************************



//************************************************************************************
//************************************************************************************
//************************************************************************************
//************************************************************************************
//************************************************************************************
//************************************************************************************
//************************************************************************************
//************************************************************************************

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

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



//*********************************************************
//*********************************************************
//*********************************************************
//*********************************************************

//-------------------------------------------------
- (void)dealloc {
    
    [self.userData release];
    
    [super dealloc];
} // Fin du - (void)dealloc {


-(void)viewWillAppear:(BOOL)animated {
	[self.navigationController setToolbarHidden:YES animated:NO];
    [self.navigationController setNavigationBarHidden:YES];      
	[super viewWillAppear:animated];
}



#pragma mark -
#pragma mark === Actions ===
//-----------------------------------------------------------------------------------
-(void)actEstimer:(id)sender {
	NSLog(@"actEstimer");
    if (iEtatConnexion == CNX_VERSION_OBSOLETE) {
        UIAlertView *alert = [[[UIAlertView alloc] 
                               initWithTitle:@"IMPOSSIBLE"
                               message:@"Version obsolete : proposer Annuler ou App Store"
                               delegate:self
                               cancelButtonTitle:@"Cancel"
                               otherButtonTitles:nil]
                              autorelease];
        
        
        [alert show];        
    } else if (iEtatConnexion == CNX_BAD) {
        UIAlertView *alert = [[[UIAlertView alloc] 
                               initWithTitle:@"IMPOSSIBLE"
                               message:@"Pas de connexion Serveur - Proposer Annuler"
                               delegate:self
                               cancelButtonTitle:@"Cancel"
                               otherButtonTitles:nil]
                              autorelease];
        
        
        [alert show];                    
    } else  {
        Estim1GPSViewController *newController=[[Estim1GPSViewController alloc] init];
        newController.menuOrigin=@"Estim";
        newController.userData=self.userData;
        [self.navigationController pushViewController:newController animated:YES];
        [newController release];
    }   
	
}

//-----------------------------------------------------------------------------------
-(void)actFichesProches:(id)sender {
    if (iEtatConnexion == CNX_VERSION_OBSOLETE) {
        UIAlertView *alert = [[[UIAlertView alloc] 
                               initWithTitle:@"IMPOSSIBLE"
                               message:@"Version obsolete : proposer Annuler ou App Store"
                               delegate:self
                               cancelButtonTitle:@"Cancel"
                               otherButtonTitles:nil]
                              autorelease];
        
        
        [alert show];        
    } else if (iEtatConnexion == CNX_BAD) {
        UIAlertView *alert = [[[UIAlertView alloc] 
                               initWithTitle:@"IMPOSSIBLE"
                               message:@"Pas de connexion Serveur - Proposer Annuler"
                               delegate:self
                               cancelButtonTitle:@"Cancel"
                               otherButtonTitles:nil]
                              autorelease];
        
        
        [alert show];                    
    } else  {
        
        if (self.userData.longitude==0 || self.userData.latitude==0) {
            Estim1GPSViewController *newController=[[Estim1GPSViewController alloc] init];
            newController.menuOrigin=@"FichesProches";
            newController.userData=self.userData;
            [self.navigationController pushViewController:newController animated:YES];
            [newController release];        
        }
        else {
            FichesProchesTableViewController *newController=[[FichesProchesTableViewController alloc] init];
            newController.userData=self.userData;
            [self.navigationController pushViewController:newController animated:YES];
            [newController release];
        }
               
    }   
    
} // Fin du -(void)actFichesProches:(id)sender {


//-----------------------------------------------------------------------------------
-(void)actOptions:(id)sender {
    
} // Fin du -(void)actOptions:(id)sender {


//-----------------------------------------------------------------------------------
-(void)actAPropos:(id)sender {
    /*
     //Modal
     GenericViewController *newController=[[GenericViewController alloc] init];
     newController.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
     
     //Navigation Controller
     UINavigationController *navController=[[UINavigationController alloc] initWithRootViewController:newController];
     [newController release];
     [self presentModalViewController:navController animated:YES];
     [navController release];
     */
} // Fin du -(void)actAPropos:(id)sender {




#pragma mark -
#pragma mark === Parser XML ===
//************************************************************************************
//************************************************************************************
//************************************************************************************
//************************************************************************************
//************************************************************************************
//************************************************************************************

/*
 <base_complete>
 <UID>0903902</UID>
 <Num_version_UID>3.2</Num_version_UID>
 <Num_version_act>4.8</Num_version_act>
 <Num_version_min>4.0</Num_version_min>
 <Code_retour>-1</Code_retour>
 <Texte_erreur>-1</Texte_erreur>
 </base_complete>
 */

// #### NSXMLParserDelegate

// Start tag
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
	attributes:(NSDictionary *)attributeDict {
	
	//NSLog(@"didStartElement: %@",elementName);
	
	if ([elementName isEqualToString:@"base_complete"]) { //sites
		// Init Sites
		NSLog(@"On a le code base_complete");
	}
	
}

// Values
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	
	//NSLog(@"foundCharacters: %@",string);
	
	if (!currentStringValue) {
        // currentStringValue is an NSMutableString instance variable
        currentStringValue = [[NSMutableString alloc] initWithCapacity:50];
    }
	//NSLog(@"String: %@",string);
    [currentStringValue appendString:string];		
    
}

//-------------------------------------------------------------------------
// End tag
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    NSString *Num_version_act;
	NSString *Num_version_min;
	NSString *sCodeRetour;
    NSString *sTexte_erreur;
    int iCodeRetour;
    
	//NSLog(@"didEndElement ICI 1: %@",elementName);
	
    if ([elementName isEqualToString:@"Num_version_act"]) {	
		Num_version_act =[currentStringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSLog(@"Num_version_act: %@",Num_version_act);
	}
	else if ([elementName isEqualToString:@"Num_version_min"]) {	
		Num_version_min =[currentStringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSLog(@"Num_version_min: %@",Num_version_min);
	}
	else if ([elementName isEqualToString:@"Texte_erreur"]) {	
		sTexte_erreur =[currentStringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSLog(@"Texte_erreur: %@",sTexte_erreur);
	}	else if ([elementName isEqualToString:@"Code_retour"]) {
		sCodeRetour =[currentStringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		iCodeRetour =sCodeRetour.intValue;
        NSLog(@"Code_retour: %@",sCodeRetour);
        
        
        NSLog(@"Ce test d'erreur devrait être mis ailleur et pas dans le Parsing !!!!");

        iEtatConnexion = CNX_OK;
        UIAlertView *alert;
        switch (iCodeRetour)
        {
            case -1:
                NSLog (@"Version obsolète non acceptée. Il faut upgrader iBDPV");
                alert = [[[UIAlertView alloc] 
                                       initWithTitle:@"Version iBDPV obsolète"
                                       message:@"Il est nécessaire de télécharger la nouvelle version.\nProposer 'Annuler' et 'AppStore'. Rajouter les num de version dans l'alert"
                                       delegate:self
                                       cancelButtonTitle:@"Cancel"
                                       otherButtonTitles:nil]
                                      autorelease];
                [alert show];

                iEtatConnexion = CNX_VERSION_OBSOLETE;
                break;
            case 0:
                NSLog (@"Version ancienne, mais toujours acceptée par iBDPV");
                alert = [[[UIAlertView alloc] 
                                       initWithTitle:@"Bad connexion"
                                       message:@"Une version plus récente d'iBDPV est disponible.\nProposer 'Plus tard' et 'AppStore'. Rajouter les num de version dans l'alert"
                                       delegate:self
                                       cancelButtonTitle:@"Ok"
                                       otherButtonTitles:nil]
                                      autorelease];
                [alert show];

                break;
            case 1:
                NSLog (@"Version upToDate - Version officielle sur appStore");
                break;
                
            case 2:
                NSLog (@"Version Béta - En cours de développement");
                break;
                
            case 3:
                NSLog (@"Erreur non traitéee");
                NSLog (@"Afficher le contenu de la chaine texte_erreur");
               alert = [[[UIAlertView alloc] 
                                       initWithTitle:@"Erreur inconnue"
                                       message:@"Erreur inconnue (sTexte_erreur) par le serveur BDPV.fr"
                                       delegate:self
                                       cancelButtonTitle:@"Cancel"
                                       otherButtonTitles:nil]
                                      autorelease];
                [alert show];
                iEtatConnexion = CNX_BAD;
                break;
                
            default:
                NSLog (@"Impossible normalement - Mettre un popup Alert !");
                alert = [[[UIAlertView alloc] 
                                       initWithTitle:@"Error"
                                       message:@"Pb du code retour :("
                                       delegate:self
                                       cancelButtonTitle:@"Cancel"
                                       otherButtonTitles:nil]
                                      autorelease];
                [alert show];
                NSLog (@"Release nécessaire pour les alert (il y en a 3) ?");
                iEtatConnexion = CNX_BAD;
                break;
        } // Fin du switch (code_retour)
    
    } // Fin du if ([elementName isEqualToString:@"code_retour"]) {

	[currentStringValue release];
	currentStringValue=nil;
	
} // Fin du - (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName


//************************************************************************************
//************************************************************************************
//************************************************************************************
//************************************************************************************
//************************************************************************************

@end
