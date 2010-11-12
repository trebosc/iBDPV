//
//  Estim1GPSViewController.m
//  iBDPV
// JMD & DTR


#import "Estim1GPSViewController.h"
#import "Estim2PenteViewController.h"
#import "UserData.h"
#import "FichesProchesTableViewController.h"


/*
 Nombre d'installation proches
 http://www.bdpv.fr/ajax/iBDPV/n.php?api_sig=75a6831188d5f79394f2b00852595741&api_demandeur=iBDPV&uid=090392&l=43.5140120623541&o=1.51143550872803&d=100
 */


@implementation AddressAnnotation

@synthesize coordinate;

//-------------------------------------------------------------------------------------------------------------------------------
- (NSString *)subtitle{
	return @"Sub Title";
} // Fin  du - (NSString *)subtitle{


//-------------------------------------------------------------------------------------------------------------------------------
- (NSString *)title{
	return @"Title";
} // Fin du - (NSString *)title{


//-------------------------------------------------------------------------------------------------------------------------------
-(id)initWithCoordinate:(CLLocationCoordinate2D) c{
	coordinate=c;
	//NSLog(@"Annotation: %f,%f",c.latitude,c.longitude);
	return self;
} // Fin  du -(id)initWithCoordinate:(CLLocationCoordinate2D) c{


@end

@implementation AddressAnnotationView

//-------------------------------------------------------------------------------------------------------------------------------
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // The view is configured for single touches only.
    UITouch* aTouch = [touches anyObject];
    _startLocation = [aTouch locationInView:[self superview]];
    _originalCenter = self.center;
    //NSLog(@"touchesBegan - start: %f %f center: %f %f",_startLocation.x,_startLocation.y,_originalCenter.x,_originalCenter.y);
    //NSLog(@"%@",_startLocation);
    [super touchesBegan:touches withEvent:event];
} // Fin du - (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {


//-------------------------------------------------------------------------------------------------------------------------------
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch* aTouch = [touches anyObject];
    CGPoint newLocation = [aTouch locationInView:[self superview]];
    CGPoint newCenter;
    
    // If the user's finger moved more than 5 pixels, begin the drag.
    if ((abs(newLocation.x - _startLocation.x) > 5.0) || (abs(newLocation.y - _startLocation.y) > 5.0)) {
        _isMoving = YES;
		//NSLog(@"isMoving");
    } // Fin du if ((abs(newLocation.x - _startLocation.x) > 5.0) || (abs(newLocation.y - _startLocation.y) > 5.0)) {
    
    // If dragging has begun, adjust the position of the view.
    if (_mapView && _isMoving) {
        newCenter.x = _originalCenter.x + (newLocation.x - _startLocation.x);
        newCenter.y = _originalCenter.y + (newLocation.y - _startLocation.y);
        self.center = newCenter;
    } else { // Avec le if (_mapView && _isMoving) {
        // Let the parent class handle it.
        [super touchesMoved:touches withEvent:event];		
    } // Fin du if (_mapView && _isMoving) {
} // Fin du - (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {


//-------------------------------------------------------------------------------------------------------------------------------
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_mapView && _isMoving) {				
        // Update the map coordinate to reflect the new position.
/* TODO - A virer ? DOUDOU, C'est toi qui doit répondre. ET virier si nécessaire.
 CGPoint newCenter = self.center;
 AddressAnnotationView* theAnnotation = (AddressAnnotationView *)self.annotation;
 CLLocationCoordinate2D newCoordinate = [_mapView convertPoint:newCenter toCoordinateFromView:self.superview];
*/        
        //[theAnnotation changeCoordinate:newCoordinate];
        
        // Clean up the state information.
        _startLocation = CGPointZero;
        _originalCenter = CGPointZero;
        _isMoving = NO;
		//NSLog(@"Moving ended");
    } else { // Avec le if (_mapView && _isMoving) {			
        [super touchesEnded:touches withEvent:event];		
    } // Fi du if (_mapView && _isMoving) {			
} // Fin du - (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {


