//
//  AproposViewController.m
//  iBDPV
// JMD & DTR


#import "AproposViewController.h"


@implementation AproposViewController


//#########################################################################################################################################################
//#########################################################################################################################################################
#pragma mark -
#pragma mark === Fonction pour créer la vue  ===


//-------------------------------------------------------------------------------------------------------------------------------
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {

	// Affichage de la barre de navigation
	[self.navigationController setNavigationBarHidden:NO];
	
	//Titre
	self.title=NSLocalizedString(@"About","");
		
    //Création de la hiérarchie des Views
    // 1. Création de la vue racine du controlleur de la taille de l'écran
	// Background
    UIImageView *rootView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fond_menu.png"]];
    rootView.userInteractionEnabled=YES;    //NO by default and YES for a UIView
    rootView.opaque = YES;
    
	// 2. Ajout de subViews
    UIWebView * sTextView = [[UIWebView alloc] initWithFrame:CGRectMake(25.0, 125.0, 275, 270)];
    sTextView.opaque = NO;
    sTextView.backgroundColor = [UIColor clearColor];
    sTextView.delegate = self;

     NSString *sHtml =@"IBDPV not only enables you to calculate the quantity of photovoltaic electricity that you could produce by installing PV panels on your roof, but also to discover the photovoltaic installations in your area.<br><br> The iBDPV application is realistic because the estimate of your production is calculated by using REAL figures, based on data from installations operating in your area. iBDPV uses the collected data, provided by thousands of private individuals, on the site bdpv.fr (description in lower part).<br><br><b>Glossary</b>: Photovoltaic Panels: also called Solar Panels, are installed on your roof and produce Green Electricity using the light from the sun. Description of the <a href=http://www.bdpv.fr>http://www.bdpv.fr</a> :</b><br> site: BDPV allows to the owners photovoltaic panels to log and view their historical production data and to compare it with neighbouring. BDPV helps understand if a installation behaves as simulated by the fitter and allows system age degradation to be monitored,Ö. All that free. BDPV provides a whole host of graphs to analyze your data, graphs which you can also insert in your blog or Web site. For those not yet having solar panels, BDPV brings the possibility of visualizing, on a chart, the installations of its area, of seeing the equipment used (inverter,Ö), actual production, graphs of production,…<br><br><b>Partners</b><br><a href=http://forum-photovoltaique.fr>http://forum-photovoltaique.fr</a> : This forum is for the use of everyone who is interested in, already have or would like to have a photovoltaic installation. Whether you are a private individual, a professional or other, this forum will enable you to share your experiences, to put questions, to find answers about the material, on what to buy, etc,… .http://gppep.org: GPPEP is an association created by private individuals having photovoltaic panels, who have or wish to install Solar PV. GPPEP means: Group of the Producing Private individuals of Electricity Photovoltaic question or a note:: contact@ibdpv.fr<br> Plus  information on iBDPV: <a href=http://www.ibdpv.fr>http://www.ibdpv.fr</a><br><br><i>iBDPV was developed by Jean-Mathieu D. and David T.</i>";
    
    NSString *sTexteHtml = NSLocalizedString(sHtml, @"Texte html About");


    [sTextView loadHTMLString:sTexteHtml baseURL:[NSURL URLWithString:@""]]; 
    [rootView addSubview:sTextView];
    [sTextView release];

    
	// 3. Assignation de la vue racine à la propriété view du controlleur
	self.view=rootView;
	
	// 4. Libération de la vue racine
	[rootView release];
	
} // Fin du - (void)loadView {

//#########################################################################################################################################################
//#########################################################################################################################################################
#pragma mark -
#pragma mark === Pour répondre au clics sur les liens de la page  ===


//-------------------------------------------------------------------------------------------------------------------------------
// Pour ouvrir Safari 
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return false;
    } // FIn du     if (navigationType == UIWebViewNavigationTypeLinkClicked) {
    return true;
} // Fin du -(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {



//#########################################################################################################################################################
//#########################################################################################################################################################
#pragma mark -
#pragma mark === Fin de vie de la classe  ===

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
    [super dealloc];
} // Fin du - (void)dealloc {



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
}


@end
