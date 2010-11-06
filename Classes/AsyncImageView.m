//
//  AsyncImageView.m
//  Postcard
//
//  Created by markj on 2/18/09.
//  Copyright 2009 Mark Johnson. You have permission to copy parts of this code into your own projects for any use.
//  www.markj.net
//

#import "AsyncImageView.h"


// This class demonstrates how the URL loading system can be used to make a UIView subclass
// that can download and display an image asynchronously so that the app doesn't block or freeze
// while the image is downloading. It works fine in a UITableView or other cases where there
// are multiple images being downloaded and displayed all at the same time. 

@implementation AsyncImageView

@synthesize dicoPhoto, urlPhoto;




//#########################################################################################################################################################
//#########################################################################################################################################################
#pragma mark -
#pragma mark === Gestion du chargement de l'image ===


//-------------------------------------------------------------------------------------------------------------------------------
- (void)loadImageFromURL:(NSURL*)url {
    
    UIImage *imgPhoto=[self.dicoPhoto objectForKey:url];
    //UIImage *imgPhoto=nil;
    self.urlPhoto=url;     // On garde l'url pour s'en servir de clé pour le cache
    
    if (imgPhoto==nil) {
        //Asynchronous call
        if (connection!=nil) { [connection release]; } //in case we are downloading a 2nd image
        if (data!=nil) { [data release]; }
        

        NSURLRequest* request = [NSURLRequest requestWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 20.0];
        connection = [[NSURLConnection alloc] initWithRequest: request delegate: self startImmediately: NO];
        [connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        
        
        NSLog(@"TODO - Doit-on gérer les didFailWithError ? (sur le time-out par exemple) ?");        
        
        [connection start];
    } else { // Avec le if (imgPhoto==nil) {
        //Cached Image to make UIImageView
        [self makeImageView:imgPhoto];
        
    } // Fin du if (imgPhoto==nil) {
        
} // Fin du - (void)loadImageFromURL:(NSURL*)url {



//-------------------------------------------------------------------------------------------------------------------------------
//the URL connection calls this repeatedly as data arrives
- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)incrementalData {
	if (data==nil) { data = [[NSMutableData alloc] initWithCapacity:2048]; } 
	[data appendData:incrementalData];
} // Fin du - (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)incrementalData {


//-------------------------------------------------------------------------------------------------------------------------------
//the URL connection calls this once all the data has downloaded
- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
	//so self data now has the complete image 
	[connection release];
	connection=nil;
    
    
	if ([[self subviews] count]>0) {
		//then this must be another image, the old one is still in subviews
		[[[self subviews] objectAtIndex:0] removeFromSuperview]; //so remove it (releases it also)
	} // Fin du 	if ([[self subviews] count]>0) {

	
	//make an image view for the image
	UIImage *newImage=[UIImage imageWithData:data];
        
    //Cache UIImage
    if ([self.dicoPhoto objectForKey:self.urlPhoto]==nil) {
        [self.dicoPhoto setObject:newImage forKey:self.urlPhoto];
    } // Fin du     if ([self.dicoPhoto objectForKey:self.urlPhoto]==nil) {

    
    //ImageView
    [self makeImageView:newImage];
    
    //[newImage release];
    
	[data release]; //don't need this any more, its in the UIImageView now
	data=nil;
} // Fin du - (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {



//#########################################################################################################################################################
//#########################################################################################################################################################
#pragma mark -
#pragma mark === Fonction de gestion de l'image ===

//-------------------------------------------------------------------------------------------------------------------------------
- (void)makeImageView:(UIImage *)withImage {
    
    UIImageView* imageView = [[[UIImageView alloc] initWithImage:withImage] autorelease];
    
	//make sizing choices based on your needs, experiment with these. maybe not all the calls below are needed.
	imageView.contentMode = UIViewContentModeScaleAspectFit;
	imageView.autoresizingMask = ( UIViewAutoresizingFlexibleWidth || UIViewAutoresizingFlexibleHeight );
	[self addSubview:imageView];
	imageView.frame = self.bounds;
	[imageView setNeedsLayout];
	[self setNeedsLayout];
    
} // Fin du - (void)makeImageView:(UIImage *)withImage {


//-------------------------------------------------------------------------------------------------------------------------------
//just in case you want to get the image directly, here it is in subviews
- (UIImage*) image {
	UIImageView* iv = [[self subviews] objectAtIndex:0];
	return [iv image];
} // Fin du - (UIImage*) image {


//#########################################################################################################################################################
//#########################################################################################################################################################
#pragma mark -
#pragma mark === Fin de vie de la classe  ===

//-------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
	[connection cancel]; //in case the URL is still downloading
	[connection release];
	[data release]; 
    [super dealloc];
} // Fin du - (void)dealloc {


@end