//-------------------------------------------------------------------------------------------------------------------------------
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_mapView && _isMoving) {
        // Move the view back to its starting point.
        self.center = _originalCenter;
        
        // Clean up the state information.
        _startLocation = CGPointZero;
        _originalCenter = CGPointZero;
        _isMoving = NO;
    } else { // Avec le if (_mapView && _isMoving) {
        [super touchesCancelled:touches withEvent:event];		
    } // Fin du if (_mapView && _isMoving) {
} // Fin du - (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {


@end


@implementation Estim1GPSViewController

@synthesize mapView, menuOrigin,toolbarSearchAddress,userData,validateItem;

//-------------------------------------------------------------------------------------------------------------------------------
-(NSURL *)buildSitesProchesURL {
    
    // Génération de l'url
    NSString *sParam = @"l.php";
    NSMutableArray  *myArray = [NSMutableArray arrayWithObjects:
                                [NSString  stringWithFormat:@"l=%f",self.userData.latitude],
                                [NSString  stringWithFormat:@"o=%f",self.userData.longitude],
                                [NSString  stringWithFormat:@"d=%d",self.userData.distance],
                                [NSString  stringWithFormat:@"n=%d",LIMIT],
                                [NSString  stringWithFormat:@"i=%d",0],
                                nil];
    NSString *sUrl =[self.userData genere_requete:myArray fichier_php:sParam];
    
    
    return [[[NSURL alloc] initWithString:sUrl] autorelease];
    
} // Fin du -(NSURL *)buildSitesProchesURL {


//-------------------------------------------------------------------------------------------------------------------------------
// Appelé à chauqe affichage de la vue (et pas uniquement lors du premier appel.
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Permet de remettre les bonnes propriétés au navigation Controller
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController setToolbarHidden:NO animated:YES];
        
} // Fin  du - (void)viewWillAppear:(BOOL)animated {


