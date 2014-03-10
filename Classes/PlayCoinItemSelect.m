//
//  PlayActivitySheet.m
//  Play the selected activity sheet
//
//  Copyright 2010 Purdue. All rights reserved.
//

#import "PlayCoinItemSelect.h"
#import "frameArray.h"
#import "CoinViewController.h"

static sqlite3 *database = nil;

@implementation PlayCoinItemSelect

@synthesize price;

-(id) init:(NSString *)select
{
	selected_sheet = [NSString stringWithFormat:@"\"%@\"",select];
	NSLog(@"%@",selected_sheet);
	return self;
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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	NSLog(@"InView did load");
	
	NSLog(@"Testing DB");
	NSString * dbPath = [self getDBPath];
	NSLog(@"Path is %@",dbPath);
	
	NSString *imName[16];
	NSString *auName[16];
	NSString *auExt[16];
	
	frameArray *fArray =[frameArray new];
    price = [[NSMutableArray alloc] init];
	
	for (int j = 0; j < 16; j++)
	{
		imName[j] = @"blank.jpg"; //replace with empty image
		auName[j] = @"blank";	  //replace with empty sound
		auExt[j] = @"wav";		  //replace with empty sound extension
		[price addObject:@""];
        
       // price[j] = @"";
		
	}
	
	//SQLAppDelegate *appDelegate = (SQLAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	
	if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) 
	{
		
		//const char *sql = "select  imName,auName,auEXT from ActivitySheets where fName=\"Fruit\"";
		
		//Selected sheet to load goes here in this format
		
		//Converts NSMutableString containing sql statement to const char for use
		NSMutableString *nssql = 
		[NSMutableString stringWithString:
		 @"select imName,price from CoinSheets where fName = "];
		[nssql appendString:selected_sheet];
		const char *sql = [nssql UTF8String];
		
		sqlite3_stmt *selectstmt;
		int i=0;
		if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) 
		{
			
			while(sqlite3_step(selectstmt) == SQLITE_ROW) {
				
				//NSInteger primaryKey = sqlite3_column_int(selectstmt, 0);
				//Stuff *stuffObj = [[Stuff alloc] initWithPrimaryKey:primaryKey];
				//stuffObj.fName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 1)];
				
				//stuffObj.isDirty = NO;
				
				//[appDelegate.fileArray addObject:stuffObj];
				//[stuffObj release];
				NSString *temp_imName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 0)];
				NSString *temp_price = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 1)];
				imName[i]=temp_imName;
				//[price addObject:temp_price];
                [price insertObject:temp_price atIndex:i];
                //price[i]=temp_price;
				NSLog(@"%@ %@",temp_imName,temp_price);
				i++;
                
               
				
			}
			NSLog(@"Count is %d",i);
			[fArray setButtonNumber: i];
			NSLog(@"(%d %d %d %d)\n",[fArray getVal: 0:0],[fArray getVal: 0:1],[fArray getVal: 0:2],[fArray getVal: 0:3]);
		}
		sqlite3_close(database);
        
	}
	else
	{
		sqlite3_close(database); //Even though the open call failed, close the database connection to release all the memory.
	}
	
	
	
    // Get path to documents directory
    NSArray *arrayPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    // Finds the contained Documents directory specific to this app
    NSString *documentsDirectory = [arrayPaths objectAtIndex:0];  
    
                                                
	UIButton *ButtonArr[16];
	UIImage *buttonImage[16];

	
	//int init=0;
	for (int init = 0; init<16; init++) {
        //
		NSLog(@"Creating UIButtons %d", init);
		ButtonArr[init] = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        //Create array with image file path and filename
        imageFile[init] = [NSString stringWithFormat:@"%@/images/%@", documentsDirectory,imName[init]];
        
        //Create the array which stores the UIImages for the icon backgrounds
        buttonImage[init] = [UIImage imageWithContentsOfFile: imageFile[init]];
        
		NSLog(@"Creating UIImages for button background %d", init);
    }  //end setting icon background image 
    
	
	int x1, x2, y1, y2;
	UILabel *LabelArr[16];
	
	for (int i=0; i<16; i++) {
		
		x1 = [fArray getVal:i :0];
		y1 = [fArray getVal:i :1];
		x2 = [fArray getVal:i :2];
		y2 = [fArray getVal:i :3];
		
		ButtonArr[i].frame = CGRectMake(x1, y1-60, x2, y2);
		NSLog(@"Button = (%d,%d,%d,%d)", x1, y1-60, x2, y2);
		
		[ButtonArr[i] setBackgroundImage:buttonImage[i] forState:UIControlStateNormal];
		[ButtonArr[i] setBackgroundImage:buttonImage[i] forState:UIControlStateHighlighted];
		[self.view addSubview:ButtonArr[i]];
		
		x1 = [fArray getLabelVal:i :0];
		y1 = [fArray getLabelVal:i :1];
		//add labels here
		LabelArr[i] = [[UILabel alloc] initWithFrame:CGRectMake(x1,y1-60,230,12)] ;
		LabelArr[i].text = [price objectAtIndex:i];//price[i];
		LabelArr[i].textAlignment = UITextAlignmentCenter;
		int label_y;
		label_y = [fArray getVal:i :1]+[fArray getVal:i :3];
		
		LabelArr[i].frame = CGRectMake([fArray getVal:i :0],
									   label_y-60,
									   [fArray getVal:i :2],
									   12);
		
		[self.view addSubview:LabelArr[i]];
		
		
	} //end for
	
	//Set button click action to play associated sound
	[ButtonArr[0] addTarget:self action:@selector(itemSelect:) 
		   forControlEvents:UIControlEventTouchUpInside];
	ButtonArr[0].tag = 0;
	
	[ButtonArr[1] addTarget:self action:@selector(itemSelect:) 
		   forControlEvents:UIControlEventTouchUpInside];
	ButtonArr[1].tag = 1;
	
	[ButtonArr[2] addTarget:self action:@selector(itemSelect:) 
		   forControlEvents:UIControlEventTouchUpInside];
	ButtonArr[2].tag = 2;
	
	[ButtonArr[3] addTarget:self action:@selector(itemSelect:) 
		   forControlEvents:UIControlEventTouchUpInside];
	ButtonArr[3].tag = 3;
	
	[ButtonArr[4] addTarget:self action:@selector(itemSelect:) 
		   forControlEvents:UIControlEventTouchUpInside];
	ButtonArr[4].tag = 4;
	
	[ButtonArr[5] addTarget:self action:@selector(itemSelect:) 
		   forControlEvents:UIControlEventTouchUpInside];
	ButtonArr[5].tag = 5;
	
	[ButtonArr[6] addTarget:self action:@selector(itemSelect:) 
		   forControlEvents:UIControlEventTouchUpInside];
	ButtonArr[6].tag = 6;
	
	[ButtonArr[7] addTarget:self action:@selector(itemSelect:) 
		   forControlEvents:UIControlEventTouchUpInside];
	ButtonArr[7].tag = 7;
	
	[ButtonArr[8] addTarget:self action:@selector(itemSelect:) 
		   forControlEvents:UIControlEventTouchUpInside];
	ButtonArr[8].tag = 8;
	
	[ButtonArr[9] addTarget:self action:@selector(itemSelect:) 
		   forControlEvents:UIControlEventTouchUpInside];
	ButtonArr[9].tag = 9;
	
	[ButtonArr[10] addTarget:self action:@selector(itemSelect:) 
		   forControlEvents:UIControlEventTouchUpInside];
	ButtonArr[10].tag = 10;
	
	[ButtonArr[11] addTarget:self action:@selector(itemSelect:) 
		   forControlEvents:UIControlEventTouchUpInside];
	ButtonArr[11].tag = 11;
	
	[ButtonArr[12] addTarget:self action:@selector(itemSelect:) 
		   forControlEvents:UIControlEventTouchUpInside];
	ButtonArr[12].tag = 12;
	
	[ButtonArr[13] addTarget:self action:@selector(itemSelect:) 
		   forControlEvents:UIControlEventTouchUpInside];
	ButtonArr[13].tag = 13;
	
	[ButtonArr[14] addTarget:self action:@selector(itemSelect:) 
		   forControlEvents:UIControlEventTouchUpInside];
	ButtonArr[14].tag = 14;
	
	[ButtonArr[15] addTarget:self action:@selector(itemSelect:) 
		   forControlEvents:UIControlEventTouchUpInside];
	ButtonArr[15].tag = 15;
	
	[fArray release];
	[super viewDidLoad];
	NSLog(@"End viewDidLoad");
    
}

