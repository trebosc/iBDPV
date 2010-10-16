//
//  FichesProchesTableViewController.m
//  iBDPV
//
//  Created by jmd on 25/08/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "FichesProchesTableViewController.h"
#import "AsyncImageView.h"
#import "FicheDetailViewController.h"

@implementation FichesProchesTableViewController

#pragma mark -
#pragma mark synthesize
@synthesize lblNbFiches, userData, arrFiches, xmlFiche, booXMLLoading,indexToLoad, dicoPhoto, activityIndicator;

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


- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
        self.tableView.rowHeight=81.0;
    }
    return self;
}




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

// Start tag
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
	attributes:(NSDictionary *)attributeDict {
	
	if ([elementName isEqualToString:@"liste_utilisateur"]) {
                                                        
		
	}
    else if ([elementName isEqualToString:@"utilisateur"]) {
        //Initialisation d'un objet Fiche
        xmlFiche=[[Fiche alloc] init];
    }
    
    
}

// Values
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	
	if (!currentStringValue) {
        // currentStringValue is an NSMutableString instance variable
        currentStringValue = [[NSMutableString alloc] initWithCapacity:50];
    }

    [currentStringValue appendString:string];		
    
}

//-------------------------------------------------------------------------
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







#pragma mark -
#pragma mark === View lifecycle ===
-(NSURL *)buildSitesProchesURL {
    // Génération de la signature pour le lien http
    NSString *api_sig_a_convertir;
    api_sig_a_convertir = [NSString  stringWithFormat:@"ibdpv_20100712api_demandeuriBDPVd%di%dl%fn%do%fuid%@",
                           self.userData.distance,
                           indexToLoad,                        // i: index of the first row
                           self.userData.latitude,
                           LIMIT,                              // n: number of rows to load
                           self.userData.longitude,
                           self.userData.uniqueIdentifierMD5
                           ];
    
    NSString *api_sig;
    api_sig = [self.userData md5:api_sig_a_convertir];
    
    NSString *sUrl = [NSString  stringWithFormat:@"http://www.bdpv.fr/ajax/iBDPV/l.php?api_sig=%@&api_demandeur=iBDPV&uid=%@&l=%f&o=%f&d=%d&n=%d&i=%d",
                      api_sig,
                      self.userData.uniqueIdentifierMD5,
                      self.userData.latitude,
                      self.userData.longitude,
                      self.userData.distance,
                      LIMIT,                                    // n: number of rows to load
                      indexToLoad                               // i: index of the first row
                      ]; 
    
    NSLog(@"%@",sUrl); 
   
    return [[[NSURL alloc] initWithString:sUrl] autorelease];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    
    dicoPhoto=[[NSMutableDictionary alloc] init];
    indexToLoad=0;  // Premier chargement
    
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (indexToLoad==0) {
        
        //Premier chargement
        
        // Lancement du parsing XML (mode SYNCHRONE)
        NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:[self buildSitesProchesURL]];
        
        
        //Set delegate
        [xmlParser setDelegate:self];
        
        NSLog(@"Loading first page synchrone. XML Parsing ...");
        
        //Start parsing the XML file.
        booXMLLoading=YES;
        BOOL success = [xmlParser parse];
        
        if(success)
            NSLog(@"Loading first page synchrone. No Errors:%d - %d",userData.nbInstallationProche/LIMIT,userData.nbInstallationProche % LIMIT);
        else {
            NSLog(@"Loading first page synchrone. Parsing Error.");
            
            UIAlertView *alert = [[[UIAlertView alloc] 
                                   initWithTitle:@"Error"
                                   message:@"Loading first page synchrone. Parsing Error."
                                   delegate:self
                                   cancelButtonTitle:@"Cancel"
                                   otherButtonTitles:nil]
                                  autorelease];
            [alert show];
            
        } // 
        
        booXMLLoading=NO;
        indexToLoad=LIMIT;
        
        
    }
    
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    [super loadView];
    
    
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
    

	
}

