//
//  TableViewControllerFromURL.m
//  iBDPV
//
//  Created by jmd on 27/08/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "TableViewControllerFromURL.h"


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
    }
    return self;
}
*/

//-------------------------------------------------------------------------------------------------------------------------------
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    [super loadView];
    
    NSLog(@"loadView: %@",self.userData);
    
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
    
    
    //Set delegate
    [xmlParser setDelegate:self];
    
    NSLog(@"XML parsing: %@",self.loadingURL);
    
    //Start parsing the XML file.
    BOOL success = [xmlParser parse];
    
    if(success)
        NSLog(@"XML loaded");
    else {
        NSLog(@"Error Error Error!!! - Soit erreur dans le XML, soit erreur de connexion Internet");
        
        UIAlertView *alert = [[[UIAlertView alloc] 
                               initWithTitle:@"Error"
                               message:@"XML parsing Error"
                               delegate:self
                               cancelButtonTitle:@"Cancel"
                               otherButtonTitles:nil]
                              autorelease];
        [alert show];
        
    } // 

    dicoPhoto=[[NSMutableDictionary alloc] init];
    
	
}

/*
 //-------------------------------------------------------------------------------------------------------------------------------
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
 
 NSLog(@"viewDidLoad: %@",self.userData);
 
}
*/

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
    
    [sectionsDataSource release];
    [itemsDataSource release];
    [valuesDataSource release];
    [dicoPhoto release];
    
    [super dealloc];
}

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
}

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
    }
    else if ([elementName isEqualToString:@"Lignes"]) {
        currentItems=[[NSMutableArray alloc] init];
        currentValues=[[NSMutableArray alloc] init];
    }
    
    
}

//-------------------------------------------------------------------------------------------------------------------------------
// Values
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	
	//NSLog(@"foundCharacters: %@",string);
	
	if (!currentStringValue) {
        // currentStringValue is an NSMutableString instance variable
        currentStringValue = [[NSMutableString alloc] initWithCapacity:100];
        
    }
	//NSLog(@"String: %@",string);
    [currentStringValue appendString:string];		
    
}

//-------------------------------------------------------------------------------------------------------------------------------
// End tag
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    //Sauvegarde des données de l'utilisateur
    
    if ([elementName isEqualToString:@"Section"]) {
        
        //Reset des variables temporaires
        [currentItems release];
        [currentValues release];
        
    }
    else if ([elementName isEqualToString:@"Nom"]) {
        //[currentSection setObject:[currentStringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"section"];
        [sectionsDataSource addObject:[currentStringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        NSLog(@"%@",[currentStringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]);
                               
    }
    
    else if ([elementName isEqualToString:@"Item"]) {
        [currentItems addObject:[currentStringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        NSLog(@"Item: %@",[currentStringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]);
    }
    
    else if ([elementName isEqualToString:@"Valeur"]) {
        
        [currentValues addObject:[currentStringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
               
    }
    
    else if ([elementName isEqualToString:@"Lignes"]) {
        //Ajout de la section au tableau
        [itemsDataSource addObject:currentItems];
        [valuesDataSource addObject:currentValues];
        
    }
    
    else if ([elementName isEqualToString:@"Root"]) {
        /*NSLog(@"Section: %@",sectionsDataSource);
         NSLog(@"Items: %@",itemsDataSource);
         NSLog(@"Values: %@",valuesDataSource);*/
    }
    
    
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
}

//-------------------------------------------------------------------------------------------------------------------------------
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
 
    return [sectionsDataSource objectAtIndex:section];

}
/*
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
 
    return sectionsDataSource;
    
}*/

//-------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
   
    return [[itemsDataSource objectAtIndex:section] count];
}


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
        }
        
        //Label
        cell.textLabel.text=[[itemsDataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
        //Value
        if ([[[valuesDataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] rangeOfString:@"##OUVRE##"].location!=NSNotFound) {
            //OUVRE FENETRE
            cell.detailTextLabel.text=@"";
            cell.accessoryType=UITableViewCellAccessoryDetailDisclosureButton;
            
        }
        else
        {
            cell.detailTextLabel.text=[[valuesDataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            cell.accessoryType=UITableViewCellAccessoryNone;   
        }
    
    
        
    }
    
    else {
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
            
            
        }
        
        else {
            
            photo = (UIImageView *)[cell.contentView viewWithTag:PHOTO_TAG];
        }
        
        UIImage* image = [dicoPhoto objectForKey:indexPath];
        
        if (image == nil) {
        NSString *photoURL=[NSString stringWithFormat:@"http://www.bdpv.fr/image/install/%@",[[valuesDataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
        NSData* imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:photoURL]];
        
        image = [[UIImage alloc] initWithData:imageData];
        
            //Stockage de l'image
            [dicoPhoto setObject:image forKey:indexPath];
        
            [imageData release];
            
        }
        
        
        photo.image = image;
            
      
        
        //cell.imageView.image=[UIImage imageNamed:@"maison_vue_dessus.png"];
        
    }
    

    return cell;
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


//#########################################################################################################################################################
//#########################################################################################################################################################
#pragma mark -
#pragma mark === UITableViewDelegate Protocol ===
//-------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[[itemsDataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] isEqualToString:@"Photo"]) {
        return 163.0;
    }
    else {
        return tableView.rowHeight;
    }

}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *params= [[[valuesDataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] componentsSeparatedByString:@"+"];
    
    NSLog(@"OUVRE: %@",[params objectAtIndex:2]);
    
    if ([[params objectAtIndex:2] isEqualToString:@"r.php"]) {
        
        //Fiches proches  UITableViewStylePlain
        TableViewControllerFromURL *newController=[[TableViewControllerFromURL alloc] initWithStyle:UITableViewStyleGrouped];
        newController.title=@"Test";
        newController.userData=userData;
        newController.loadingURL=[self buildOuvreURL:params];
        [self.navigationController pushViewController:newController animated:YES];
        [newController release];
        
    }
         else {
             NSLog(@"URL: %@",[params objectAtIndex:2]);
         }
         
    
   

    
}

//-------------------------------------------------------------------------------------------------------------------------------
-(NSURL *)buildOuvreURL:(NSArray *)params {
    // Génération de la signature pour le lien http
    NSString *api_sig_a_convertir;
    api_sig_a_convertir = [NSString  stringWithFormat:@"ibdpv_20100712api_demandeuriBDPVi%duid%@",
                           1152,
                           self.userData.uniqueIdentifierMD5
                           ];
    NSLog(@"api_sig_a_convertir: %@",api_sig_a_convertir);
    
    NSString *api_sig;
    api_sig = [self.userData md5:api_sig_a_convertir];
    NSLog(@"api_sig: %@",api_sig);
    
    NSString *sUrl = [NSString  stringWithFormat:@"http://www.bdpv.fr/ajax/iBDPV/f.php?api_sig=%@&api_demandeur=iBDPV&uid=%@&i=%d",
                      api_sig,
                      self.userData.uniqueIdentifierMD5,
                      1152            // i: user ID
                      ]; 
    
    NSLog(@"%@",sUrl); 
    
    return [[[NSURL alloc] initWithString:sUrl] autorelease];
    
}


@end
