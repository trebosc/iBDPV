//
//  MenuViewController.m
//  iBDPV
// JMD & DTR


#import "MenuViewController.h"
#import "AProposViewController.h"
#import "Estim1GPSViewController.h"
#import "FichesProchesTableViewController.h"
#import "UserData.h"

@implementation MenuViewController


#import <CommonCrypto/CommonDigest.h>

@synthesize userData;
@synthesize Num_version_act;
@synthesize Num_version_min;
@synthesize sCodeRetour;
@synthesize iCodeRetour;
@synthesize sTexte_erreur;


// Différent état de la connexion au serveur BDPV.fr
const int CNX_RIEN = 0;
const int CNX_DEBUT = 2;
const int CNX_EN_COURS_DOWNLOAD = 2;
const int CNX_EN_COURS_PARSING = 2;
const int CNX_OK = 1;
const int CNX_BAD = -1;
const int CNX_VERSION_OBSOLETE = -2;


//#########################################################################################################################################################
//#########################################################################################################################################################
#pragma mark -
#pragma mark === Init et divers Windows  ===

//-------------------------------------------------------------------------------------------------------------------------------
 - init {
         if (self = [super init]) {
        //     NSLog(@"Premiere initialisation");
             iEtatConnexion = CNX_RIEN;
         } // Fin du if (self = [super init]) {

     return self;
 } // Fin du - init {




//-------------------------------------------------------------------------------------------------------------------------------
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    //[super viewDidLoad];

	// Bouton Retour
    self.navigationItem.backBarButtonItem =  [[[UIBarButtonItem alloc] initWithTitle:@"Retour" style: UIBarButtonItemStylePlain target:nil action:nil] autorelease];

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

