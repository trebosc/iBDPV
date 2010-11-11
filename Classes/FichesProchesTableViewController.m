//
//  FichesProchesTableViewController.m
//  iBDPV
// JMD & DTR


#import "FichesProchesTableViewController.h"
#import "AsyncImageView.h"
#import "TableViewControllerFromURL.h"

@implementation FichesProchesTableViewController

//#########################################################################################################################################################
//#########################################################################################################################################################
#pragma mark -
#pragma mark synthesize
@synthesize lblNbFiches, userData, loadingURL, arrFiches, xmlFiche, booXMLLoading,indexToLoad, dicoPhoto, activityIndicator;

//#########################################################################################################################################################
//#########################################################################################################################################################
#pragma mark -
#pragma mark URLs de test
/*
http://www.bdpv.fr/fiche_utilisateur.php?util=nico81
http://www.bdpv.fr/image/install/nico81.jpg

Liste d'utilisateurs
http://www.bdpv.fr/ajax/iBDPV/l.php?api_sig=d3927ac7d93e94701882182067fbd70c&api_demandeur=iBDPV&uid=090392&l=43.5140120623541&o=1.51143550872803&d=100&n=10&i=0
 
 */

#pragma mark -
#pragma mark Initialization

-(NSURL *)buildSitesProchesURL {
    
    // Génération de l'url
    NSString *sParam = @"l.php";
    NSMutableArray  *myArray = [NSMutableArray arrayWithObjects:
                                [NSString  stringWithFormat:@"l=%f",self.userData.latitude],
                                [NSString  stringWithFormat:@"o=%f",self.userData.longitude],
                                [NSString  stringWithFormat:@"d=%d",self.userData.distance],
                                [NSString  stringWithFormat:@"n=%d",LIMIT],
                                [NSString  stringWithFormat:@"i=%d",self.indexToLoad],
                                nil];
    NSString *sUrl =[self.userData genere_requete:myArray fichier_php:sParam];
    
    
    return [[[NSURL alloc] initWithString:sUrl] autorelease];
    
} // Fin du -(NSURL *)buildSitesProchesURL {

//-------------------------------------------------------------------------------------------------------------------------------
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
        self.tableView.rowHeight=81.0;
    }
    return self;
} // Fin du - (id)initWithStyle:(UITableViewStyle)style {




//#########################################################################################################################################################
//#########################################################################################################################################################

#pragma mark -
#pragma mark === Parser XML ===

/*
<liste_utilisateur>
<utilisateur>
<Id>1</Id>
<Nom>trebosc</Nom>
<Photo>1</Photo>
<Distance>000</Distance>
<Annee_rac>2007</Annee_rac>
<Mois_rac>08</Mois_rac>
<Last_maj_inst>2010-04-15</Last_maj_inst>
<Last_maj_prod>2010-08-30</Last_maj_prod>
</utilisateur>
*/

//-------------------------------------------------------------------------------------------------------------------------------
// Start tag
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
	attributes:(NSDictionary *)attributeDict {
	
	if ([elementName isEqualToString:@"liste_utilisateur"]) {
       // RIen à faire - Debut du code                                                 
		
	}
    else if ([elementName isEqualToString:@"utilisateur"]) {
        //Initialisation d'un objet Fiche
        xmlFiche=[[Fiche alloc] init];
    } // Fin du else if ([elementName isEqualToString:@"utilisateur"]) {
    
    
} // Fin du - (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName


//-------------------------------------------------------------------------------------------------------------------------------
// Values
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	
	if (!currentStringValue) {
        // currentStringValue is an NSMutableString instance variable
        currentStringValue = [[NSMutableString alloc] initWithCapacity:50];
    } // FIn du if (!currentStringValue) {

    [currentStringValue appendString:string];		
    
} // Fin du - (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {


