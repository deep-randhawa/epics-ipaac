//
//  ActivitySheetStudioTableViewController.h
//  IPAAC
//
//  Copyright 2010 Purdue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>


@interface CoinSheetTableViewController : UITableViewController {
	NSMutableArray *fileArray;
}
- (void) removeSheet:(NSString *)name;
- (void) copyFileIfNeeded:(NSString *)file;
- (NSString *) getDBPath;
@end