/* // Pour la v2.0
	// ----- Bouton Options
	btnRect= CGRectMake(btnX, btnFirstY + (btnHeight + btnInterval)*2, btnWidth, btnHeight);
	UIButton *btnOptions=[[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];	// retain???
	btnOptions.frame=btnRect;
	[btnOptions setTitle:@"Options" forState:UIControlStateNormal];
	[btnOptions addTarget:self action:@selector(actOptions:) forControlEvents:UIControlEventTouchUpInside];
	[rootView addSubview:btnOptions];
	[btnOptions release];
*/
	
	// ----- Bouton A propos
	btnRect= CGRectMake(btnX, btnFirstY + (btnHeight + btnInterval)*3, btnWidth, btnHeight);
	UIButton *btnAPropos=[[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];	// retain???
	btnAPropos.frame=btnRect;
	[btnAPropos setTitle:@"A propos" forState:UIControlStateNormal];
	[btnAPropos addTarget:self action:@selector(actAPropos:) forControlEvents:UIControlEventTouchUpInside];
	[rootView addSubview:btnAPropos];
	[btnAPropos release];

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
    // Pour récupérer le num de version dans le .plist    
    
    NSString *sVersion;
    sVersion = [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
//    NSLog(@"Num_versionUID (trouvé dans le .plist): %@",sVersion);
    
    //-----------------------------------------------------------------------
    // Récupération de diverses informations sur le disque de l'Iphone
    NSArray *arrayPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [arrayPaths objectAtIndex:0];
    
    // Fichier stocké dans /Users/David/Librady/Application Support/iPhone Simulator/4.0/Applications/73D27347-097D-49BA-8CA3-D2CDA234C7A5/Documents
    NSString *filePath = [docDirectory stringByAppendingString:@"/iBDPV_infos.txt"];
    NSString *fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    NSString *uniqueIdentifierMD5;
    if (fileContents == nil) {
        //-----------------------------------------------------------------------
        // Génération d'un identifiant Unique pour ce device
        UIDevice *device = [UIDevice currentDevice];
        NSString *uniqueIdentifier = [device uniqueIdentifier];
        [device release];
//        NSLog(@"  UID du device: %@",uniqueIdentifier);
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HHmmss"];
        NSString * sHeure = [dateFormatter stringFromDate:[NSDate date]];    
        [dateFormatter release];
//        NSLog(@"  sHeure: %@",sHeure);
        
        NSString *uniqueIdentifier_a_convertir = [NSString  stringWithFormat:@"%@%@",uniqueIdentifier,sHeure];
//        NSLog(@"  uniqueIdentifier_a_convertir: %@",uniqueIdentifier_a_convertir);
        
        uniqueIdentifierMD5 = [self.userData md5:uniqueIdentifier_a_convertir];
//        NSLog(@"  UID du device MD5: %@",uniqueIdentifierMD5);
        uniqueIdentifierMD5 = [uniqueIdentifierMD5 substringToIndex:8];
//        NSLog(@"  UID du device MD5 (8 premiers): %@",uniqueIdentifierMD5);
        
        //--------
        // Stockage de l'information UID Unique dans un fichier dans l'iPhone
//        NSLog(@"Ecriture du UID dans le fichier de préférences");
        NSString *string = [NSString  stringWithFormat:@"UID:%@",uniqueIdentifierMD5];
        [string writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
    } else {    
//        NSLog(@"Contenu du fichier : %@", fileContents);
        uniqueIdentifierMD5 = [fileContents substringFromIndex:4];
//        NSLog(@"UID du device MD5: %@",uniqueIdentifierMD5);
        
    } // Fin du if (fileContents == nil) {
    
    self.userData.uniqueIdentifierMD5=uniqueIdentifierMD5;
    
    //-----------------------------------------------------------------------    
    //URL- Génération de l'URL
    // Paramètre de l'appel
    NSString *sParam = @"v.php";
    NSMutableArray  *myArray = [NSMutableArray arrayWithObjects:
                           [NSString  stringWithFormat:@"n=%@",sVersion],
                          nil];
    NSString *sUrl = [self.userData genere_requete:myArray fichier_php:sParam];


    //NSLog(@"Récupération des infos de l'URL: %@",sUrl);
    NSURL *url = [[NSURL alloc] initWithString:sUrl];


//    NSLog(@"--------------------------");
    // Create the request.
     NSURLRequest *theRequest=[NSURLRequest requestWithURL:url    // A priori requestWithUrl est différent de initWithUrl et renvoit un objet autorelease.
                                              cachePolicy:NSURLRequestReloadIgnoringLocalCacheData  // On précise que l'on veut pas une lecture du cache
                                          timeoutInterval:10.0];
    
    //[url release];
     NSLog(@"TODO - Je tenterais release ICI, vu que l'url est créée avec un init (théorème Doudou)");

//    NSLog(@"Apres requestWithURL");
    // create the connection with the request
    // and start loading the data
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
//    NSLog(@"apres NSURLConnection");
    iEtatConnexion = CNX_DEBUT;
    
    if (theConnection) {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
//        NSLog(@"dans the Connexion 1");
        receivedData = [[NSMutableData data] retain];
//        NSLog(@"dans the Connexion 2");
    } else { // Avec le if (theConnection) {
        // Inform the user that the connection failed.
        [alertAttenteTestCnx dismissWithClickedButtonIndex:0 animated:YES];

        iEtatConnexion = CNX_BAD;
        UIAlertView *alert = [[[UIAlertView alloc] 
                               initWithTitle:@"Pas de connexion"
                               message:@"Impossible de se connecter au serveur BDPV\nMerci d'activer votre connexion Internet."
                               delegate:self
                               cancelButtonTitle:@"Cancel"
                               otherButtonTitles:nil]
                              autorelease];
        
        [alert show];
    } // Fin du if (theConnection) {
    
} // Fin du - (void)viewDidLoad {



//#########################################################################################################################################################
//#########################################################################################################################################################
#pragma mark -
#pragma mark === Lecture d'une page ou d'une URL ===

//-------------------------------------------------------------------------------------------------------------------------------
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere
//    NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);
    iEtatConnexion = CNX_EN_COURS_PARSING;

    [alertAttenteTestCnx dismissWithClickedButtonIndex:0 animated:YES];
    
    
        //--------------
     // Lancement du parsing XML
     NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:receivedData];
    //     NSLog(@"Ici xmlParser contient le contenu data qui a été téléchargé");
    
    
     //---------------------------------------------------
     //Set delegate
//     NSLog(@"On indique qui va traiter le retour XML");
     [xmlParser setDelegate:self];
     
//     NSLog(@"Parse du XML");
     
     //Start parsing the XML file.
     BOOL success = [xmlParser parse];
     
    
     // A PRIORI PLANTE - NSLog(@"TODO - POUR INFOS : Rajout d'un release sur le xmlParser.");
     // A PRIORI PLANTE - [xmlParser release];

     if(success) {
             //---------------------------------------------------------------------------------------------------        
            iEtatConnexion = CNX_OK;
            UIAlertView *alert;
            switch (iCodeRetour)
            {
                case -1:
                    alert = [[[UIAlertView alloc] 
                              initWithTitle:@"Version iBDPV obsolète"
                              message:[NSString  stringWithFormat:@"Il est nécessaire de télécharger la nouvelle version (v%@).",Num_version_act]
                              delegate:self
                              cancelButtonTitle:@"Plus tard"
                              otherButtonTitles:@"Télécharger",nil]
                             autorelease];
                    [alert show];
                    iEtatConnexion = CNX_VERSION_OBSOLETE;
                    break;
                case 0:
                    alert = [[[UIAlertView alloc] 
                              initWithTitle:@"Nouvelle version iBDPV"
                              message:[NSString stringWithFormat:@"Une version plus récente (v%@) est disponible.",Num_version_act]
                              delegate:self
                              cancelButtonTitle:@"Plus tard"
                              otherButtonTitles: @"Télécharger",nil]
                             autorelease];
                    [alert show];
                    break;
                    
                case 1:
                    //                NSLog (@"Version upToDate - Version officielle sur appStore");
                    break;
                    
                case 2:
                    alert = [[[UIAlertView alloc] 
                              initWithTitle:@"version iBDPV béta"
                              message:@"Félicitation, vous utilisez une version béta, non disponible actuellement."
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles: nil]
                             autorelease];
                    [alert show];
                    break;
                    
                case -99:
                    alert = [[[UIAlertView alloc] 
                              initWithTitle:@"Erreur"
                              message:[NSString stringWithFormat:@"Erreur inconnue (%@) renvoyée par le serveur BDPV.fr\nMerci d'envoyer un mail à contact@ibdpv.fr",sTexte_erreur]
                              delegate:self
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil]
                             autorelease];
                    [alert show];
                    iEtatConnexion = CNX_BAD;
                    break;
                    
                default:
                    alert = [[[UIAlertView alloc] 
                              initWithTitle:@"Erreur inconnue"
                              message:[NSString stringWithFormat:@"Erreur inconnue renvoyée par le serveur BDPV.fr\nMerci d'envoyer un mail à contact@ibdpv.fr"]
                              delegate:self
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil]
                             autorelease];
                    [alert show];
                    iEtatConnexion = CNX_BAD;
                    break;
            } // Fin du switch (code_retour)
        
     }  else { // Avec le if(success)
         UIAlertView *alert = [[[UIAlertView alloc] 
                                initWithTitle:@"Erreur parsing XML"
                                message:@"Problème d'extraction du XML"
                                delegate:self
                                cancelButtonTitle:@"Annuler"
                                otherButtonTitles:nil]
                               autorelease];
         [alert show];
         iEtatConnexion = CNX_BAD;
     } // fin du if(success)
    
    
    // release the connection, and the data object
    [connection release];
    [receivedData release];
    
} // Fin du - (void)connectionDidFinishLoading:(NSURLConnection *)connection