//-------------------------------------------------------------------------------------------------------------------------------
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {

	// Affichage de la barre de navigation
	[self.navigationController setNavigationBarHidden:NO];
	
	//Titre
	self.title=@"Localisez votre maison";
	
	//Désactivation du bouton Back
	//[self.navigationItem setHidesBackButton:YES];

	//Affichage de la toolBar du Navigation Controller
	[self.navigationController setToolbarHidden:NO animated:YES];
	
	//Création des boutons
	// Bouton Retour
    self.navigationItem.backBarButtonItem =  [[[UIBarButtonItem alloc] initWithTitle:@"Retour" style: UIBarButtonItemStylePlain target:nil action:nil] autorelease];
    
	//Espacement
	UIBarButtonItem *flexibleSpaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    //Valider
	UIBarButtonItem *btnValidateItem=[[UIBarButtonItem alloc] initWithTitle:@"Valider" style:UIBarButtonItemStyleDone target:self action:@selector(actValidate:)];
    btnValidateItem.enabled=NO;
    self.validateItem=btnValidateItem;
    
    //Localize
    UIImage *buttonOkImage2 = [UIImage imageNamed:@"localiser_adresse.png"];
    UIBarButtonItem *btnLocalizeItem=[[UIBarButtonItem alloc] initWithImage:buttonOkImage2 style:UIBarButtonItemStylePlain target:self action:@selector(actLocalize:)];

    
	// Ajout des boutons dans la toolBar
	self.toolbarItems=[NSArray arrayWithObjects:flexibleSpaceButtonItem,btnLocalizeItem,flexibleSpaceButtonItem,btnValidateItem,nil];

	[flexibleSpaceButtonItem release];
	
	// Création par programme de la hiérarchie de vues (p34) 
	
	// 1. Création de la vue racine du controlleur de la taille de l'écran
	// MapView
    MKMapView *rootView=[[MKMapView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
	rootView.opaque=YES;
    self.mapView=rootView;
    self.mapView.delegate=self;
    //[self.mapView.userLocation addObserver:self forKeyPath:@"location" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:NULL];
    self.mapView.mapType=MKMapTypeSatellite;
    self.mapView.showsUserLocation=YES;
    
	// 2. Ajout de subViews
    UIImage *buttonOkImage = [UIImage imageNamed:@"recherche_adresse.png"];
	UIButton *btnSearch = [UIButton buttonWithType:UIButtonTypeCustom];
	btnSearch.backgroundColor = [UIColor clearColor];
    btnSearch.frame = CGRectMake(2.0, 2.0, 24.0, 24.0);
	[btnSearch setBackgroundImage:buttonOkImage forState:UIControlStateNormal];
    [btnSearch addTarget:self action:@selector(actDisplayToolbarSearchAddress:) forControlEvents:UIControlEventTouchDown];
    [rootView addSubview:btnSearch];
    NSLog(@"TODO : Faut faire un release de UIImage ? "); 

	
	// 3. Assignation de la vue racine à la propriété view du controlleur
	self.view=rootView;
	
	// 4. Libération de la vue racine
	[rootView release];
} // Fin du - (void)loadView {



//#########################################################################################################################################################
//#########################################################################################################################################################
#pragma mark -
#pragma mark === MKMapViewDelegate ===
//-------------------------------------------------------------------------------------------------------------------------------
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {

    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        //if ([annotation class]==MKUserLocation.class) {
        //NSLog(@"UserLocation");
        //Enabled Validate button
        self.validateItem.enabled=YES;
        return nil;
    } else  { // Avec le if ([annotation isKindOfClass:[MKUserLocation class]]) {
        //Custom MKAnnotationView
        /*
        AddressAnnotationView *pinView=[[AddressAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pinView"];
        pinView.pinColor=MKPinAnnotationColorPurple;
        pinView.draggable=YES;
        */
            
        //Standard View
        MKPinAnnotationView *pinView=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pinView"];
            //Enabled Validate button
            self.validateItem.enabled=YES;
            return pinView;
    } // Fin du if ([annotation isKindOfClass:[MKUserLocation class]]) {
} // Fin du - (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {


//-------------------------------------------------------------------------------------------------------------------------------
- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views {
    for(MKAnnotationView *annotationView in views) {
        if(annotationView.annotation == mv.userLocation) {
            //NSLog(@"didAddAnnotationViews:");
            MKCoordinateRegion region;
            MKCoordinateSpan span;
            
            span.latitudeDelta=0.005;
            span.longitudeDelta=0.005; 
            
            CLLocationCoordinate2D location=mv.userLocation.coordinate;
            
            location = mv.userLocation.location.coordinate;
            
            region.span=span;
            region.center=location;
            
            [mv setRegion:region animated:TRUE];
            [mv regionThatFits:region];
            
            
        } // Fin du if(annotationView.annotation == mv.userLocation) {
    } // Fin du for(MKAnnotationView *annotationView in views) {

} // Fin du - (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views {


/*
 //-------------------------------------------------------------------------------------------------------------------------------
- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation{
	MKPinAnnotationView *annView=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"currentloc"];
	annView.pinColor = MKPinAnnotationColorGreen;
	annView.animatesDrop=TRUE;
	annView.canShowCallout = YES;
	annView.calloutOffset = CGPointMake(-5, 5);
	return annView;
}
 */

//-------------------------------------------------------------------------------------------------------------------------------
-(void)observeValueForKeyPath:(NSString *)keyPath  
                     ofObject:(id)object  
                       change:(NSDictionary *)change  
                      context:(void *)context {  
    //NSLog(@"observeValueForKeyPath: %@: ",keyPath);
    
    /*
    if ([self.mapView isUserLocationVisible]) {  
        [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate
                                 animated:YES];
    }*/
} // Fin du -(void)observeValueForKeyPath:(NSString *)keyPath  


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 //-------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    //[super viewDidLoad];
	
	//NSLog(@"viewDidLoad: Estim1GPSViewController");
	
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
 //-------------------------------------------------------------------------------------------------------------------------------
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

//#########################################################################################################################################################
//#########################################################################################################################################################
#pragma mark -
#pragma mark === Memory management ===
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
    
    if (self.toolbarSearchAddress!=nil) {
        [self.toolbarSearchAddress removeFromSuperview];
        //[self.toolbarSearchAddress release];
    } // Fin du if (self.toolbarSearchAddress!=nil) {

    
    [mapView release];
    [pinAnnotation release];
    [super dealloc];

} // Fin du - (void)dealloc {



