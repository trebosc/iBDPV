    //
//  AproposViewController.m
//  iBDPV
//
//  Created by jmd on 01/08/10.
//  Copyright 2010 __MaCoDa__. All rights reserved.
//

#import "AproposViewController.h"


@implementation AproposViewController

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
	self.title=@"A propos";
	
	//Désactivation du bouton Back
	[self.navigationItem setHidesBackButton:YES];

	//Affichage de la toolBar du Navigation Controller
	[self.navigationController setToolbarHidden:NO animated:YES];
	
	//Création des boutons
	//Retour
	UIBarButtonItem *btnBackItem=[[UIBarButtonItem alloc]initWithTitle:@"Retour" style:UIBarButtonItemStyleBordered target:self action:@selector(actBack:)];
	//Espacement

	// Ajout des boutons dans la toolBar
	self.toolbarItems=[NSArray arrayWithObjects:btnBackItem,nil];

	[btnBackItem release];
	
    //Création de la hiérarchie des Views
    // 1. Création de la vue racine du controlleur de la taille de l'écran
	// Background
    UIImageView *rootView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fond_menu.png"]];
    rootView.userInteractionEnabled=YES;    //NO by default and YES for a UIView
    rootView.opaque = YES;
    
	// 2. Ajout de subViews
    //TODO - Voir la doc sur #if TARGET_IPHONE_SIMULATOR
// TODO - #error This sample is designed to run on a device, not in the simulator. To run this sample, \

    

    
    UIWebView * sTextView = [[UIWebView alloc] initWithFrame:CGRectMake(25.0, 125.0, 275, 200)];
    sTextView.opaque = NO;
    sTextView.backgroundColor = [UIColor clearColor];
    sTextView.delegate = self;

     NSString *html =@"IBDPV vous permet de calculer la quantité d'électricité photovoltaïque que vous produiriez en installant des panneaux PV sur votre toit, mais également de découvrir les installations photovoltaïque proches de chez vous.<br><br>L'application IBDPV est UNIQUE car l'estimation de votre production est réalisée à partir de chiffres REELS, provenant d'installation PV en cours de fonctionnement se trouvant proche de chez vous. iBDPV utilise les données saisies, par des milliers de particuliers, sur le site bdpv.fr (description en dessous).<br><br><b>Glossaire :</b><br>Panneaux photovoltaïque : appelé aussi panneaux PV, il s'agit de panneaux posés sur votre toiture et capable de produire de l'électricité verte a partir du soleil.<br><br><b>Description du site <a href=http://www.bdpv.fr>http://www.bdpv.fr</a> :</b><br>Le site BDPV permet aux propriétaires de panneaux photovoltaïques de suivre l'évolution de leur production d’électricité au fil des ans et de la comparer à des installations proches. BDPV aide à savoir si un système PV se comporte comme simulé par l’installateur, qu’il ne faiblit pas dans le temps, qu’il réagit comme d’autres installations proches, …. Tout cela gratuitement.<br>    BDPV fournit un ensemble de graphiques pour analyser vos données, graphiques que vous pouvez aussi insérer dans votre blog ou site web.<br>Pour ceux n’ayant pas encore de panneaux solaires, BDPV apporte la possibilité de visualiser, sur une carte, les installations de sa région, de voir le matériel utilisé (onduleur, …), la production attendue, les graphiques de production, …<br><br><b>Partenaires :</b><br><a href=http://forum-photovoltaique.fr>http://forum-photovoltaique.fr</a> : Ce forum s'adresse à tous ceux qui s'intéressent, ont déjà ou aimeraient avoir une installation photovoltaïque. Que vous soyez un particulier, un professionnel ou autres, ce forum vous permettra de partager votre expérience, de poser des questions, de trouver des conseils sur le matériel, sur quoi acheter, ce qu'il faut vérifier, ....<br><a href=http://gppep.org>http://gppep.org</a> : GPPEP est une association créée par des particuliers ayant des panneaux photovoltaïques, pour des particuliers ayant déjà une installation ou désirant en posséder une. GPPEP signifie : Groupement des Particuliers Producteurs d’Electricité Photovoltaïque<br><br>Une question ou une remarque : contact@bdpv.fr<br>Plus d'informations sur iBDPV : <a href=http://www.ibdpv.fr>http://www.ibdpv.fr</a><br><br><i>IBDPV a été développe par Jean-Mathieu D. et David T.</i>";
    [sTextView loadHTMLString:html baseURL:[NSURL URLWithString:@""]]; 
    [rootView addSubview:sTextView];
    [sTextView release];

    
	// 3. Assignation de la vue racine à la propriété view du controlleur
	self.view=rootView;
	
	// 4. Libération de la vue racine
	[rootView release];
    
    
	
}

//-------------------------------------------------------------------------------------------------------------------------------
// Pour ouvrir Safari 
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return false;
    }
    return true;
}



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


@end
