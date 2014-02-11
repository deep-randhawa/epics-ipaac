//
//  PlayIPAACTableViewController.h
//  IPAAC
//
//  Copyright 2010 Purdue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>


@interface PlayCoinTableViewController : UITableViewController {
	NSMutableArray *fileArray;

}
- (NSString *) getDBPath;
- (void) copyFileIfNeeded :(NSString *) file;

@end