//#########################################################################################################################################################
//#########################################################################################################################################################
#pragma mark -
#pragma mark === MapKit methods ===

//-------------------------------------------------------------------------------------------------------------------------------
-(CLLocationCoordinate2D) addressLocation:(NSString *)address {
	NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=csv", [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSString *locationString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSASCIIStringEncoding  error:NULL]; 
	NSArray *listItems = [locationString componentsSeparatedByString:@","];
	
	double latitude = 0.0;
	double longitude = 0.0;
	
	if([listItems count] >= 4 && [[listItems objectAtIndex:0] isEqualToString:@"200"]) {
		latitude = [[listItems objectAtIndex:2] doubleValue];
		longitude = [[listItems objectAtIndex:3] doubleValue];
	} else { // Avec le if([listItems count] >= 4 && [[listItems objectAtIndex:0] isEqualToString:@"200"]) {
		//Show error
        NSLog(@"TODO : c'est quoi l'erreur qu'il peut y avoir ???  Adresse pas trouvée ? (vu le 200 qui est le code pour dire adresse trouvée ");
	} // Fin du if([listItems count] >= 4 && [[listItems objectAtIndex:0] isEqualToString:@"200"]) {
    
	CLLocationCoordinate2D location;
	location.latitude = latitude;
	location.longitude = longitude;
	
	return location;
} // Fin du -(CLLocationCoordinate2D) addressLocation:(NSString *)address {


//#########################################################################################################################################################
//#########################################################################################################################################################
#pragma mark -
#pragma mark === Actions ===

//-------------------------------------------------------------------------------------------------------------------------------
//Action Back
-(void)actBack:(id)sender {
    //NSLog(@"Top: @%",self.navigationController.topViewController);
	
	//Retour au controlleur précédent
	[self.navigationController popViewControllerAnimated:YES];
	//[self.navigationController dismissModalViewControllerAnimated:YES];
} // Fin du -(void)actBack:(id)sender {


//-------------------------------------------------------------------------------------------------------------------------------
//Action Validate
-(void)actValidate:(id)sender {
    //Sauvegarde des données de l'utilisateur
    
    //Debug
    self.userData.distance=100;
        
    if (pinAnnotation!=nil) {
        //Prendre la position de la pin  
        self.userData.latitude=pinAnnotation.coordinate.latitude;
        self.userData.longitude=pinAnnotation.coordinate.longitude;
    } else { // Avec le if (pinAnnotation!=nil) {
        //Prendre la position de l'utilisateur
        self.userData.latitude=self.mapView.userLocation.coordinate.latitude;
        self.userData.longitude=self.mapView.userLocation.coordinate.longitude;
    } // Fin du if (pinAnnotation!=nil) {
    
    //NSLog(@"Longitude: %f - Latitude: %f",self.mapView.userLocation.coordinate.longitude,self.mapView.userLocation.coordinate.latitude);
    //NSLog(@"Longitude: %f - Latitude: %f",pinAnnotation.coordinate.longitude,pinAnnotation.coordinate.latitude);
    //NSLog(@"Longitude: %f - Latitude: %f",self.userData.longitude,self.userData.latitude);
    
    //Lecture du nombre d'installations proches
    //self.userData.nbInstallationProche=10;
    

    // Génération de l'url
    NSString *sParam = @"n.php";
    NSMutableArray  *myArray = [NSMutableArray arrayWithObjects:
                                [NSString  stringWithFormat:@"l=%f",self.userData.latitude],
                                [NSString  stringWithFormat:@"o=%f",self.userData.longitude],
                                [NSString  stringWithFormat:@"d=%d",self.userData.distance],
                                nil];
    NSString *sUrl = [self.userData genere_requete:myArray fichier_php:sParam];

    
    //NSLog(@"URL %@",sUrl);

    NSURL *url = [[NSURL alloc] initWithString:sUrl];
    [sUrl release];
    
    // Lancement du parsing XML (mode SYNCHRONE)
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    [url release];

 
    //NSLog(@"Ici xmlParser contient le contenu data qui a été téléchargé");
    
    //Set delegate
    //NSLog(@"On indique qui va traiter le retour XML");
    [xmlParser setDelegate:self];
    
    //NSLog(@"Parse du XML");
    
    //Start parsing the XML file.
    BOOL success = [xmlParser parse];
    
    // A PRIORI PLANTE - NSLog(@"TODO - POUR INFOS : Rajout d'un release sur le xmlParser %d.",[xmlParser retainCount]);
    // A PRIORI PLANTE - [xmlParser release];
    
    

    if(success) {
        //NSLog(@"No Errors");
    } else {  // Avec le if(success) {
         UIAlertView *alert = [[[UIAlertView alloc] 
                               initWithTitle:@"Error"
                               message:@"Pb du parsing XML"
                               delegate:self
                               cancelButtonTitle:@"Cancel"
                               otherButtonTitles:nil]
                              autorelease];
        [alert show];
        
    } // Fin du if(success) {
    
	//Passage au controleur suivant (en fonction du bouton d'appel)
    if (self.menuOrigin==@"FichesProches") {
        
        FichesProchesTableViewController *newController=[[FichesProchesTableViewController alloc] init];
        newController.userData=self.userData;
        newController.loadingURL=[self buildSitesProchesURL];
        [self.navigationController pushViewController:newController animated:YES];
        [newController release];
        
    } else { // Avec le if (self.menuOrigin==@"FichesProches") {
        Estim2PenteViewController *newController=[[Estim2PenteViewController alloc] init];
        newController.userData=self.userData;
        [self.navigationController pushViewController:newController animated:YES];
        [newController release];
        
    } // Fin du if (self.menuOrigin==@"FichesProches") {
	
    
} // Fin du -(void)actValidate:(id)sender {

