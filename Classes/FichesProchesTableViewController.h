//
//  FichesProchesTableViewController.h
//  iBDPV
//
//  Created by jmd on 25/08/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserData.h"
#import "Fiche.h"

#define LIMIT 20       // Pagination

@interface FichesProchesTableViewController : UITableViewController <NSXMLParserDelegate> {
    
    UILabel *lblNbFiches;       // Label in toolbar to display the rows counter
    UserData *userData;
    NSURL *loadingURL;
    
    NSMutableArray *arrFiches;  //Tableau des fiches pour alimenter la TableView
    
    NSMutableString *currentStringValue;
    
    Fiche *xmlFiche;            // Objet temporaire utilisé lors du parsing xml avant de l'insérer dans le tableau des fiches
    BOOL booXMLLoading;         // Booléen pour bloquer les chargements multiples
    int indexToLoad;            // Entier représentant le numéro de ligne à charger
    
     NSMutableData *receivedData;
    
     NSMutableDictionary *dicoPhoto;
    
    UIActivityIndicatorView *activityIndicator;
    
}

@property (nonatomic, retain) UILabel *lblNbFiches;
@property (nonatomic,retain) UserData *userData;
@property (nonatomic, assign) NSURL *loadingURL;
@property (nonatomic, retain) NSMutableArray *arrFiches;
@property (nonatomic, retain) Fiche *xmlFiche;
@property (nonatomic, assign) BOOL booXMLLoading;
@property (nonatomic, assign) int indexToLoad;
@property (nonatomic, retain) NSMutableDictionary *dicoPhoto;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;

//Action Back
-(void)actBack:(id)sender;

//Build URLs
-(NSURL *)buildSitesProchesURL;
-(NSURL *)buildFicheDetailURL:(int)userID;

@end