//
//  UserData.h
//  iBDPV
//
//  Created by jmd on 27/08/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserData : NSObject {
    
    double       longitude;
    double       latitude;
    int         distance;
    int         nbInstallationProche;
    NSString    *uniqueIdentifierMD5;
    int         pente;
    int         orientation;

}

@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;  
@property (nonatomic, assign) int distance;
@property (nonatomic, assign) int nbInstallationProche;
@property (nonatomic, copy) NSString *uniqueIdentifierMD5;
@property (nonatomic, assign) int pente;
@property (nonatomic, assign) int orientation;

-(NSString *)md5:(NSString *)paramString;
-(NSString*)genere_requete:(NSArray*)paramTabString fichier_php:(NSString *)sParam;

@end
