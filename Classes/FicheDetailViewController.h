//
//  FicheDetailViewController.h
//  iBDPV
//
//  Created by jmd on 27/08/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserData.h"

@interface FicheDetailViewController : UITableViewController <NSXMLParserDelegate> {
    
    UserData *userData;
    int userID;
    
    NSMutableString *currentStringValue;
    
    NSMutableArray *currentItems;
    NSMutableArray *currentValues;
    
    NSMutableArray *sectionsDataSource;
    NSMutableArray *itemsDataSource;
    NSMutableArray *valuesDataSource;
    
    NSMutableDictionary *dicoPhoto;
    
    
}

@property (nonatomic,retain) UserData *userData;
@property (nonatomic, assign) int userID;
//@property (nonatomic, retain) NSMutableArray *arrDataSource;
@property (nonatomic, retain) NSMutableDictionary *dicoPhoto;


//Action Back
-(void)actBack:(id)sender;

@end