//-------------------------------------------------------------------------------------------------------------------------------
// End tag
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    //Sauvegarde des données de l'utilisateur
    
    //On évite la racine
    if ([elementName isEqualToString:@"liste_utilisateur"]) return; 
    
    if ([elementName isEqualToString:@"utilisateur"]) {
        //On ajoute la fiche au tableau des fiches
        [arrFiches addObject:xmlFiche];
        //Libération de la fiche courante
        [xmlFiche release];
        xmlFiche=nil;
    }
    else if ([elementName isEqualToString:@"Id"]) {
        xmlFiche.Id=[[currentStringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] intValue];
    }
    
    else if ([elementName isEqualToString:@"Nom"]) {
        xmlFiche.nom=[currentStringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([elementName isEqualToString:@"Photo"]) {
        xmlFiche.photo=[currentStringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
           }
    else if ([elementName isEqualToString:@"Distance"]) {
        xmlFiche.distance=[[currentStringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] intValue];
    }
    else if ([elementName isEqualToString:@"Annee_rac"]) {
        xmlFiche.annee_rac=[[currentStringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] intValue];
    }
    else if ([elementName isEqualToString:@"Mois_rac"]) {
        xmlFiche.mois_rac=[[currentStringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] intValue];
    }
    else if ([elementName isEqualToString:@"Last_maj_inst"]) {
        xmlFiche.last_maj_inst=[currentStringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([elementName isEqualToString:@"Last_maj_prod"]) {
        xmlFiche.last_maj_prod=[currentStringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
    [currentStringValue release];
	currentStringValue=nil;
	
} // Fin du - (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName



//#########################################################################################################################################################
//#########################################################################################################################################################
#pragma mark -
#pragma mark === Generation des URL ===
//-------------------------------------------------------------------------------------------------------------------------------
-(NSURL *)buildFicheDetailURL:(int)userID {
    

    // Génération de l'url
    NSString *sParam = @"f.php";
    NSMutableArray  *myArray = [NSMutableArray arrayWithObjects:
                                [NSString  stringWithFormat:@"i=%d",userID],
                                nil];
    NSString *sUrl = [self.userData genere_requete:myArray fichier_php:sParam];
    
    //NSLog(@"%@",sUrl); 
    
    return [[[NSURL alloc] initWithString:sUrl] autorelease];
    
} // Fin du -(NSURL *)buildFicheDetailURL:(int)userID {


//#########################################################################################################################################################
//#########################################################################################################################################################
#pragma mark -
#pragma mark === Chargement et creation de la vue ===

//-------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    //TODO - Normal de le faire avant ????
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    
    dicoPhoto=[[NSMutableDictionary alloc] init];
    indexToLoad=0;  // Premier chargement
    
} // Fin du - (void)viewDidLoad {




//-------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (indexToLoad==0) {
        
        //Premier chargement
        
        // Lancement du parsing XML (mode SYNCHRONE)
        NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:[self buildSitesProchesURL]];
        NSLog(@"TODO : Possibilité de mettre un timeout ???");
        NSLog(@"TODO : Si erreur de chargement sur timeout ou autre, par quelle fonction estce capté ?");
      
        
        //Set delegate
        [xmlParser setDelegate:self];
        
        //NSLog(@"Loading first page synchrone. XML Parsing ...");
        
        //Start parsing the XML file.
        booXMLLoading=YES;
        BOOL success = [xmlParser parse];
        
        if(success) {
            //NSLog(@"Loading first page synchrone. No Errors:%d - %d",userData.nbInstallationProche/LIMIT,userData.nbInstallationProche % LIMIT);
        } else { // Avec le if(success) {
            NSLog(@"TODO - Mettre un message en français et traiter les erreurs - Loading first page synchrone. Parsing Error.");
            
            UIAlertView *alert = [[[UIAlertView alloc] 
                                   initWithTitle:@"Error"
                                   message:@"Loading first page synchrone. Parsing Error."
                                   delegate:self
                                   cancelButtonTitle:@"Cancel"
                                   otherButtonTitles:nil]
                                  autorelease];
            [alert show];
            
        } // Fin du if(success) {
        
        booXMLLoading=NO;
        indexToLoad=LIMIT;
        
        
    } // Fin du if (indexToLoad==0) {
    
} // Fin du - (void)viewWillAppear:(BOOL)animated {

//-------------------------------------------------------------------------------------------------------------------------------
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    [super loadView];
    NSLog(@"TODO - ???? le super doit être appelé avant ou après ?");

    
    // Affichage de la barre de navigation
	[self.navigationController setNavigationBarHidden:NO];
	
	//Titre
	self.title=@"Fiches proches";
	
	//Désactivation du bouton Back
	[self.navigationItem setHidesBackButton:YES];
    
	//Affichage de la toolBar du Navigation Controller
	[self.navigationController setToolbarHidden:NO animated:YES];
    
    //Création des boutons
	//Retour
	UIBarButtonItem *btnBackItem=[[UIBarButtonItem alloc]initWithTitle:@"Retour" style:UIBarButtonItemStyleBordered target:self action:@selector(actBack:)];
	//Espacement
	UIBarButtonItem *flexibleSpaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	//Nb Fiches
    self.lblNbFiches=[[UILabel alloc] initWithFrame:CGRectMake(0 , 0, 180, 20)];
    self.lblNbFiches.text=@"Nb fiches: ";
    self.lblNbFiches.textColor=[UIColor whiteColor];
    self.lblNbFiches.backgroundColor=[UIColor clearColor];
    self.lblNbFiches.textAlignment=UITextAlignmentCenter;
    
    UIBarButtonItem *lblNbFichesItem=[[UIBarButtonItem alloc] initWithCustomView:lblNbFiches];
	
    //Activity Indicator
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(190.0, 0.0, 20.0, 20.0)];
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    activityIndicator.hidesWhenStopped = YES;
    
    UIBarButtonItem *btnActivityIndicator=[[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
        
	// Ajout des boutons dans la toolBar
	self.toolbarItems=[NSArray arrayWithObjects:btnBackItem,flexibleSpaceButtonItem,lblNbFichesItem,flexibleSpaceButtonItem,flexibleSpaceButtonItem,btnActivityIndicator, nil];
    
	[btnBackItem release];
	[flexibleSpaceButtonItem release];
    [lblNbFichesItem release];
    [btnActivityIndicator release];
    
    
   
    //Initialisation du tableau des fiches
    self.arrFiches=[[NSMutableArray alloc] initWithCapacity:self.userData.nbInstallationProche]; 
    
} // Fin du - (void)loadView {


//#########################################################################################################################################################
//#########################################################################################################################################################
#pragma mark -
#pragma mark === Table view data source ===

//-------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
} // Fin du - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {


//-------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    self.lblNbFiches.text=[NSString stringWithFormat:@"%@ %d / %d",@"Nb fiches: ", [arrFiches count],self.userData.nbInstallationProche];
    
    return [arrFiches count];
} // Fin de - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {



