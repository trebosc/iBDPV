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



-(NSString*)md5:(NSString *)paramString;
{
    const char *cStr = [paramString UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), result );
    NSLog(@"Mettre dans une classe OUTILS  avec cryptage signature");
    
    return [NSString  stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4],
            result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12],
            result[13], result[14], result[15]
            ];
}

@end