//-------------------------------------------------------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    // receivedData is an instance variable declared elsewhere.
    [receivedData setLength:0];
    iEtatConnexion = CNX_DEBUT;

} // Fin du - (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response


//-------------------------------------------------------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [receivedData appendData:data];
    iEtatConnexion = CNX_EN_COURS_DOWNLOAD;

}// Fin du - (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data


//-------------------------------------------------------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error

{
    // release the connection, and the data object
    [connection release];
    
    // receivedData is declared as a method instance elsewhere
    [receivedData release];

    
    // inform the user
    //NSLog(@"Connection failed! Error - %@ %@",[error localizedDescription], [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
    iEtatConnexion = CNX_BAD;

    
    [alertAttenteTestCnx dismissWithClickedButtonIndex:0 animated:YES];
     
    UIAlertView *alert = [[[UIAlertView alloc] 
                           initWithTitle:@"Pas de connexion"
                           message:@"Impossible de se connecter au serveur BDPV\nMerci d'activer votre connexion Internet."
                           delegate:self
                           cancelButtonTitle:@"Cancel"
                           otherButtonTitles:nil]
                          autorelease];
    
    
    [alert show];
        
} // Fin du - (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error


//#########################################################################################################################################################
//#########################################################################################################################################################
#pragma mark -
#pragma mark === Fin de vie de la classe et de la windows. ===

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
    [self.userData release];
    [super dealloc];
} // Fin du - (void)dealloc {