//-------------------------------------------------------------------------------------------------------------------------------
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    #define MAINLABEL_TAG 1 
    #define DETAILLABEL_TAG 2
    #define PHOTO_TAG 999
    
    Fiche *curFiche=[arrFiches objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"CellFicheProche";

    
    UILabel *mainLabel;
    UILabel *detailLabel;
    
    AsyncImageView *asyncImage;
    NSString *photoURL;
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
            
            cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
            
            mainLabel = [[[UILabel alloc] initWithFrame:CGRectMake(130.0, 5.0, 180.0, 20.0)] autorelease];
            mainLabel.tag = MAINLABEL_TAG; mainLabel.font = [UIFont boldSystemFontOfSize:18.0]; 
            mainLabel.textAlignment = UITextAlignmentLeft; 
            mainLabel.textColor = [UIColor blackColor]; 
            mainLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin ; 
            mainLabel.opaque=YES;
            [cell.contentView addSubview:mainLabel];
            
            detailLabel = [[[UILabel alloc] initWithFrame:CGRectMake(130.0, 25.0, 180.0, tableView.rowHeight-25.0)] autorelease];
            detailLabel.tag = DETAILLABEL_TAG; 
            detailLabel.font = [UIFont systemFontOfSize:14.0]; 
            detailLabel.textAlignment = UITextAlignmentLeft; 
            detailLabel.textColor = [UIColor blackColor]; 
            [detailLabel setLineBreakMode:UILineBreakModeWordWrap];
            [detailLabel setNumberOfLines:0];
            detailLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin; 
            detailLabel.opaque=YES;
            [cell.contentView addSubview:detailLabel];
            
        } else { // Avec le if (cell == nil) {

            //Cell reused
            
            mainLabel = (UILabel *)[cell.contentView viewWithTag:MAINLABEL_TAG];
            detailLabel = (UILabel *)[cell.contentView viewWithTag:DETAILLABEL_TAG];
        
            //Photo removing
            AsyncImageView* oldImage = (AsyncImageView*)[cell.contentView viewWithTag:PHOTO_TAG];
            [oldImage removeFromSuperview];
            
            //UIImageView *oldUIV=(UIImageView*)[cell.contentView viewWithTag:PHOTO_TAG];
            //[oldUIV removeFromSuperview];

        } // FIn du if (cell == nil) {

   
    
    
        // Configure the cell...
    
        mainLabel.text=curFiche.nom;
    
        detailLabel.text=[NSString stringWithFormat:@"%d km\nRaccordé le %02d/%d",curFiche.distance,curFiche.mois_rac,curFiche.annee_rac];
    
    
    
    
        
    
        if (curFiche.photo==nil) curFiche.photo=@"_pas_photo.jpg";
    
        photoURL=[NSString stringWithFormat:@"http://www.bdpv.fr/image/install/%@",curFiche.photo];
        NSURL *url = [NSURL URLWithString:photoURL];
    
        CGRect frame;
        frame.size.width=120.0; frame.size.height=tableView.rowHeight;
        frame.origin.x=0; frame.origin.y=0;
        
        //AsyncImageView
        asyncImage = [[[AsyncImageView alloc] initWithFrame:frame] autorelease];
        asyncImage.dicoPhoto=self.dicoPhoto;
        asyncImage.tag = PHOTO_TAG;
    
        [asyncImage loadImageFromURL:url];
        
        [cell.contentView addSubview:asyncImage];
        
   
    
    //Synchronous call - NSData
    /*
     TODO - On conserve ce commentaire (la réponse doit être donnée par Doudou)
    NSData *imgData=[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://www.bdpv.fr/image/install/nico81.jpg"]];
    cell.imageView.image=[UIImage imageWithData:imgData];
    */
    
    //AsyncImage View Class
    /*
     TODO - On conserve ce commentaire (la réponse doit ^être donnée par Doudou)
    CGRect frame;
    frame.size.width=75; frame.size.height=50;
    frame.origin.x=0; frame.origin.y=0;
    AsyncImageView *imgView=[[[AsyncImageView alloc] initWithFrame:frame] autorelease];
    imgView.tag=999;
    [imgView loadImageFromURL:[NSURL URLWithString:@"http://www.bdpv.fr/image/install/nico81.jpg"]];
    
    [cell.contentView addSubview:imgView];
    */
    
    //Next Page loading (asynchrone)
    if ((arrFiches.count<userData.nbInstallationProche) && (indexPath.row==arrFiches.count-1) && (!booXMLLoading)) {
        booXMLLoading=YES;
        [activityIndicator startAnimating];
        
        //NSLog(@"Loading Page: %d",indexToLoad);
        
        // Create the request.
        NSURLRequest *theRequest=[NSURLRequest requestWithURL:[ self buildSitesProchesURL]
                                                  cachePolicy:NSURLRequestUseProtocolCachePolicy
                                              timeoutInterval:20.0];
        
        NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
        
        
        NSLog(@"TODO - Si erreur de timeout ou autres, est-ce que l'utilisateur peut facilement relancer le téléchargement ?");
        NSLog(@"TODO - Mettre un spinner d'attente");

        
        if (theConnection) {
            // Create the NSMutableData to hold the received data.
            // receivedData is an instance variable declared elsewhere.
            
            receivedData = [[NSMutableData data] retain];
            
        } else { // Avec le if (theConnection) {
            // Inform the user that the connection failed.
            NSLog(@"TODO - A mettre dans une popup ? Loading Page: %d ERROR",indexToLoad);
        } // Fin du if (theConnection) {
        
    } // Fin du if ((arrFiches.count<userData.nbInstallationProche) && (indexPath.row==arrFiches.count-1) && (!booXMLLoading)) {

    
    return cell;
} // Fin du - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {


