//
//  MenuViewController.h
//  iBDPV
//
//  Created by jmd on 31/07/10.
//  Copyright (c) 2010 __MaCoDa__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserData.h"


@interface MenuViewController : UIViewController <NSXMLParserDelegate>{
    UIAlertView *alertAttenteTestCnx;
    
    NSMutableString *currentStringValue;
    NSMutableData *receivedData;
    UserData *userData;
    
    int iEtatConnexion;  // Etat de la connexion au serveur BDPV. Voir le .M avec les constantes CNX_ENCOURS et autres// Fin du 

}

@property (nonatomic,retain) UserData *userData;

// Actions pour les boutons du menu
-(void)actEstimer:(id)sender;
-(void)actFichesProches:(id)sender;
-(void)actOptions:(id)sender;
-(void)actAPropos:(id)sender;

@end
