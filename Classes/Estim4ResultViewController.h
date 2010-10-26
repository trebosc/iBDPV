//
//  Estim4ResultViewController.h
//  iBDPV
//
//  Created by jmd on 01/08/10.
//  Copyright 2010 __MaCoDa__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserData.h"

@interface Estim4ResultViewController : UITableViewController <NSXMLParserDelegate> {
  
    UserData *userData;
    
    NSMutableString *currentStringValue;
    
    NSMutableArray *currentItems;
    NSMutableArray *currentValues;
    
    NSMutableArray *sectionsDataSource;
    NSMutableArray *itemsDataSource;
    NSMutableArray *valuesDataSource;
    NSMutableDictionary *dicoPhoto;
    

}

@property (nonatomic,retain) UserData *userData;
@property (nonatomic, retain) NSMutableDictionary *dicoPhoto;


//Action Back
-(void)actBack:(id)sender;
//Action Validate
-(void)actValidate:(id)sender;

@end
