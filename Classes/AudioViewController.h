//
//  AudioViewController.h
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

@interface AudioViewController : UITableViewController {
		
	NSMutableArray *listOfAudio;
	int sheettype;
	
}

-(void)init:(int)sheet;

@end

