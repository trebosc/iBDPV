//
//  TableViewControllerFromURL.m
//  iBDPV
// JMD & DTR


#import "TableViewControllerFromURL.h"
#import "FichesProchesTableViewController.h"

@implementation TableViewControllerFromURL

@synthesize userData, loadingURL, dicoPhoto;
 
//#########################################################################################################################################################
//#########################################################################################################################################################
#pragma mark -
#pragma mark === View lifecycle ===

/*
 //-------------------------------------------------------------------------------------------------------------------------------
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    } // Fin du if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {

    return self;
 } // Fin du - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

*/

//-------------------------------------------------------------------------------------------------------------------------------
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    [super loadView];
    
    //NSLog(@"loadView: %@",self.userData);
    
	// Affichage de la barre de navigation
	[self.navigationController setNavigationBarHidden:NO];
	
	//Désactivation du bouton Back
	[self.navigationItem setHidesBackButton:YES];
    
	//Affichage de la toolBar du Navigation Controller
	[self.navigationController setToolbarHidden:NO animated:YES];
	
	//Création des boutons
	//Retour
	UIBarButtonItem *btnBackItem=[[UIBarButtonItem alloc]initWithTitle:@"Retour" style:UIBarButtonItemStyleBordered target:self action:@selector(actBack:)];
	//Espacement
	UIBarButtonItem *flexibleSpaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	
	// Ajout des boutons dans la toolBar
	self.toolbarItems=[NSArray arrayWithObjects:btnBackItem,flexibleSpaceButtonItem,nil];
    
	[btnBackItem release];
	[flexibleSpaceButtonItem release];
	

    // Chargement du XML
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:self.loadingURL];
    NSLog(@"TODO : Possibilité de mettre un timeout ???");
    NSLog(@"TODO : Si erreur de chargement sur timeout ou autre, par quelle fonction estce capté ?");

    
    //Set delegate
    [xmlParser setDelegate:self];
    
    //NSLog(@"XML parsing: %@",self.loadingURL);
    
    //Start parsing the XML file.
    BOOL success = [xmlParser parse];
    
    NSLog(@"TODO - POUR INFOS : Rajout d'un release sur le xmlParser.");
     [xmlParser release];

    if(success) {
        //NSLog(@"XML loaded");
    } else { // Avec le  if(success)
        NSLog(@"TODO : Gestion de l'erreur à faire - Error Error Error!!! - Soit erreur dans le XML, soit erreur de connexion Internet");
        
        UIAlertView *alert = [[[UIAlertView alloc] 
                               initWithTitle:@"Error"
                               message:@"XML parsing Error"
                               delegate:self
                               cancelButtonTitle:@"Cancel"
                               otherButtonTitles:nil]
                              autorelease];
        [alert show];
        
    } // Fin du  if(success)

    dicoPhoto=[[NSMutableDictionary alloc] init];
    	
} // Fin du - (void)loadView {


/*
 //-------------------------------------------------------------------------------------------------------------------------------
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
 
 NSLog(@"viewDidLoad: %@",self.userData);
 
 } // Fin du - (void)viewDidLoad {

*/

/*
 //-------------------------------------------------------------------------------------------------------------------------------
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
 } // Fin du - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {

*/

//-------------------------------------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    NSLog(@"TODO :  Est-ce que cela sert de faire un delegate pour ne rien faire dedans ?????");
    
    // Release any cached data, images, etc that aren't in use.
} // Fin du - (void)didReceiveMemoryWarning {


//-------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidUnload {
    [super viewDidUnload];
    NSLog(@"TODO :  Est-ce que cela sert de faire un delegate pour ne rien faire dedans ?????");
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
} // Fin du - (void)viewDidUnload {



//-------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    
    [sectionsDataSource release];
    [itemsDataSource release];
    [valuesDataSource release];
    [aidesDataSource release];
    [dicoPhoto release];
    
    [super dealloc];
} // Fin du - (void)dealloc {


//#########################################################################################################################################################
//#########################################################################################################################################################
#pragma mark -
#pragma mark Actions