//-------------------------------------------------------------------------------------------------------------------------------
-(void)viewWillAppear:(BOOL)animated {
	[self.navigationController setToolbarHidden:YES animated:NO];
    [self.navigationController setNavigationBarHidden:YES];      
	[super viewWillAppear:animated];
} // Fin du -(void)viewWillAppear:(BOOL)animated {




//#########################################################################################################################################################
//#########################################################################################################################################################
#pragma mark -
#pragma mark === Actions du menu ===
//-------------------------------------------------------------------------------------------------------------------------------
-(void)actEstimer:(id)sender {
    // IMPORTANT  - Faire une fonction pour les UIAlertView (il y en a 2 qui se répète)
    if (iEtatConnexion == CNX_VERSION_OBSOLETE) {
        UIAlertView *alert = [[[UIAlertView alloc] 
                               initWithTitle:@"Version iBDPV obsolète"
                               message:[NSString  stringWithFormat:@"Il est nécessaire de télécharger la nouvelle version."]
                               delegate:self
                               cancelButtonTitle:@"Plus tard"
                               otherButtonTitles:@"Télécharger",nil]
                              autorelease];
        [alert show];       
    } // Fin du if (iEtatConnexion == CNX_VERSION_OBSOLETE) {
    else if (iEtatConnexion == CNX_BAD) {
        UIAlertView *alert = [[[UIAlertView alloc] 
                               initWithTitle:@"IMPOSSIBLE"
                               message:@"Pas de connexion Internet"
                               delegate:self
                               cancelButtonTitle:@"Annuler"
                               otherButtonTitles:nil]
                              autorelease];
        
        
        [alert show];                    
    } else  { // Avec le else if (iEtatConnexion == CNX_BAD) {
        Estim1GPSViewController *newController=[[Estim1GPSViewController alloc] init];
        newController.menuOrigin=@"Estim";
        newController.userData=self.userData;
        [self.navigationController pushViewController:newController animated:YES];
        [newController release];
    }  // Fin du else if (iEtatConnexion == CNX_BAD) {

	
} // Fin du -(void)actEstimer:(id)sender {


//-------------------------------------------------------------------------------------------------------------------------------
-(void)actFichesProches:(id)sender {
    
    if (iEtatConnexion == CNX_VERSION_OBSOLETE) {
        UIAlertView *alert = [[[UIAlertView alloc] 
                    initWithTitle:@"Version iBDPV obsolète"
                    message:[NSString  stringWithFormat:@"Il est nécessaire de télécharger la nouvelle version."]
                    delegate:self
                    cancelButtonTitle:@"Plus tard"
                    otherButtonTitles:@"Télécharger",nil]
                    autorelease];
        [alert show];       
    } else if (iEtatConnexion == CNX_BAD) {
        UIAlertView *alert = [[[UIAlertView alloc] 
                               initWithTitle:@"Fonction non disponible"
                               message:@"Pas de connexion Internet"
                               delegate:self
                               cancelButtonTitle:@"Annuler"
                               otherButtonTitles:nil]
                              autorelease];
        
        
        [alert show];                    
    } else  {
        
        if (self.userData.longitude==0 || self.userData.latitude==0) {
            Estim1GPSViewController *newController=[[Estim1GPSViewController alloc] init];
            newController.menuOrigin=@"FichesProches";
            newController.userData=self.userData;
            /*[newController.navigationController setNavigationBarHidden:NO];
            [newController.navigationController setNavigationBarHidden:NO];
            UIBarButtonItem *backButton = [[[UIBarButtonItem alloc] initWithTitle:@"Retour" style:UIBarButtonItemStyleBordered target:nil action:nil] autorelease];
            newController.navigationItem.backBarButtonItem = backButton;*/
            [self.navigationController pushViewController:newController animated:YES];
            [newController release];        
        }
        else {
            //Sites Proches
            FichesProchesTableViewController *newController=[[FichesProchesTableViewController alloc] init];
            newController.userData=self.userData;
            /*[newController.navigationController setNavigationBarHidden:NO];
            [newController.navigationController setNavigationBarHidden:NO];
            UIBarButtonItem *backButton = [[[UIBarButtonItem alloc] initWithTitle:@"Retour" style:UIBarButtonItemStyleBordered target:nil action:nil] autorelease];
            newController.navigationItem.backBarButtonItem = backButton;*/
            [self.navigationController pushViewController:newController animated:YES];
            [newController release];
        }
               
    }   
    
} // Fin du -(void)actFichesProches:(id)sender {