#pragma mark -
#pragma mark === Table view data source ===

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    self.lblNbFiches.text=[NSString stringWithFormat:@"%@ %d / %d",@"Nb fiches: ", [arrFiches count],self.userData.nbInstallationProche];
    
    return [arrFiches count];
}


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
        
        }
        
        
    else {
        //Cell reused
        
        mainLabel = (UILabel *)[cell.contentView viewWithTag:MAINLABEL_TAG];
        
        detailLabel = (UILabel *)[cell.contentView viewWithTag:DETAILLABEL_TAG];
        
        
            
        //Photo removing
        AsyncImageView* oldImage = (AsyncImageView*)[cell.contentView viewWithTag:PHOTO_TAG];
        
        [oldImage removeFromSuperview];
        
        //UIImageView *oldUIV=(UIImageView*)[cell.contentView viewWithTag:PHOTO_TAG];
        //[oldUIV removeFromSuperview];

        }
   
    
    
        // Configure the cell...
    
        mainLabel.text=curFiche.nom;
    
        detailLabel.text=[NSString stringWithFormat:@"Id: %d - Dist: %d - Prod: %@",curFiche.Id,curFiche.distance,curFiche.last_maj_prod];
        
    
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
    NSData *imgData=[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://www.bdpv.fr/image/install/nico81.jpg"]];
    cell.imageView.image=[UIImage imageWithData:imgData];
    */
    
    //AsyncImage View Class
    /*
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
        
        NSLog(@"Loading Page: %d",indexToLoad);
        
        // Create the request.
        NSURLRequest *theRequest=[NSURLRequest requestWithURL:[self buildSitesProchesURL]
                                                  cachePolicy:NSURLRequestUseProtocolCachePolicy
                                              timeoutInterval:60.0];
        
        NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
        
        if (theConnection) {
            // Create the NSMutableData to hold the received data.
            // receivedData is an instance variable declared elsewhere.
            
            receivedData = [[NSMutableData data] retain];
            
        } else {
            // Inform the user that the connection failed.
            NSLog(@"Loading Page: %d ERROR",indexToLoad);
        }
        
    }
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
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
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark === Table view delegate ===

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    
    if ([[arrFiches objectAtIndex:indexPath.row] Id]>0) {
        
        //Fiches proches  UITableViewStylePlain
        FicheDetailViewController *newController=[[FicheDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
        newController.title=[[arrFiches objectAtIndex:indexPath.row] nom];
        newController.userData=userData;
        
        newController.userID=[[arrFiches objectAtIndex:indexPath.row] Id];
        
        [self.navigationController pushViewController:newController animated:YES];
        [newController release];
        
        
    }
    
    
}


#pragma mark -
#pragma mark === Memory management ===

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
    NSLog(@"MEMORY WARNING!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    
    
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [xmlFiche release];
    [lblNbFiches release];
    [arrFiches release];
    [activityIndicator release];
    [super dealloc];
}


#pragma mark -
#pragma mark === Actions ===
//Action Back
-(void)actBack:(id)sender {
	
	//Retour au controlleur précédent
	[self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark === Connection Asynchrone ===
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
        NSLog(@"No Errors:%d - %d",userData.nbInstallationProche/LIMIT,userData.nbInstallationProche % LIMIT);
    
        indexToLoad = indexToLoad + LIMIT;
        NSLog(@"Next index; %d COUNT: %d",indexToLoad,arrFiches.count);
        booXMLLoading=NO;
        
        [self.tableView reloadData];
    }
    else {
        NSLog(@"Parsing XML asynchrone ERROR");
        
        UIAlertView *alert = [[[UIAlertView alloc] 
                               initWithTitle:@"Error"
                               message:@"Parsing XML asynchrone ERROR"
                               delegate:self
                               cancelButtonTitle:@"Cancel"
                               otherButtonTitles:nil]
                              autorelease];
        [alert show];
        
    } // 
        
    
    
    [activityIndicator stopAnimating];
    
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
    
}

//************************************************************************************
//************************************************************************************
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data

{
    
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [receivedData appendData:data];
    
}




//************************************************************************************
//************************************************************************************
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error

{
    // release the connection, and the data object
    [connection release];
    
    // receivedData is declared as a method instance elsewhere
    [receivedData release];
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",[error localizedDescription],
          [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
    
    
    
    UIAlertView *alert = [[[UIAlertView alloc] 
                           initWithTitle:@"Bad connexion XML"
                           message:@"Connexion BAD XML"
                           delegate:self
                           cancelButtonTitle:@"Cancel"
                           otherButtonTitles:nil]
                          autorelease];
    
    
    [alert show];
    
    
}
//************************************************************************************
//************************************************************************************

@end

