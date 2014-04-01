//
//  ActivitySheetStudioTableViewController.m
//  IPAAC
//
//  Copyright 2010 Purdue. All rights reserved.
//

#import "IPAACAppDelegate.h"
#import "CoinSheetTableViewController.h"
#import "CreateCoinViewController.h"

static sqlite3 *database = nil;

@implementation CoinSheetTableViewController

#pragma mark -
#pragma mark View lifecycle

- (void) copyFileIfNeeded: (NSString *) file
{
	BOOL success;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *docDir = [paths objectAtIndex:0];
	NSString *DBPath = [docDir stringByAppendingPathComponent:file];
	success = [fileManager fileExistsAtPath:DBPath];
	if(success) return;
	NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:file];
	success = [fileManager copyItemAtPath:defaultDBPath toPath:DBPath error:&error];
	if(!success){
		NSAssert1(0,@"Failed to copy file because '%@.'",[error localizedDescription]);
	}
}

- (NSString *) getDBPath {
	
	//Search for standard documents using NSSearchPathForDirectoriesInDomains
	//First Param = Searching the documents directory
	//Second Param = Searching the Users directory and not the System
	//Expand any tildes and identify home directories.
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:@"SQL.sqlite"];
	//NSLog(@"In AppDelegate");
	//NSString *databasePath = [[NSBundle mainBundle] pathForResource:@"SQL" ofType:@"sqlite"];
	//NSLog(@"Path in Appdelegate is %@",databasePath);
	//return databasePath;
	
	//NSData *databaseData = [NSData dataWithContentsOfFile:databasePath];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[self copyFileIfNeeded:@"SQL.sqlite"];
	
	fileArray = [[NSMutableArray alloc] initWithObjects:nil];
	[fileArray addObject:@"Create a New Item Select Sheet"];
	
	NSLog(@"Testing DB");
	NSString * dbPath = [self getDBPath];
	NSLog(@"Path is %@",dbPath);
	
	const char *sql = "select distinct fName from CoinSheets";
	sqlite3_stmt *selectstmt;
	
	if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) 
	{
		if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) 
		{
			while(sqlite3_step(selectstmt) == SQLITE_ROW)
			{
				NSString *temp_fName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt,0)];
				NSLog(@"%@",temp_fName);
				//[fileArray addObject:(NSString *)[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt,0)]];
				[fileArray addObject:(NSString *)temp_fName];
				//[temp_fName release];
			}
		}
		sqlite3_close(database); 
	}
	else 
	{
		sqlite3_close(database); //Even though the open call failed, close the database connection to release all the memory.
	}
	
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
	// Upon creating a new file as a tableViewController, this whole method is provided for us.  All we have to do is
    // uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
		
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/


//for ios6 orientation
- (BOOL)shouldAutorotate {
    
    UIInterfaceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    if (orientation == UIInterfaceOrientationLandscapeLeft  ||orientation ==  UIInterfaceOrientationLandscapeRight )
    {
        
        return YES;
    }
    return NO;
}

//for ios5 orientation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    //interfaceOrientation == UIInterfaceOrientationLandscapeRight;
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft  ||interfaceOrientation ==  UIInterfaceOrientationLandscapeRight ) {
        
        return YES;
    }
    return NO;
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [fileArray count];
}
										 


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	/*
	ActivitySheet *newActivity = [[ActivitySheet alloc] init];
	[newActivity setName:@"Create a New Activity Sheet"];
	ActivitySheet *fruits = [[ActivitySheet alloc] init];
	[fruits setName:@"Fruits"];
	ActivitySheet *coins = [[ActivitySheet alloc] init];
	[coins setName:@"Coins"];
	ActivitySheet *sports = [[ActivitySheet alloc] init];
	[sports setName:@"Sports"];
	ActivitySheet *cars = [[ActivitySheet alloc] init];
	[cars setName:@"Cars"];
	ActivitySheet *clothes = [[ActivitySheet alloc] init];
	[clothes setName:@"Clothes"];
	
	NSMutableArray *activitySheetList = [[NSMutableArray alloc] initWithObjects:newActivity, fruits, coins, sports, cars, clothes,nil];
	*/
    
    // Configure the cell...
	NSLog(@"count = %lu",(unsigned long)[fileArray count]);
	NSLog(@"%@",[fileArray objectAtIndex:indexPath.row]);
	
	cell.textLabel.text = [fileArray objectAtIndex:indexPath.row];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
		if(indexPath.row != 0)
		{
			[self removeSheet:[fileArray objectAtIndex:indexPath.row]];
			//[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			[fileArray removeObjectAtIndex:indexPath.row];
			[tableView reloadData];
		}
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

-(void) removeSheet: (NSString *) name
{
	NSLog(@"Removing Item Select Sheet %@",name);
	NSLog(@"Testing DB");
	NSString * dbPath = [self getDBPath];
	NSLog(@"Path is %@",dbPath);
	
	NSMutableString *nssql = 
	[NSMutableString stringWithString:
	 @"delete from CoinSheets where fName = "];
	[nssql appendString:[NSString stringWithFormat:@"\"%@\"",name]];
	const char *sql = [nssql UTF8String];
	
	sqlite3_stmt *deletestmt;
	
	if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) 
	{
		if(sqlite3_prepare_v2(database, sql, -1, &deletestmt, NULL) != SQLITE_OK)
			NSAssert1(0, @"Error while creating delete statement. '%s'", sqlite3_errmsg(database));
		
		if (SQLITE_DONE != sqlite3_step(deletestmt)) 
			NSAssert1(0, @"Error while deleting. '%s'", sqlite3_errmsg(database));
		sqlite3_reset(deletestmt);
		if(deletestmt) sqlite3_finalize(deletestmt);
 
	}
	else 
	{
		sqlite3_close(database); 
	}


}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	IPAACAppDelegate *appDelegate = 
	[[UIApplication sharedApplication] delegate];
	appDelegate.coinController = [[CreateCoinViewController alloc] initWithNibName:@"CreateCoinViewController" bundle:nil];
	//CreateActivityViewController *createActivityViewController = [[appDelegate.viewController alloc] initWithNibName:@"Create Activity Sheet" bundle:nil];
	CreateCoinViewController *createCoinViewController = appDelegate.coinController;//[[CreateActivityViewController alloc] initWithNibName:@"CreateActivityViewController" bundle:nil];
	//[createActivityViewController init:@"":1];

	
	if(indexPath.row == 0)
	{
		[createCoinViewController init:@"":1:fileArray];
	}
	else
	{
		[createCoinViewController init:[fileArray objectAtIndex:indexPath.row]:0:fileArray];
	}

     // ...
     // Pass the selected object to the new view controller.
    [[self navigationController] setNavigationBarHidden:YES]; //Hide navigation bar so that we can utilize toolbar created in nib 
	[self.navigationController pushViewController:createCoinViewController animated:YES];
	[createCoinViewController release];
	 
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	if(database) sqlite3_close(database);
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[fileArray release];
    [super dealloc];
}


@end