//-------------------------------------------------------------------------------------------------------------------------------
//Action Back
-(void)actBack:(id)sender {
	//Retour au controlleur précédent
	[self.navigationController popViewControllerAnimated:YES];
	//[self.navigationController dismissModalViewControllerAnimated:YES];
} // FIn du -(void)actBack:(id)sender {


//#########################################################################################################################################################
//#########################################################################################################################################################
#pragma mark -
#pragma mark === Parser XML ===

/*
 <Root>
 <Section>
 <Nom>Identifiant</Nom>
 <Lignes>
 <Item>Id</Item>
 <Valeur>1</Valeur>
 <Item>Nom</Item>
 <Valeur>trebosc</Valeur>
 <Item>Photo</Item>
 <Valeur>trebosc.jpg</Valeur>
 </Lignes>
 </Section>
 ...
 </Root>
 */

//-------------------------------------------------------------------------------------------------------------------------------
// Start tag
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
	attributes:(NSDictionary *)attributeDict {
	
	//NSLog(@"didStartElement: %@",elementName);
	if ([elementName isEqualToString:@"Root"]) {
        sectionsDataSource=[[NSMutableArray alloc] init];
        itemsDataSource=[[NSMutableArray alloc] init];
        valuesDataSource=[[NSMutableArray alloc] init];
        aidesDataSource=[[NSMutableArray alloc] init];
    } // Fin du if ([elementName isEqualToString:@"Root"]) {
    
    else if ([elementName isEqualToString:@"Lignes"]) {
            currentItems=[[NSMutableArray alloc] init];
            currentValues=[[NSMutableArray alloc] init];
            currentAides=[[NSMutableArray alloc] init];
    } // Fin du if ([elementName isEqualToString:@"Lignes"]) {
    
} // Fin du - (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName


//-------------------------------------------------------------------------------------------------------------------------------
// Values
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	
	//NSLog(@"foundCharacters: %@",string);
	
	if (!currentStringValue) {
        // currentStringValue is an NSMutableString instance variable
        currentStringValue = [[NSMutableString alloc] initWithCapacity:100];
        
    } // Fin du if (!currentStringValue) {
	//NSLog(@"String: %@",string);
    [currentStringValue appendString:string];		
    
} // Fin du - (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {


