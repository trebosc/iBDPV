//
//  UserData.m
//  iBDPV
// JMD & DTR


#import "UserData.h"
#import <CommonCrypto/CommonDigest.h>

//*********************************************************************************************************
#include "UserData_api_secret.h" 
// Ce fichier n'est pas publié dans GITHUB car il est personnel et secret. Vous devez le demander par email à contact@ibdpv.fr
// L'objectif est de protéger l'accès aux serveurs http://www.ibdpv.fr
// Sont contenu est le suivant : 
//static NSString *const API_SECRET    = @"XXXXXX";
//static NSString *const API_DEMANDEUR = @"XXXXXXX";
//*********************************************************************************************************


@implementation UserData

@synthesize longitude, latitude, distance, nbInstallationProche,uniqueIdentifierMD5, pente, orientation;



//-------------------------------------------------------------------------------------------------------------------------------
-(NSString*)md5:(NSString *)paramString;
{
    const char *cStr = [paramString UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), result );
    
    return [NSString  stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4],
            result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12],
            result[13], result[14], result[15]
            ];
} // Fin du -(NSString*)md5:(NSString *)paramString;



//-------------------------------------------------------------------------------------------------------------------------------
-(NSString*)signature:(NSMutableArray*)paramTabString;
{
    NSString *sTrv = [[NSString alloc] init];
    
    // La chaine à convertir commence par l'api_secret
     sTrv = API_SECRET;    

    // Tri des arguments.
    [paramTabString sortUsingSelector:@selector(caseInsensitiveCompare:)];
    
    // Concaténation de la chaine de caractère
    for(NSString * myStr in paramTabString) {
        sTrv = [sTrv stringByAppendingString:myStr];
    } // Fin du for(NSString * myStr in sortedArray) {

    // On retire les = qui ne doivent pas être utilisés dans le calcul de la signature
    int stringLength = [sTrv length];
    NSRange range = NSMakeRange(0, stringLength);
    sTrv = [sTrv stringByReplacingOccurrencesOfString:@"=" withString:@"" options:NSCaseInsensitiveSearch range:range];

    // Conversion de la chaine de caractère en md5
    sTrv = [self md5:sTrv];

    return sTrv;
} // Fin du-(NSString*)signature:(NSMutableArray*)paramTabString;


//-------------------------------------------------------------------------------------------------------------------------------
-(NSString*)genere_requete:(NSMutableArray*)paramTabString fichier_php:(NSString *)sParam;
{
     NSString *sTrv = [NSString  stringWithFormat:@"http://www.ibdpv.fr/ajax/iBDPV/%@?",sParam];
    
    // On rajoute le demandeur et l'identifieur
    [paramTabString  addObject:[NSString  stringWithFormat:@"uid=%@",self.uniqueIdentifierMD5]];
    [paramTabString  addObject:[NSString  stringWithFormat:@"api_demandeur=%@",API_DEMANDEUR]];

    // On calcule la signature
    NSString *api_sig;
    api_sig = [self signature:paramTabString];

    // On commence par la signature
    sTrv = [sTrv stringByAppendingString:[NSString stringWithFormat:@"api_sig=%@",api_sig]];

    // Concaténation de la chaine de caractère
    for(NSString * myStr in paramTabString) {
        sTrv = [sTrv stringByAppendingString:[NSString stringWithFormat:@"&"]];
        sTrv = [sTrv stringByAppendingString:myStr];
    } // Fin du for(NSString * myStr in sortedArray) {
  
    return sTrv;
} // Fin du-(NSString*)genere_requete:(NSMutableArray*)paramTabString;


@end
