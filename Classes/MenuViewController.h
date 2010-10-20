//
//  MenuViewController.h
//  iBDPV
//
//  Created by jmd on 31/07/10.
//  Copyright (c) 2010 __MaCoDa__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserData.h"


@interface MenuViewController : UIViewController <NSXMLParserDelegate> {
   
    UIAlertView *alertAttenteTestCnx;
    
    NSMutableString *currentStringValue;
    NSMutableData *receivedData;
    UserData *userData;
    
    int iEtatConnexion;  // Etat de la connexion au serveur BDPV. Voir le .M avec les constantes CNX_ENCOURS et autres// Fin du 
    
    NSString *Num_version_act;
	NSString *Num_version_min;
	int  iCodeRetour;
	NSString *sCodeRetour;
    NSString *sTexte_erreur;

}

@property (nonatomic,retain) UserData *userData;

@property (nonatomic,retain) NSString *Num_version_act;
@property (nonatomic,retain) NSString *Num_version_min;
@property (nonatomic) int iCodeRetour;
@property (nonatomic,retain) NSString *sCodeRetour;
@property (nonatomic,retain) NSString *sTexte_erreur;


// Actions pour les boutons du menu
-(void)actEstimer:(id)sender;
-(void)actFichesProches:(id)sender;
-(void)actOptions:(id)sender;
-(void)actAPropos:(id)sender;

@end
