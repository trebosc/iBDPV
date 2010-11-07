//
//  TableViewControllerFromURL.h
//  iBDPV
//
//  Created by jmd on 27/08/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserData.h"


@interface TableViewControllerFromURL : UITableViewController <NSXMLParserDelegate> {
    
    UserData *userData;
    NSURL *loadingURL;
    
    
    NSMutableString *currentStringValue;
    
    NSMutableArray *currentItems;
    NSMutableArray *currentValues;
    
    NSMutableArray *sectionsDataSource;
    NSMutableArray *itemsDataSource;
    NSMutableArray *valuesDataSource;
    
    NSMutableDictionary *dicoPhoto;
    
    
}

@property (nonatomic,retain) UserData *userData;
@property (nonatomic, assign) NSURL *loadingURL;
//@property (nonatomic, retain) NSMutableArray *arrDataSource;
@property (nonatomic, retain) NSMutableDictionary *dicoPhoto;


//Action Back
-(void)actBack:(id)sender;


-(NSURL *)buildOuvreURLg:(NSArray *)params;
-(NSURL *)buildOuvreURLl2:(NSArray *)params;
-(NSURL *)buildSitesProchesURL;

@end
