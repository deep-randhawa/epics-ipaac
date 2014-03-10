//
//  AudioViewController.m
//  IPAAC
//
//  Copyright 2010 Purdue University. All rights reserved.
//

#import "AudioViewController.h"
#import "CreateActivityViewController.h"
#import "CreateCoinViewController.h"
#import "IPAACAppDelegate.h"

@implementation AudioViewController


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
	[super viewDidLoad];
//--added these--
	//---initialize the array---
	// Get path to documents directory
    NSArray *arrayPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    // Finds the contained Documents directory specific to this app
    NSString *documentsDirectory = [arrayPaths objectAtIndex:0]; 
    NSString *audioDirectory =  [NSString stringWithFormat:@"%@/audio", documentsDirectory];
	NSLog(@"Audio dir path = %@", audioDirectory);
    NSError *error;
    // Create an object that we will later use to look for a file and return a boolean value on whether or not it exists
    NSFileManager *manager = [NSFileManager defaultManager];
    // File we want to move, stored in original top level directory	
	NSLog(@"Audio directory: %@",
		  [manager contentsOfDirectoryAtPath:audioDirectory error:&error]);
	
	listOfAudio = [[manager contentsOfDirectoryAtPath:audioDirectory error:&error] retain];

    // Uncomment the following line to preserve selection between presentations.
       self.clearsSelectionOnViewWillAppear = YES;
}

//for ios6 orientation

- (BOOL)shouldAutorotate {
    
    
    
    UIInterfaceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    
    
    if (orientation == UIInterfaceOrientationLandscapeLeft  || orientation ==  UIInterfaceOrientationLandscapeRight )
        
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
	// added the 1
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	
    return [listOfAudio count];//added the count of the items in the array
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configuring the cell
    //added this
	cell.textLabel.text = [listOfAudio objectAtIndex:indexPath.row];

    return cell;
}


-(void) init:(int)sheet{
	sheettype=sheet;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {    
	//When a row is selected, set the detail view controller’s detail item to the item associated with the selected row.
	IPAACAppDelegate *appDelegate = 
	[[UIApplication sharedApplication] delegate];
	
	switch (sheettype) {
		case 0:
			[appDelegate.viewController.detailAudio release];
			appDelegate.viewController.detailAudio = 
			[listOfAudio objectAtIndex:indexPath.row];
			break;
/*		case 1:
			[appDelegate.webController.detailAudio release];
			appDelegate.webController.detailAudio = 
			[listOfAudio objectAtIndex:indexPath.row];
			break;
		case 2:
			[appDelegate.matchController.detailAudio release];
			appDelegate.matchController.detailAudio = 
			[listOfAudio objectAtIndex:indexPath.row];
			break;
		case 3:
			[appDelegate.sentenceController.detailAudio release];
			appDelegate.sentenceController.detailAudio = 
			[listOfAudio objectAtIndex:indexPath.row];
			break;
*/		case 4:
			[appDelegate.coinController.detailAudio release];
			appDelegate.coinController.detailAudio = 
			[listOfAudio objectAtIndex:indexPath.row];
			break;
		default:
			break;
	}
		
	//NSLog(@"List Audio:%@",[listOfAudio objectAtIndex:indexPath.row]);
	
	NSLog(@"Detail Audio:%@",[NSString stringWithFormat:@"%@",appDelegate.viewController.detailAudio]);
 
//[appDelegate release];
	
}
		 

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	//added this
	//[listOfAudio release];
	
	//already here
    [super dealloc];
}


@end