//-------------------------------------------------------------------------------------------------------------------------------
// End tag
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    //Sauvegarde des données de l'utilisateur
    
    if ([elementName isEqualToString:@"Section"]) {
        //Reset des variables temporaires
        [currentItems release];
        [currentValues release];
        [currentAides release];
        currentAide=@"";
    } // Fin du if ([elementName isEqualToString:@"Section"]) {
    
    else if ([elementName isEqualToString:@"Nom"]) {
        //[currentSection setObject:[currentStringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"section"];
        [sectionsDataSource addObject:[currentStringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        //NSLog(@"%@",[currentStringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]);
    } // Fin du if ([elementName isEqualToString:@"Nom"]) {
    
    else if ([elementName isEqualToString:@"Item"]) {
        // Previous Aide
        if ([currentItems count]>[currentAides count]) {
            [currentAides addObject:currentAide];       // Can be nil
        }
        currentAide=@"";
        //<item
        [currentItems addObject:[currentStringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        
        //NSLog(@"Item: %@",[currentStringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]);
    } // Fin du if ([elementName isEqualToString:@"Item"]) {
    
    else if ([elementName isEqualToString:@"Valeur"]) {
        [currentValues addObject:[currentStringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    } // Fin du if ([elementName isEqualToString:@"Valeur"]) {
    
    else if ([elementName isEqualToString:@"Lignes"]) {
        // Previous Aide
        if ([currentItems count]>[currentAides count]) {
            [currentAides addObject:currentAide];       // Can be nil
        }
        currentAide=@"";
        
        //Ajout de la section au tableau
        [itemsDataSource addObject:currentItems];
        [valuesDataSource addObject:currentValues];
        [aidesDataSource addObject:currentAides];
        //NSLog(@"%@",currentAides);
    } // Fin du if ([elementName isEqualToString:@"Lignes"]) {
    
    else if ([elementName isEqualToString:@"Aide"]) {
        currentAide=[currentStringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    } // Fin du if ([elementName isEqualToString:@"Aide"]) {
    
    else if ([elementName isEqualToString:@"Root"]) {
        /*NSLog(@"Section: %@",sectionsDataSource);
         //NSLog(@"Items: %@",itemsDataSource);
         //NSLog(@"Values: %@",valuesDataSource);*/
    } // Fin du if ([elementName isEqualToString:@"Root"]) {
    
    
    [currentStringValue release];
	currentStringValue=nil;
	
} // Fin du - (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName

//#########################################################################################################################################################
//#########################################################################################################################################################
#pragma mark -
#pragma mark === Table view data source ===

//-------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [sectionsDataSource count];
} // Fin du - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {


//-------------------------------------------------------------------------------------------------------------------------------
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [sectionsDataSource objectAtIndex:section];
} // Fin du - (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {


/*
 //-------------------------------------------------------------------------------------------------------------------------------
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView { 
    return sectionsDataSource;
 } // Fin du - (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {

 */

//-------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[itemsDataSource objectAtIndex:section] count];
} // Fin du - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

//-------------------------------------------------------------------------------------------------------------------------------
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellFicheProche";
    
    static NSString *CellIdentifierPhoto = @"CellFicheProchePhoto";
    
    #define PHOTO_TAG 1
    
    UITableViewCell *cell;
    
    if (![[[itemsDataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] isEqualToString:@"Photo"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            //NSLog(@"cell==nil");
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
            // UITableViewCellStyleDefault
            // UITableViewCellStyleValue1
            // UITableViewCellStyleValue2
            // UITableViewCellStyleSubtitle
        } // Fin du        if (cell == nil) {
        
        //Label
        cell.textLabel.text=[[itemsDataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
        //Value
        if ([[[valuesDataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] rangeOfString:@"##OUVRE##"].location!=NSNotFound) {
            //OUVRE FENETRE
            cell.detailTextLabel.text=@"";
            cell.accessoryType=UITableViewCellAccessoryDetailDisclosureButton;
            
        } else { // Avec le         if ([[[valuesDataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] rangeOfString:@"##OUVRE##"].location!=NSNotFound) {
            cell.detailTextLabel.text=[[valuesDataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            cell.accessoryType=UITableViewCellAccessoryNone;   
        } // Fin du         if ([[[valuesDataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] rangeOfString:@"##OUVRE##"].location!=NSNotFound) {
        
    } else { // Avec le if (![[[itemsDataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] isEqualToString:@"Photo"]) {
        // Photo   
        UIImageView *photo;
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierPhoto];
        if (cell == nil) {
            //NSLog(@"cell==nil");
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierPhoto] autorelease];
            // UITableViewCellStyleDefault
            // UITableViewCellStyleValue1
            // UITableViewCellStyleValue2
            // UITableViewCellStyleSubtitle
            
            //cell.autoresizingMask=UIViewAutoresizingFlexibleHeight;
            
            photo = [[[UIImageView alloc] initWithFrame:CGRectMake(30.0, 0.0, 240.0, 162.0)] autorelease];
            photo.tag = PHOTO_TAG;
            //photo.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
            
            [cell.contentView addSubview:photo];
        } else { // Avec le if (cell == nil) {
            
            photo = (UIImageView *)[cell.contentView viewWithTag:PHOTO_TAG];
        } // Fin du if (cell == nil) {
        
        UIImage* image = [dicoPhoto objectForKey:indexPath];
        
        if (image == nil) {
            NSString *photoURL=[NSString stringWithFormat:@"http://www.bdpv.fr/image/install/%@",[[valuesDataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
            NSData* imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:photoURL]];
            NSLog(@"TODO : Possibilité de mettre un timeout ???");
            NSLog(@"TODO : Si erreur de chargement sur timeout ou autre, par quelle fonction estce capté ?");

            image = [[UIImage alloc] initWithData:imageData];
        
            //Stockage de l'image
            [dicoPhoto setObject:image forKey:indexPath];
        
            [imageData release];
        } // Fin du  if (image == nil) {
        
        photo.image = image;
        //cell.imageView.image=[UIImage imageNamed:@"maison_vue_dessus.png"];
        
    } // Fin du if (![[[itemsDataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] isEqualToString:@"Photo"]) {
    

    return cell;
} // Fin du - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {



/*
 //-------------------------------------------------------------------------------------------------------------------------------
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 } // Fin du  - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {

 */


/*
 //-------------------------------------------------------------------------------------------------------------------------------
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }  // Fin du if (editingStyle == UITableViewCellEditingStyleDelete) { 
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   // Fin du if (editingStyle == UITableViewCellEditingStyleInsert) {

 } // Fin du  - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

 */


/*
 //-------------------------------------------------------------------------------------------------------------------------------
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 } // Fin du - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 
 */


/*
 //-------------------------------------------------------------------------------------------------------------------------------
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 } // Fin du  - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {

 */


//#########################################################################################################################################################
//#########################################################################################################################################################
#pragma mark -
#pragma mark === UITableViewDelegate Protocol ===
//-------------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    //NSLog(@"%@",[[aidesDataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]);
    if (![[[aidesDataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] isEqualToString:@""]) {
        UIAlertView *alert = [[[UIAlertView alloc] 
                               initWithTitle:@"Aide contextuelle"
                               message:[[aidesDataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]
                               delegate:self
                               cancelButtonTitle:@"OK"
                               otherButtonTitles:nil]
                              autorelease];
        
        [alert show];
    }
        
} // Fin du - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {


//-------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[[itemsDataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] isEqualToString:@"Photo"]) {
        return 163.0;
    } else { // Avec le if ([[[itemsDataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] isEqualToString:@"Photo"]) {
        return tableView.rowHeight;
    } // Fin du if ([[[itemsDataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] isEqualToString:@"Photo"]) {

} // Fin du - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {



//-------------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *params= [[[valuesDataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] componentsSeparatedByString:@"+"];
    
    NSLog(@"OUVRE: %@",[params objectAtIndex:2]);
    
    if ([[params objectAtIndex:2] isEqualToString:@"g.php"]) {
        
        TableViewControllerFromURL *newController=[[TableViewControllerFromURL alloc] initWithStyle:UITableViewStyleGrouped];
        newController.title=self.title; //On affiche titre précedent
        newController.userData=userData;
        newController.loadingURL=[self buildOuvreURLg:params];
        [self.navigationController pushViewController:newController animated:YES];
        [newController release];
        
    }
         else if (([[params objectAtIndex:2] isEqualToString:@"l2.php"])) {
             FichesProchesTableViewController *newController=[[FichesProchesTableViewController alloc] init];
             newController.userData=self.userData;
             newController.loadingURL=[self buildSitesProchesURL];
             [self.navigationController pushViewController:newController animated:YES];
             [newController release];
         }
                
             
        
     else { // Avec le if ([[params objectAtIndex:2] isEqualToString:@"g.php"]) {
             NSLog(@"URL: %@",[params objectAtIndex:2]);
    } // Fin du if ([[params objectAtIndex:2] isEqualToString:@"g.php"]) {

} // Fin du - (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {



//-------------------------------------------------------------------------------------------------------------------------------
-(NSURL *)buildOuvreURLg:(NSArray *)params {
    //------------------------------------------------------------------
    // Génération de l'url
    //Récupération du nom du fichier PHP
    NSString *sParam = [params objectAtIndex:2];
    NSLog(@"Params %@",params);
    NSMutableArray  *myArray = [[NSMutableArray alloc] init];
    
    //Boucle sur les paramètres
    for (int i =3;i<[params count];i++) {
        [myArray addObject:[params objectAtIndex:i]];
    }
    
    NSString *sUrl = [self.userData genere_requete:myArray fichier_php:sParam];
    
    NSLog(@"%@",sUrl); 
    
    return [[[NSURL alloc] initWithString:sUrl] autorelease];
    
}

//-------------------------------------------------------------------------------------------------------------------------------
-(NSURL *)buildSitesProchesURL {
    
    // Génération de l'url
    NSString *sParam = @"l2.php";
    NSMutableArray  *myArray = [NSMutableArray arrayWithObjects:
                                [NSString  stringWithFormat:@"n=%d",LIMIT],
                                [NSString  stringWithFormat:@"i=%d",0],
                                nil];
    NSString *sUrl =[self.userData genere_requete:myArray fichier_php:sParam];
    
    
    return [[[NSURL alloc] initWithString:sUrl] autorelease];
    
} // Fin du -(NSURL *)buildSitesProchesURL {

@end
