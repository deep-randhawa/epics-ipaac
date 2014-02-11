//
//  ImageViewController.m
//  IPAAC
//
//
//  Copyright 2010 Purdue University. All rights reserved.
//

#import "ImageViewController.h"
#import "CreateCoinViewController.h"
#import "CreateActivityViewController.h"
#import "IPAACAppDelegate.h"


@implementation ImageViewController

@synthesize listOfImages;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
	//--added these--
	//---initialize the array---
	[super viewDidLoad];
	// Get path to documents directory
	NSArray* arrayPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    // Finds the contained Documents directory specific to this app
	NSString* documentsDirectory = [arrayPaths objectAtIndex:0]; 
	NSString* imagesDirectory =  [NSString stringWithFormat:@"%@/images", documentsDirectory];//[documentsDirectory stringByAppendingPathComponent:@""];
	NSLog(@"Image view controller - imgDir = %@", imagesDirectory);
	
    // Create an object that we will later use to look for a file and return a boolean value on whether or not it exists
	NSFileManager*manager = [NSFileManager defaultManager];
	NSError *error;
	[listOfImages release];
	listOfImages = [[NSMutableArray alloc] initWithArray:[manager contentsOfDirectoryAtPath:imagesDirectory error:&error]];
	//listOfImages = [[manager contentsOfDirectoryAtPath:imagesDirectory error:&error] retain];	
	NSLog(@"List of images = %@",listOfImages);
	
    // Uncomment the following line to preserve selection between presentations.
	self.clearsSelectionOnViewWillAppear = YES;
}

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
	// added the 1
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	NSLog(@"listofImages count: %d",[listOfImages count]);
    return [listOfImages count];//added the count of the items in the array
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"table load test");
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	//NSLog(@"table load test 2");
	
    // Configuring the cell
    //added this
	cell.textLabel.text = [listOfImages objectAtIndex:indexPath.row];
	
	NSString *imageName = [NSString stringWithFormat:@"%@",[listOfImages objectAtIndex:indexPath.row]];//Creates name of reference 
	
	// Get path to documents directory
	
	NSArray* arrayPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	
    // Finds the contained Documents directory specific to this app
	
	NSString* documentsDirectory = [arrayPaths objectAtIndex:0]; 
	
	
	NSString *tempImagePath = [NSString stringWithFormat:@"%@/images/%@", documentsDirectory,imageName];
	//NSLog(@"Image path:%@",tempImagePath);
	
	UIImage *tempImage = [UIImage imageWithContentsOfFile:tempImagePath];
	
	[cell.imageView setImage:tempImage];
	cell.imageView.highlightedImage = tempImage;
	//[tempImage release];
    return cell;
}

-(void)init:(int)sheet{
	sheettype = sheet;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	//When a row is selected, set the detail view controller’s detail item to the item associated with the selected row.
    IPAACAppDelegate *appDelegate = 
	[[UIApplication sharedApplication] delegate];
	
	switch (sheettype) {
		case 0:
			[appDelegate.viewController.detailImage release];
			appDelegate.viewController.detailImage = [listOfImages objectAtIndex:indexPath.row];
			NSLog(@"Detail Image:%@",[appDelegate.viewController.detailImage description]);
			break;
	/*	case 1:
			[appDelegate.webController.detailImage release];
			appDelegate.webController.detailImage = [listOfImages objectAtIndex:indexPath.row];
			NSLog(@"Detail Image:%@",[appDelegate.webController.detailImage description]);
			break;
		case 2:
			[appDelegate.matchController.detailImage release];
			appDelegate.matchController.detailImage = [listOfImages objectAtIndex:indexPath.row];
			NSLog(@"Detail Image:%@",[appDelegate.matchController.detailImage description]);
			break;
		case 3:
			[appDelegate.sentenceController.detailImage release];
			appDelegate.sentenceController.detailImage = [listOfImages objectAtIndex:indexPath.row];
			NSLog(@"Detail Image:%@",[appDelegate.sentenceController.detailImage description]);
			break;
*/		case 4:
			[appDelegate.coinController.detailImage release];
			appDelegate.coinController.detailImage = [listOfImages objectAtIndex:indexPath.row];
			NSLog(@"Detail Image:%@",[appDelegate.coinController.detailImage description]);
			break;
		default:
			break;
	}

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
	[listOfImages release];
}


- (void)dealloc {
	//added this
	//[detailViewController release];
	//already here
    [super dealloc];
}

@end

