//
//  Fiche.h
//  iBDPV
//
//  Created by jmd on 30/08/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Fiche : NSObject {
    
    int         Id;
    NSString    *nom;
    int         distance;
    int         annee_rac;
    int         mois_rac;
    NSString    *last_maj_inst;     //NSDate
    NSString    *last_maj_prod;     //NSDate
    NSString    *photo;
}

@property (nonatomic, assign) int Id;
@property (nonatomic, copy) NSString *nom;
@property (nonatomic, assign) int distance; 
@property (nonatomic, assign) int annee_rac;
@property (nonatomic, assign) int mois_rac;
@property (nonatomic, copy) NSString *last_maj_inst;
@property (nonatomic, copy) NSString *last_maj_prod;
@property (nonatomic, copy) NSString *photo;

@end
