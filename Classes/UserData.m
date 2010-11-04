//
//  UserData.m
//  iBDPV
//
//  Created by jmd on 27/08/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "UserData.h"
#import <CommonCrypto/CommonDigest.h>

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
-(NSString*)signature:(NSArray*)paramTabString;
{
    NSString *sTrv = [[NSString alloc] init];
    
    NSLog(@"TODO - Cette signature ne devrait pas être publiée sur GITHUB !!");
    // La chaine à convertir commence par l'api_secret
    sTrv = @"ibdpv_20100712";
    

    // Tri des arguments.
    NSArray *sortedArray = [paramTabString sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    
    // Concaténation de la chaine de caractère
    for(NSString * myStr in sortedArray) {
        sTrv = [sTrv stringByAppendingString:myStr];
    } // Fin du for(NSString * myStr in sortedArray) {

    // On retire les = qui ne doivent pas être utilisés dans le calcul de la signature
    int stringLength = [sTrv length];
    NSRange range = NSMakeRange(0, stringLength);
    sTrv = [sTrv stringByReplacingOccurrencesOfString:@"=" withString:@"" options:NSCaseInsensitiveSearch range:range];

    // Conversion de la chaine de caractère en md5
    sTrv = [self md5:sTrv];

    return sTrv;
} // Fin du-(NSString*)signature:(NSArray*)paramTabString;


//-------------------------------------------------------------------------------------------------------------------------------
-(NSString*)genere_requete:(NSArray*)paramTabString fichier_php:(NSString *)sParam;
{
    
    
    //numberOfRowsInComponent:(NSInteger)component
    
    
    
    NSLog(@"TODO - Utiliser la classe OUtils de Doudou");
    //NSString *sParam =  [NSString  stringWithFormat:@"v.php"];

    NSString *sTrv =  [NSString  stringWithFormat:@"http://www.bdpv.fr/ajax/iBDPV/%@?",sParam];
    
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
} // Fin du-(NSString*)genere_requete:(NSArray*)paramTabString;


@end
