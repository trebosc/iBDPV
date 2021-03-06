//
//  TableViewControllerFromURL.h
//  iBDPV
// JMD & DTR


#import <UIKit/UIKit.h>
#import "UserData.h"


@interface TableViewControllerFromURL : UITableViewController <NSXMLParserDelegate> {
    
    UserData *userData;
    NSURL *loadingURL;
    
    
    NSMutableString *currentStringValue;
    NSString *currentAide;
    
    NSMutableArray *currentItems;
    NSMutableArray *currentValues;
    NSMutableArray *currentAides;
    
    NSMutableArray *sectionsDataSource;
    NSMutableArray *itemsDataSource;
    NSMutableArray *valuesDataSource;
    NSMutableArray *aidesDataSource;
    
    NSMutableDictionary *dicoPhoto;
    
    UIActivityIndicatorView *activityIndicator;
    
    
}

@property (nonatomic,retain) UserData *userData;
@property (nonatomic, assign) NSURL *loadingURL;
//@property (nonatomic, retain) NSMutableArray *arrDataSource;
@property (nonatomic, retain) NSMutableDictionary *dicoPhoto;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;

//Action Back
-(void)actBack:(id)sender;

-(void)displayNextScreen:(NSIndexPath *)indexPath;

-(NSURL *)buildOuvreURLg:(NSArray *)params;
-(NSURL *)buildSitesProchesURL;

@end