//#########################################################################################################################################################
//#########################################################################################################################################################
#pragma mark -
#pragma mark === Table view delegate ===

//-------------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    
    if ([[arrFiches objectAtIndex:indexPath.row] Id]>0) {
        
        //Fiches proches  UITableViewStylePlain
        TableViewControllerFromURL *newController=[[TableViewControllerFromURL alloc] initWithStyle:UITableViewStyleGrouped];
        newController.title=[[arrFiches objectAtIndex:indexPath.row] nom];
        newController.userData=userData;
        newController.loadingURL=[self buildFicheDetailURL:[[arrFiches objectAtIndex:indexPath.row] Id]];
        [self.navigationController pushViewController:newController animated:YES];
        [newController release];
    } // FIn du if ([[arrFiches objectAtIndex:indexPath.row] Id]>0) {
} // Fin du - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {


//#########################################################################################################################################################
//#########################################################################################################################################################
#pragma mark -
#pragma mark === Memory management ===

//-------------------------------------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
    NSLog(@"TODO - MEMORY WARNING!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    
    
} // Fin du - (void)didReceiveMemoryWarning {


//-------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
} // Fin du - (void)viewDidUnload {



//-------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [xmlFiche release];
    [lblNbFiches release];
    [arrFiches release];
    [activityIndicator release];
    [super dealloc];
} // Fin du - (void)dealloc {



