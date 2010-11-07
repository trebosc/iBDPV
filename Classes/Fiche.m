//
//  Fiche.m
//  iBDPV
// JMD & DTR

#import "Fiche.h"


@implementation Fiche

@synthesize Id, nom, distance,annee_rac,mois_rac,last_maj_inst,last_maj_prod, photo;


-(void)dealloc {
    [nom release];
    [last_maj_inst release];
    [last_maj_prod release];
    [super dealloc];
}


@end