//-------------------------------------------------------------------------------------------------------------------------------
-(void)actDisplayToolbarSearchAddress:(id)sender {
    
    //NSLog(@"Search clicked");
    
    if (self.toolbarSearchAddress==nil) {
        //Affichage d'une Toolbar
        UIToolbar *tobSearch=[UIToolbar new];
        tobSearch.barStyle=UIBarStyleBlackTranslucent;
        tobSearch.frame=CGRectMake(0, 0, 320, 50);
        
        //Nb Fiches
        UITextField *txtSearch=[[UITextField alloc] initWithFrame:CGRectMake(0 , 0, 230, 28)];
        txtSearch.backgroundColor=[UIColor clearColor];
        txtSearch.borderStyle=UITextBorderStyleRoundedRect;
        txtSearch.placeholder=@"<Entrez une adresse>";
#if TARGET_IPHONE_SIMULATOR
        txtSearch.text=@"hotel-dieu 75004 paris";   //Debug
#endif

        txtSearch.autocorrectionType=UITextAutocorrectionTypeNo;
        txtSearch.returnKeyType=UIReturnKeyDone;
        txtSearch.clearButtonMode=UITextFieldViewModeWhileEditing;
        txtSearch.textColor=[UIColor blueColor];
        txtSearch.delegate=self;
        txtSearch.tag=70;
        [txtSearch becomeFirstResponder];   // Permet d'afficher le clavier
        
        UIBarButtonItem *txtSearchItem=[[UIBarButtonItem alloc] initWithCustomView:txtSearch];
        
        [txtSearch release];
        
        UIBarButtonItem *btnAnnulerItem=[[UIBarButtonItem alloc] initWithTitle:@"Annuler" style:UIBarButtonItemStyleDone target:self action:@selector(actAnnuler:)];
        
        //Add buttons to the array
        NSArray *items = [NSArray arrayWithObjects: txtSearchItem,btnAnnulerItem, nil];
        [tobSearch setItems:items animated:NO];
        [self.view addSubview:tobSearch];
        self.toolbarSearchAddress=tobSearch;    //Used to remove or hide it
        [tobSearch release];
        [txtSearchItem release];
        [btnAnnulerItem release];  
    } else { // Avec le  if (self.toolbarSearchAddress==nil) {
        //Affichage de la ToolBar
        //[self.view addSubview:self.toolbarSearchAddress];     // Added to the hierarchy
        self.toolbarSearchAddress.hidden=NO;                    // Unhided
        } // Fin du  if (self.toolbarSearchAddress==nil) {
        
    //Disabled Validate button
    self.validateItem.enabled=NO;
                                  
    
} // Fin  du -(void)actDisplayToolbarSearchAddress:(id)sender {