//-------------------------------------------------------------------------------------------------------------------------------
-(void)actOptions:(id)sender {
    //IMPORTANT - En version 2.0
} // Fin du -(void)actOptions:(id)sender {


//-------------------------------------------------------------------------------------------------------------------------------
-(void)actAPropos:(id)sender {

    
    
    AproposViewController *newController=[[AproposViewController alloc] init];
    newController.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;  
    [self.navigationController pushViewController:newController animated:YES];
    [newController release];        

    
     /* ALL Code
     AproposViewController *newController=[[AproposViewController alloc] init];
     newController.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
     
     //Navigation Controller
     UINavigationController *navController=[[UINavigationController alloc] initWithRootViewController:newController];
     [newController release];
     [self presentModalViewController:navController animated:YES];
     [navController release];
 */
} // Fin du -(void)actAPropos:(id)sender {


//#########################################################################################################################################################
//#########################################################################################################################################################
#pragma mark -
#pragma mark === AlertView ===

//-------------------------------------------------------------------------------------------------------------------------------
// Cette fonction est appelée chaque fois qu'un bouton est appuyé dans une AlertView
- (void) alertView:(UIAlertView *)_actionSheet clickedButtonAtIndex:(NSInteger)_buttonIndex {
    
   //POUR CHOSIR LA ALERTBOX if ([_actionSheet.title isEqualToString:@"Nouvelle version iBDPV disponible"]) {
        if (_buttonIndex == 1) {
            // do something for second button
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/app/ibdpv/id385946729?mt=8"]];
            // URL qui marche pour une appli -> [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/fr/app/spacemap/id391743932?mt=8"]];
        } // Fin du if (_buttonIndex == 1) {
   // } // Fin du  if ([_actionSheet.title isEqualToString:@"Nouvelle version iBDPV disponible"]) {
    
} // Fin du - (void) alertView:(UIAlertView *)_actionSheet clickedButtonAtIndex:(NSInteger)_buttonIndex {



//#########################################################################################################################################################
//#########################################################################################################################################################
#pragma mark -
#pragma mark === Parser XML ===


//-------------------------------------------------------------------------------------------------------------------------------
// Start tag
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
	attributes:(NSDictionary *)attributeDict {
	
	//NSLog(@"didStartElement: %@",elementName);
	
	if ([elementName isEqualToString:@"base_complete"]) { //sites
		// Init Sites
		// NSLog(@"On a le code base_complete");
	} // if ([elementName isEqualToString:@"base_complete"]) { //sites

	
} // Fin du - (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName


//-------------------------------------------------------------------------------------------------------------------------------
// Values
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	
	//NSLog(@"foundCharacters: %@",string);
	
	if (!currentStringValue) {
        // currentStringValue is an NSMutableString instance variable
        currentStringValue = [[NSMutableString alloc] initWithCapacity:50];
    } // Fin du if (!currentStringValue) {
	//NSLog(@"String: %@",string);
    [currentStringValue appendString:string];		
    
} // Fin du - (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {

//-------------------------------------------------------------------------------------------------------------------------------
// End tag
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
	//NSLog(@"didEndElement ICI 1: %@",elementName);
	
    if ([elementName isEqualToString:@"Num_version_act"]) {	
		Num_version_act =[currentStringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//        NSLog(@"Num_version_act: %@",Num_version_act);
	}
	else if ([elementName isEqualToString:@"Num_version_min"]) {	
		Num_version_min =[currentStringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//        NSLog(@"Num_version_min: %@",Num_version_min);
	}
	else if ([elementName isEqualToString:@"Texte_erreur"]) {	
		sTexte_erreur =[currentStringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//        NSLog(@"Texte_erreur: %@",sTexte_erreur);
	}	else if ([elementName isEqualToString:@"Code_retour"]) {
		sCodeRetour =[currentStringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		iCodeRetour =sCodeRetour.intValue;
//        NSLog(@"Code_retour: %@",sCodeRetour);
    
    } // Fin du if ([elementName isEqualToString:@"code_retour"]) {

	[currentStringValue release];
	currentStringValue=nil;
	
} // Fin du - (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName


@end
