//
//  AsyncImageView.h
//  iBDPV
// JMD & DTR


#import <UIKit/UIKit.h>


@interface AsyncImageView : UIView {
	//could instead be a subclass of UIImageView instead of UIView, depending on what other features you want to 
	// to build into this class?
    
	NSURLConnection* connection; //keep a reference to the connection so we can cancel download in dealloc
	NSMutableData* data; //keep reference to the data so we can collect it as it downloads
                         //but where is the UIImage reference? We keep it in self.subviews - no need to re-code what we have in the parent class
	
    NSMutableDictionary *dicoPhoto;
    NSURL *urlPhoto;
    
}

@property (nonatomic, retain) NSMutableDictionary *dicoPhoto;
@property (nonatomic, retain) NSURL *urlPhoto;

- (void)loadImageFromURL:(NSURL*)url;
- (UIImage*) image;
- (void)makeImageView:(UIImage*)image;

@end