//-------------------------------------------------------------------------------------------------------------------------------
-(void)actAnnuler:(id)sender {
    //Fait disparaitre la ToolBar
    //[self.toolbarSearchAddress removeFromSuperview];                  // Removed from the hiearachy
    self.toolbarSearchAddress.hidden=YES;                               // Hided
    [[self.toolbarSearchAddress viewWithTag:70] resignFirstResponder];  // Hide keyboard
    
    //Enabled Validate button
    self.validateItem.enabled=YES;
} // Fin du -(void)actAnnuler:(id)sender {



//-------------------------------------------------------------------------------------------------------------------------------
-(void)actLocalize:(id)sender {
    //NSLog(@"actLocalize");
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    
    span.latitudeDelta=0.005;
    span.longitudeDelta=0.005; 
    
    CLLocationCoordinate2D location=mapView.userLocation.coordinate;
    
    location = mapView.userLocation.location.coordinate;
    
    region.span=span;
    region.center=location;
    
    [mapView setRegion:region animated:TRUE];
    [mapView regionThatFits:region];
    
    //Suppression de l'annotation
    [pinAnnotation release];
    pinAnnotation=nil;
    
    
} // Fin du -(void)actLocalize:(id)sender {


//#########################################################################################################################################################
//#########################################################################################################################################################
#pragma mark -
#pragma mark === UITextFieldDelegate ===
//-------------------------------------------------------------------------------------------------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    MKCoordinateRegion region;
	MKCoordinateSpan span;
	span.latitudeDelta=0.005;
	span.longitudeDelta=0.005;
	
	CLLocationCoordinate2D location = [self addressLocation:[textField text]];
	region.span=span;
	region.center=location;
	
	if(pinAnnotation != nil) {
		[mapView removeAnnotation:pinAnnotation];
		[pinAnnotation release];
		pinAnnotation = nil;
	} // Fin du if(pinAnnotation != nil) {
	
	pinAnnotation = [[AddressAnnotation alloc] initWithCoordinate:location];
	[mapView addAnnotation:pinAnnotation];
	
	[mapView setRegion:region animated:TRUE];
	[mapView regionThatFits:region];

    return YES;
} // Fin du - (BOOL)textFieldShouldReturn:(UITextField *)textField {


//#########################################################################################################################################################
//#########################################################################################################################################################
#pragma mark -
#pragma mark === Parser XML ===

/*
 <nombre_inst>
 <Reference>147</Reference>
 <Certifie>8</Certifie>
 <Production>38</Production>
 <Pente_moyenne_deg>22.28</Pente_moyenne_deg>
 <Code_retour>0</Code_retour>
 <Texte_erreur>Aucune erreur</Texte_erreur>
 </nombre_inst
 */
// #### NSXMLParserDelegate

//-------------------------------------------------------------------------------------------------------------------------------
// Start tag
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
	attributes:(NSDictionary *)attributeDict {
	
	//NSLog(@"didStartElement: %@",elementName);
	
    
	if ([elementName isEqualToString:@"nombre_inst"]) { //sites
        // Init Sites
	} // Fin  du if ([elementName isEqualToString:@"nombre_inst"]) { //sites

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


//-------------------------------------------------------------------------
// End tag
//-------------------------------------------------------------------------------------------------------------------------------
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    //Sauvegarde des données de l'utilisateur
    
    //On évite la racine
    if ([elementName isEqualToString:@"nombre_inst"]) return; 
        
     if ([elementName isEqualToString:@"Reference"]) {
     
         self.userData.nbInstallationProche=[[currentStringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] intValue];
         //NSLog(@"XML userData.nbInstallationProche=%d",self.userData.nbInstallationProche);
         
     } // FIn du if ([elementName isEqualToString:@"Reference"]) {
    
    [currentStringValue release];
	currentStringValue=nil;
	
} // Fin du - (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName




@end