//#########################################################################################################################################################
//#########################################################################################################################################################
#pragma mark -
#pragma mark === Actions ===
//-------------------------------------------------------------------------------------------------------------------------------
//Action Back
-(void)actBack:(id)sender {
	
	//Retour au controlleur précédent
	[self.navigationController popViewControllerAnimated:YES];
} // Fin du -(void)actBack:(id)sender {



//#########################################################################################################################################################
//#########################################################################################################################################################
#pragma mark -
#pragma mark === Connection Asynchrone ===
//-------------------------------------------------------------------------------------------------------------------------------
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    
    //--------------
    // Lancement du parsing XML
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:receivedData];
    
    //Set delegate
    [xmlParser setDelegate:self];
    
    NSLog(@"Parsing XML");
    
    //Start parsing the XML file.
    booXMLLoading=YES;
    BOOL success = [xmlParser parse];
    
    if (success){
        //NSLog(@"No Errors:%d - %d",userData.nbInstallationProche/LIMIT,userData.nbInstallationProche % LIMIT);
    
        indexToLoad = indexToLoad + LIMIT;
        //NSLog(@"Next index; %d COUNT: %d",indexToLoad,arrFiches.count);
        booXMLLoading=NO;
        
        [self.tableView reloadData];
    } else { // Avec le if (success){
        NSLog(@"TODO - Traiter l'erreur  - Parsing XML asynchrone ERROR");
        
        UIAlertView *alert = [[[UIAlertView alloc] 
                               initWithTitle:@"Error"
                               message:@"Parsing XML asynchrone ERROR"
                               delegate:self
                               cancelButtonTitle:@"Cancel"
                               otherButtonTitles:nil]
                              autorelease];
        [alert show];
        
    } // Fin du if (success){
        
    
    
    [activityIndicator stopAnimating];
    
    // release the connection, and the data object
    [connection release];
    [receivedData release];
    
    
} // Fin du - (void)connectionDidFinishLoading:(NSURLConnection *)connection

//************************************************************************************
//************************************************************************************
//-------------------------------------------------------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response

{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    // receivedData is an instance variable declared elsewhere.
    [receivedData setLength:0];
    
}

//************************************************************************************
//************************************************************************************
//-------------------------------------------------------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data

{
    
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [receivedData appendData:data];
    
} // Fin du - (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data


//************************************************************************************
//************************************************************************************
//-------------------------------------------------------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error

{
    // release the connection, and the data object
    [connection release];
    
    // receivedData is declared as a method instance elsewhere
    [receivedData release];
    
    // inform the user
    
    UIAlertView *alert = [[[UIAlertView alloc] 
                           initWithTitle:@"Erreur lors du chargement"
                           message:@"Mauvaise réception des données\nMerci de re-essayer à nouveau."
                           delegate:self
                           cancelButtonTitle:@"Cancel"
                           otherButtonTitles:nil]
                          autorelease];
    
    [alert show];
        
} // Fin du - (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error

//************************************************************************************
//************************************************************************************

@end