//Set up the action to play the systemSoundIDs.  These actions will be linked to a button press for activity mode.  Sound clips must be .caf, .aif, or .wav 
-(IBAction) itemSelect:(id) sender {
	UIButton * temp=sender;
    selected_item = imageFile[temp.tag];
    //item_price = price[temp.tag];
    NSLog(@" price objectAtIndex:temp.tag is %@",[price objectAtIndex:temp.tag]);
    item_price = [price objectAtIndex:temp.tag];//[temp.tag];
    NSLog(@"Item price in PLayCoinitemselect is: %@",item_price);
   NSString * stringCheck = @"Sold Out";
	if ([item_price isEqualToString:stringCheck]){
		UIAlertView *sold = [[UIAlertView alloc] initWithTitle:@"Sold Out" 
													  message:@"The item you selected is not available."
													 delegate:nil 
											cancelButtonTitle:@"OK" 
											otherButtonTitles: nil];
		[sold show];
		[sold release];
	}else{
	//CHANGE: The following referring to alert was commented out in order to get rid of the alert
	
	//UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure you want this Item?" message:@""
												   //delegate:self cancelButtonTitle:@"Cancel"  otherButtonTitles:@"Yes", nil];
	
	//[alert show];
	//[textfieldName release];
	//[alert release];

//}

//- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {

    //if (buttonIndex == 1) {
		// Navigation logic may go here. Create and push another view controller.
		
		CoinViewController *detailViewController = [[CoinViewController alloc] initWithNibName:@"CoinViewController" bundle:nil];
		[detailViewController init:selected_item :item_price];
		
		// ...
		// Pass the selected object to the new view controller.
		[[self navigationController] setNavigationBarHidden:YES animated:YES];
		[self.navigationController  pushViewController:detailViewController animated:YES];
		//[detailViewController release];
	//}
	}
}



// Override to allow orientations other than the default portrait orientation.
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


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (IBAction) unlockButton {
	[[self navigationController] setNavigationBarHidden:NO animated:YES];
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    [super dealloc];
}

@end
