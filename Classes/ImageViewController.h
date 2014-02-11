//
//  ImageViewController.h
//  IPAAC
//
//  Copyright 2010 Purdue University. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CreateActivityViewController;
@class CreateWebViewController;
@class CreateCoinViewController;
@class CreateSentenceViewController;
@class CreateMatchViewController;

@interface ImageViewController : UITableViewController {
	
	NSMutableArray *listOfImages;
	
	// Get path to documents directory
    // NSArray *arrayPaths;// = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    // Finds the contained Documents directory specific to this app
	//NSString  *documentsDirectory;// = [arrayPaths objectAtIndex:0]; 
    //NSString *imagesDirectory;// =  [NSString stringWithFormat:@"%@/Images", documentsDirectory];//[documentsDirectory stringByAppendingPathComponent:@""];
	//NSLog(@"Test statement 1");
    //NSError *error;
    // Create an object that we will later use to look for a file and return a boolean value on whether or not it exists
    //NSFileManager *manager;// = [NSFileManager defaultManager];
	int sheettype;

}
@property(nonatomic,retain) NSMutableArray * listOfImages;

-(void)init:(int)sheet;

@end