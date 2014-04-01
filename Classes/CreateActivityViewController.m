//
//  CreateActivityViewController.m
//  CreateActivity
//
//  Copyright 2010 Purdue. All rights reserved.
//

#import "IPAACAppDelegate.h"// addded to include "global" viewController for the PopoverView
#import "CreateActivityViewController.h"
#import "frameArray.h"
#import "RecordingTestViewController.h"
#import "ImageViewController.h" //includes the seperate tableviews for audio and images
#import "AudioViewController.h"

static sqlite3 *database = nil;

@implementation CreateActivityViewController
@synthesize imageController,audioController,popover,editSelect;
@synthesize detailAudio,detailImage;
@synthesize currentButton;

- (void) saveSheet;
{
	NSString * dbPath = [self getDBPath];
	
	
	if(dirty == 0) //If editing already created sheet
	{
		if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
		{
			sqlite3_stmt *updateStmt;
			sqlite3_stmt *deleteStmt;
			sqlite3_stmt *addStmt;
			
			for(int i = 0; i <=15; i++)
			{
				
				if(i+1 > numIcons && lineID[i][0] != 0)
				{
					NSMutableString *nssql = 
					[NSMutableString stringWithString:
					 @"delete from ActivitySheets where lineID = "];
					[nssql appendString:[NSString stringWithFormat:@"%d",lineID[i][0]]];
					const char *sql = [nssql UTF8String];
					NSLog(@"Deleting line %d, %@",lineID[i][0],nssql);
					
					if(sqlite3_prepare_v2(database, sql, -1, &deleteStmt, NULL) != SQLITE_OK)
						NSAssert1(0, @"Error while creating delete statement. '%s'", sqlite3_errmsg(database));
					
					if (SQLITE_DONE != sqlite3_step(deleteStmt)) 
						NSAssert1(0, @"Error while deleting. '%s'", sqlite3_errmsg(database));
					sqlite3_reset(deleteStmt);
				}
				else if(i+1 > numIconsOld && numIcons > numIconsOld && i+1 <= numIcons)
				{
					NSLog(@"adding new line to %@",editsheet);
					NSMutableString *nssql = 
					[NSMutableString stringWithString:
					 @"insert into ActivitySheets(fName,imName,auName,auEXT,text) Values("];
					[nssql appendString:[NSString stringWithFormat:@"%@,\"%@\",\"%@\",\"%@\",\"%@\")",editsheet,imName[i],auName[i],auExt[i],text[i]]];
					const char *sql = [nssql UTF8String];
					
					if(sqlite3_prepare_v2(database, sql, -1, &addStmt, NULL) != SQLITE_OK)
						NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
					
					
					if(SQLITE_DONE != sqlite3_step(addStmt))
						NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
					sqlite3_reset(addStmt);
				}
				else if(lineID[i][1] != 0)
				{
					NSMutableString *nssql =
					[NSMutableString stringWithFormat:@"update ActivitySheets set imName=\"%@\",auName=\"%@\",auExt=\"%@\",text=\"%@\" where lineID=%d",
					 imName[i],auName[i],auExt[i],text[i],lineID[i][0]];
					const char *sql = [nssql UTF8String];
					
					if(sqlite3_prepare_v2(database, sql, -1, &updateStmt, NULL) != SQLITE_OK)
						NSAssert1(0, @"Error while creating update statement. '%s'", sqlite3_errmsg(database));
					
					NSLog(@"%@",nssql);
					
					if (SQLITE_DONE != sqlite3_step(updateStmt)) 
						NSAssert1(0, @"Error while updating. '%s'", sqlite3_errmsg(database));
					
					NSLog(@"%@",nssql);
					
					sqlite3_reset(updateStmt);
					lineID[i][1]=0;
				}
			}
			NSLog(@"done updating");
		}
		else
		{
			sqlite3_close(database);
		}
		
	}
	else //If editing new sheet
	{	
		//Check for already existing files
		for(int i = 0;i < [fileList count];i++)
		{
			NSLog(@"%@ == %@",editsheet, [fileList objectAtIndex:i]);
			if([editsheet isEqualToString:[fileList objectAtIndex:i]])
			{
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR!" message:@"File already exists!"
															   delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
				
				[alert show];
				[alert release];
				NSLog(@"Error file already exists");
				return;
			}
			else
			{
				NSLog(@"%d",i);
			}			
		}
		
		//Save if no file exists with that name
		if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) 
		{
			sqlite3_stmt *addStmt;
			
			for(int i = 0; i<numIcons; i++)
			{
				NSMutableString *nssql = 
				[NSMutableString stringWithString:
				 @"insert into ActivitySheets(fName,imName,auName,auEXT,text) Values("];
				[nssql appendString:[NSString stringWithFormat:@"\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",editsheet,imName[i],auName[i],auExt[i],text[i]]];
				const char *sql = [nssql UTF8String];
				
				if(sqlite3_prepare_v2(database, sql, -1, &addStmt, NULL) != SQLITE_OK)
					NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
				
				
				if(SQLITE_DONE != sqlite3_step(addStmt))
					NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
				//else
				//SQLite provides a method to get the last primary key inserted by using sqlite3_last_insert_rowid
				//fileID = sqlite3_last_insert_rowid(database);
			}
			
			//Reset the add statement.
			sqlite3_reset(addStmt);
		}
		else 
		{
			sqlite3_close(database);
		}
		//[[self navigationController] setNavigationBarHidden:NO animated:YES]; 
		//[self.navigationController popViewControllerAnimated:YES];
		
	}
	
}

- (id) init :(NSString *)select :(int) clean :(NSMutableArray *) files
{
	fileList = [[NSArray alloc] initWithArray:files];
	//fileList = [[NSArray alloc] initWithArray:[files mutableCopy]];
	editsheet = [[NSString stringWithFormat:@"\"%@\"",select] mutableCopy];
	dirty = clean;
	return self;
}

//Function which returns the path to the SQL Database
- (NSString *) getDBPath {
	
	//Search for standard documents using NSSearchPathForDirectoriesInDomains
	//First Param = Searching the documents directory
	//Second Param = Searching the Users directory and not the System
	//Expand any tildes and identify home directories.
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:@"SQL.sqlite"];
	
	//NSLog(@"In getDBPath()");
	//NSString *databasePath = [[NSBundle mainBundle] pathForResource:@"SQL" ofType:@"sqlite"];
	//NSLog(@"Path in Appdelegate is %@",databasePath);
	
	//return databasePath;
	
	//NSData *databaseData = [NSData dataWithContentsOfFile:databasePath];
}

/*
 - (BOOL) textFieldShouldReturn:(UITextField *)textField
 {
 NSLog(@"test");
 editsheet = textField.text;
 [textField resignFirstResponder];
 return YES;
 }*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSLog(@"InView did load");
	
	for (int j = 0; j < 16; j++)
	{
		NSLog(@"Creating UIButtons %d", j);
		ButtonArr[j] = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
		NSLog(@"Creating UIImages for button background %d", j);
		buttonImage[j] = [UIImage imageNamed:@"blank.png"]; 
		
		text[j] = @"text here";
        
		imName[j] = @"blank.png";
		auName[j] = @"blank";	  //replace with empty sound
		auExt[j] = @"wav";		  //replace with empty sound extension
		lineID[j][0] = 0;
		lineID[j][1] = 0;
	}
	
	NSLog(@"editsheet = %@",editsheet);
	NSLog(@"dirty = %d",dirty);
	
	if(dirty == 0)
	{
		NSLog(@"Editing Sheet %@",editsheet);
		//NSLog(@"Testing DB");
		NSString * dbPath = [self getDBPath];
		//NSLog(@"Path is %@",dbPath);
		
		if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) 
		{
			
			
			//Converts NSMutableString containing sql statement to const char for use
			NSMutableString *nssql = 
			[NSMutableString stringWithString:
			 @"select lineID,imName,auName,auEXT,text from ActivitySheets where fName = "];
			[nssql appendString:editsheet];
			const char *sql = [nssql UTF8String];
			
			NSLog(@"%@",nssql);
			
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
					NSString *temp_lineID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 0)];
					NSString *temp_imName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 1)];
					NSString *temp_auName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 2)];
					NSString *temp_auExt = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 3)];
					NSString *temp_text = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 4)];
					lineID[i][0] = [temp_lineID intValue];
					lineID[i][1] = 0;
					imName[i]=[temp_imName mutableCopy];
					auName[i]=[temp_auName mutableCopy];
					auExt[i]=[temp_auExt mutableCopy];
					text[i]=[temp_text mutableCopy];
					//NSLog(@"%@ %@ %@",temp_imName,temp_auName,temp_auExt);
					i++;
					
				}
				NSLog(@"Count is %d",i);
				numIcons = i;
				numIconsOld = i;
			}
		}
		else
		{
			NSLog(@"error...");
			numIcons = 3;
			sqlite3_close(database); //Even though the open call failed, close the database connection to release all the memory.
		}
		
	}
	else
	{
		selectAlert = 0;
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Enter Informations" message:@""
													   delegate:self cancelButtonTitle:@"Cancel"  otherButtonTitles:@"Submit", nil];
		//stuff
        
//		//[alert alert.alertViewStyle = UIAlertViewStylePlainTextInput;
//        UITextField * alertTextField = [alert textFieldAtIndex:0];
//        alertTextField.keyboardType = UIKeyboardTypeNumberPad;
//        alertTextField.placeholder = @"Enter your name";
//        [alert show];
//        [alert release];:@"" label:@"Enter Filename"];
		
        //UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Hello!" message:@"Please enter your name:" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField * alertTextField = [alert textFieldAtIndex:0];
        alertTextField.keyboardType = UIKeyboardTypeNumberPad;
        alertTextField.placeholder = @"Enter file name";
//        [alert show];
//        [alert release];

		//End stuff
        // Username
		textfieldName = [alert textFieldAtIndex:0];
		textfieldName.keyboardType = UIKeyboardTypeAlphabet;
		textfieldName.keyboardAppearance = UIKeyboardAppearanceAlert;
		textfieldName.autocorrectionType = UITextAutocorrectionTypeNo;
		
		[alert show];
		//[textfieldName release];
		[alert release];
		numIcons = 3;
	}
	
	
	//Create an array which will hold the parameters for our icons
	fArray = [frameArray new];
	
    //Depending on the value of numIcons, store the appropriate values for the frameArray parameters
    [fArray setButtonNumber: numIcons];
    
	int x1, x2, y1, y2;
    
    NSString *imageFile[16];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	
	for (int i=0; i<=15; i++) 
	{
		x1 = [fArray getVal:i :0];
		y1 = [fArray getVal:i :1];
		x2 = [fArray getVal:i :2];
		y2 = [fArray getVal:i :3];
		
		ButtonArr[i].frame = CGRectMake(x1, y1, x2, y2);
		ButtonArr[i].tag = i;//tags each button with its index position
		[ButtonArr[i] addTarget:self action:@selector(chooseEdit:) forControlEvents:UIControlEventTouchUpInside];
		NSLog(@"Button = (%d,%d,%d,%d)", x1, y1, x2, y2);
		//NSLog(@"ButtonArr[i].tag = %d",ButtonArr[i].tag);
        
        //Create array with image file path and filename
        imageFile[i] = [NSString stringWithFormat:@"%@/images/%@", documentsDir,imName[i]];
        
        //Create the array which stores the UIImages for the icon backgrounds
        buttonImage[i] = [UIImage imageWithContentsOfFile:imageFile[i]];
		
		[ButtonArr[i] setBackgroundImage:buttonImage[i] forState:UIControlStateNormal];
		[ButtonArr[i] setBackgroundImage:buttonImage[i] forState:UIControlStateHighlighted];
		[ButtonArr[i] setBackgroundImage:buttonImage[i] forState:UIControlStateReserved];
		[ButtonArr[i] setBackgroundImage:buttonImage[i] forState:UIControlStateDisabled];
		[self.view addSubview:ButtonArr[i]];
		
		x1 = [fArray getLabelVal:i :0];
		y1 = [fArray getLabelVal:i :1];
		//add labels here
		LabelArr[i] = [[UILabel alloc] initWithFrame:CGRectMake(x1,y1,230,12)] ;
		LabelArr[i].text = text[i];
		LabelArr[i].textAlignment = UITextAlignmentCenter;
		int label_y;
		label_y = [fArray getVal:i :1]+[fArray getVal:i :3];
		LabelArr[i].font = [UIFont fontWithName:@"Helvetica" size: 30];
		
		LabelArr[i].frame = CGRectMake([fArray getVal:i :0],
									   label_y,
									   [fArray getVal:i :2],
									   35);
		
		[self.view addSubview:LabelArr[i]];
		
	} //end for
	
    
    //Create button which adds an icon onto activity sheet
	UIButton *addButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	addButton.frame = CGRectMake(425,45,55,55); 
    UIImage *buttonImage1 = [UIImage imageNamed:@"Add.png"];
    [addButton setBackgroundImage:buttonImage1 forState:UIControlStateNormal];
    UIImage *buttonImage2 = [UIImage imageNamed:@"AddSelected.png"];
    [addButton setBackgroundImage:buttonImage2 forState:UIControlStateHighlighted];
    addButton.tag = numIcons;
	[addButton addTarget:self action:@selector(pressAdd:) 
		forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:addButton];
	
    //Create button which removes an icon from activity sheet
	UIButton *subButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	subButton.frame = CGRectMake(535,45,55,55);
    UIImage *buttonImage3 = [UIImage imageNamed:@"Remove.png"];
    [subButton setBackgroundImage:buttonImage3 forState:UIControlStateNormal];
    UIImage *buttonImage4 = [UIImage imageNamed:@"RemoveSelected.png"];
    [subButton setBackgroundImage:buttonImage4 forState:UIControlStateHighlighted];
	subButton.tag = numIcons;
	[subButton addTarget:self action:@selector(pressSub:) 
		forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:subButton];	
	
	[super viewDidLoad];
	NSLog(@"End viewDidLoad");
}


/* Original back button -- does not refresh table view when returning to previous view
 //Button which pops the current view off the navigation controller stack in order to go back to the previous view
 - (IBAction) goBack{
 [[self navigationController] setNavigationBarHidden:NO animated:YES]; 
 [self.navigationController popViewControllerAnimated:YES];
 }
 */


//Button which pops 2 views off the navigation controller stack in order to go back to view 1 from view 3
- (IBAction) goBack{
    UINavigationController *navController = self.navigationController;
    [[self navigationController] setNavigationBarHidden:NO]; //Show the navigation bar on view 2
	
	//Pop view 3 (Create/Edit Activity) off stack without animation, then pop view 2 (Create/Edit Table View)
	//off the stack to return back to the main menu
    [navController popViewControllerAnimated:NO];
    [navController popViewControllerAnimated:YES];
	
}

//Allocate memory for the RecordAudio view and push it onto the navigation controller's stack
-(IBAction)recordAudio{
	//the first step for switching views is to initialize the next view controller to be placed on the stack
	RecordingTestViewController *recordingViewController = [[RecordingTestViewController alloc] init];
	
	//Next tell the navigation controller to push the view onto the stack and animate the views changing.
	[self.navigationController pushViewController:recordingViewController animated:YES];
	
	//Finally release the view controller pointer because the navigation controller now knows what is on the stack.
	[recordingViewController release];
}

-(IBAction) pressSave
{
	selectAlert = 2;
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure you want to Save?" message:@""
												   delegate:self cancelButtonTitle:@"Cancel"  otherButtonTitles:@"Yes", nil];
	
	[alert show];
	[alert release];
}


-(void) pressAdd:(id)sender{
	if (numIcons <=15)
	{
		numIcons+=1;
		NSLog(@"%d",numIcons);
		[fArray setButtonNumber: numIcons];
		int x1, x2, y1, y2,label_y;
		float z;
		
		for (int i=0; i<=15; i++) 
		{
			x1 = [fArray getVal:i :0];
			y1 = [fArray getVal:i :1];
			x2 = [fArray getVal:i :2];
			y2 = [fArray getVal:i :3];
			NSLog(@"%i %i %i %i",x1,y1,x2,y2);
			
			ButtonArr[i].frame = CGRectMake(x1, y1, x2, y2);
			
			{
				if ( numIcons<=8 )
				{ z = 30;  }
				if ( numIcons>=9 && numIcons<=12)
				{ z = 20; }
				else if ( numIcons>=13 )
				{ z = 12; }
				
			}
			
			
			LabelArr[i].font = [UIFont fontWithName:@"Helvetica" size: z];
			
			label_y = [fArray getVal:i :1]+[fArray getVal:i :3];
			
			{
				if ( numIcons<=8 )
				{ LabelArr[i].frame = CGRectMake([fArray getVal:i :0],
												 label_y,
												 [fArray getVal:i :2],
												 30);
				}
				if ( numIcons>=9 && numIcons<=12)
				{ LabelArr[i].frame = CGRectMake([fArray getVal:i :0],
												 label_y,
												 [fArray getVal:i :2],
												 20);
				}
				else if ( numIcons>=13 )
				{ LabelArr[i].frame = CGRectMake([fArray getVal:i :0],
												 label_y,
												 [fArray getVal:i :2],
												 12);
				}
			}
			
			
			//NSLog(@"Button = (%d,%d,%d,%d)", x1, y1, x2, y2);
			
			//[ButtonArr[i] setBackgroundImage:buttonImage[i] forState:UIControlStateNormal];
			//[ButtonArr[i] setBackgroundImage:buttonImage[i] forState:UIControlStateHighlighted];
			//[self.view addSubview:ButtonArr[i]];
			
		} //end for
	}
}

-(void) pressSub:(id)sender{
	if (numIcons >=3)
	{
		numIcons-=1;
		NSLog(@"%d",numIcons);
		[fArray setButtonNumber: numIcons];
		int x1, x2, y1, y2,label_y;
		float z;
		for (int i=0; i<=15; i++) 
		{
			x1 = [fArray getVal:i :0];
			y1 = [fArray getVal:i :1];
			x2 = [fArray getVal:i :2];
			y2 = [fArray getVal:i :3];
			
			ButtonArr[i].frame = CGRectMake(x1, y1, x2, y2);
			
			{
				if ( numIcons<=8 )
				{ z = 30; }
				if ( numIcons>=9 && numIcons<=12)
				{ z = 20; }
				else if ( numIcons>=13 )
				{ z = 12; }
				
			}
			
			
			LabelArr[i].font = [UIFont fontWithName:@"Helvetica" size: z];
			
			label_y = [fArray getVal:i :1]+[fArray getVal:i :3];
			
			{
				if ( numIcons<=8 )
				{ LabelArr[i].frame = CGRectMake([fArray getVal:i :0],
												 label_y,
												 [fArray getVal:i :2],
												 30); 
				}
				if ( numIcons>=9 && numIcons<=12)
				{ LabelArr[i].frame = CGRectMake([fArray getVal:i :0],
												 label_y,
												 [fArray getVal:i :2],
												 20);
				}
				else if ( numIcons>=13 )
				{ LabelArr[i].frame = CGRectMake([fArray getVal:i :0],
												 label_y,
												 [fArray getVal:i :2],
												 12);
				}
			}
			
			
			//NSLog(@"Button = (%d,%d,%d,%d)", x1, y1, x2, y2);
			
			//[ButtonArr[i] setBackgroundImage:buttonImage[i] forState:UIControlStateNormal];
			//[ButtonArr[i] setBackgroundImage:buttonImage[i] forState:UIControlStateHighlighted];
			//[self.view addSubview:ButtonArr[i]];
			
		} //end for
	}
}

//The importImage method is called when the Import Image button is pressed on the Create Activity Page
-(IBAction)importImage:(id)sender{
	//First we set up an Image Picker Controller
	UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
	
	//Setting the image pickers delegate to 'self' alerts the Create Activity page control of any functionality
	// that the image picker controller implements.  In our application, it is useful for us to know when the user
	// has selected an image from the image library.  The UIImagePickerController will alert its delegate (or this file)
	// when a user has selected an image.  This is the method following this method (imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info)
	imagePicker.delegate = self;
	
	if(self.popover ==nil)// If statement prevents multiple instances of the popover being called by checking if it already exists
	{
		//Next set up the popover controller and tell it which view will be the popped over.  In this case, we will be 
		// displaying the UIImagePicker
		self.popover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
		
		//Again, set the popovers delegate to self for the same reason as with the image picker
		[popover setDelegate:self];
	}
	
	//Finally display the image picker and manage the memory to prevent leaks
	[popover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
	[imagePicker release];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	/*
	 This method is called by the UIImagePickerController Delegate once the user has 'picked' an image from the
	 iPad's photo library.  In this method, we wil save the image to the temp folder within the applications
	 document directory.  Then we will call the getFileName() method to present an alert view to the user which will
	 accept a text input for the desired file name.
	 */
	
	// Access the uncropped image from info dictionary
	UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
	
	// Create paths to output images
	NSString *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"tmp/Test.jpg"];
	
	NSLog(@"Path Value is %@",jpgPath);
	[UIImageJPEGRepresentation(image, 1.0) writeToFile:jpgPath atomically:YES];
	
	//Do NOT release picker -- it will cause the app to crash due to over releasing
	//[picker release];
	
	[self getFileName];
}

-(void)getFileName{
	/*
	 This method is called once the user selects an image from the UIImagePickerController.  It will display an alert
	 view and allow us to accept input from the user.  Once the alert view has been displayed, the user will enter in
	 text for the file name they would like to use.  Then when they push either the 'submit' or 'cancel' button, we 
	 will check the input to make sure it is valid and that no current images are being overwritten.
	 */
	
	NSLog(@"getFileName()");
	
	
	selectAlert = 1;
	//Allocate the alertView and initialize it's buttons
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Enter Information" message:@""
												   delegate:self cancelButtonTitle:@"Cancel"  otherButtonTitles:@"Submit", nil];
	//Add a text field to the alertView to accept input from the user
	alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField * alertTextField = [alert textFieldAtIndex:0];
        alertTextField.keyboardType = UIKeyboardTypeNumberPad;
        alertTextField.placeholder = @"Enter file name";
//        [alert show];
//        [alert release];
    //:@"" label:@"Enter Filename";
	
	//The following 4 lines of code simply display our text field in a unique way as defined by us
	//textfieldName = [alert textFieldAtIndex:0];
	textfieldName.keyboardType = UIKeyboardTypeAlphabet;
	textfieldName.keyboardAppearance = UIKeyboardAppearanceAlert;
	textfieldName.autocorrectionType = UITextAutocorrectionTypeNo;
	
	//Add the text field to the alert view
	[alert addSubview:textfieldName];
	
	//Display the alertView
	[alert show];
	
	[alert release];
	
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
	/*
	 This method is called by the alertView delegate.  The code within this method is executed right before
	 the alert view goes away.  We will perform the file name checking within this method to make sure the
	 user has entered a valid filename.  If the user has not entered a valid file name, then we will alert
	 them and prompt them to re-enter a valid file name.
	 */
	
	
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	/*
	 This method is called by the alertView delegate.  The code within this method is executed when the alert
	 view goes away.  Within this method, we will accept the input from the user and save the image with the 
	 file name which has been defined by the user.  This method also checks which button has been pressed by
	 the user and performs an action which suits which button is pressed.
	 */
    if (buttonIndex == 1 && selectAlert == 1) {
		
		NSFileManager *fileMgr = [NSFileManager defaultManager];
		NSError *error;
        NSLog(@"alertView Dismiss - text = %@", textfieldName.text);
		NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
		
		NSString *jpgPath = [NSString stringWithFormat:@"%@/images/%@.jpg", documentsDirectory,textfieldName.text];
		
		
		if([textfieldName.text length] == 0)
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR!" message:@"Please Enter Name!"
														   delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[alert show];
			[alert release];
			NSLog(@"blarg");
			return;
		}
		else if([fileMgr fileExistsAtPath:jpgPath])
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR!" message:@"File already exists!"
														   delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[alert show];
			[alert release];
			NSLog(@"Error file already exists");
			return;
		}
		
		
		NSString *jpgPathOld = [NSHomeDirectory() stringByAppendingPathComponent:@"tmp/Test.jpg"];
		
		UIImage* img = [UIImage imageWithContentsOfFile:(NSString *)jpgPathOld];
		NSLog(@"Path Value is %@",jpgPath);
		
		[UIImageJPEGRepresentation(img, 1.0) writeToFile:jpgPath atomically:YES];
		
		NSLog(@"Written file");
		// Write out the contents of home directory to console
		NSLog(@"Documents directory: %@", [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error]);
		
    }
	else if(buttonIndex == 1 && selectAlert == 0)
	{
		NSLog(@"Create Activity -- Activity Name Submit");
		if (textfieldName.text.length == 0)
		{
			NSLog(@"Activity Sheet name is blank");
			
			selectAlert = 0;
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Enter Information" message:@""
														   delegate:self cancelButtonTitle:@"Cancel"  otherButtonTitles:@"Submit", nil];
			
			alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField * alertTextField = [alert textFieldAtIndex:0];
        alertTextField.keyboardType = UIKeyboardTypeNumberPad;
        alertTextField.placeholder = @"Enter file name";
//        [alert show];
//        [alert release];
            //:@"" label:@"Enter Filename";
			
			// Username
			textfieldName = [alert textFieldAtIndex:0];
			textfieldName.keyboardType = UIKeyboardTypeAlphabet;
			textfieldName.keyboardAppearance = UIKeyboardAppearanceAlert;
			textfieldName.autocorrectionType = UITextAutocorrectionTypeNo;
			
			[alert show];
			//[textfieldName release];
			[alert release];
			
		}
		else
		{
			//[editsheet release];
			editsheet = [textfieldName.text mutableCopy];
			NSLog(@"filename: %@",editsheet);
		}
	}
	else if(buttonIndex	== 0 && selectAlert == 0)
	{
		NSLog(@"Create Activity -- Activity Name Cancelled");
		[[self navigationController] setNavigationBarHidden:NO animated:NO]; 
		[self.navigationController popViewControllerAnimated:YES];
	}
	else if(buttonIndex == 1 && selectAlert == 2)
	{
		NSLog(@"Save Button -- Yes");
		[self saveSheet];
	}
	else if (buttonIndex == 1 && selectAlert == 3)
	{
		LabelArr[tempID].text = [textfieldName.text mutableCopy];
		//[text[tempID] release];
		text[tempID] = [textfieldName.text mutableCopy];
		lineID[tempID][1] = 1;
		
	}
	//else {
	//	NSLog(@"Test Button 2");
	//	editsheet = @"Default";
	//}
	
}
- (IBAction)chooseEdit:(id)sender{
	IPAACAppDelegate *appDelegate = 
	[[UIApplication sharedApplication] delegate];
	CGSize size1;
	size1.width=310;
	size1.height=100;
	appDelegate.viewController.currentButton = (UIButton *)sender;
	tempID = (int)appDelegate.viewController.currentButton.tag;
	
	UIViewController *choices = [[UIViewController alloc] init];
	//-----Images Button----
	UIButton *imagesButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
	imagesButton.frame = CGRectMake(0,0,100,100);
	[imagesButton setTitle:@"Images" forState:UIControlStateNormal];
	
	[imagesButton addTarget:self action:@selector(btnShowImages:) forControlEvents:UIControlEventTouchUpInside];
	
	[choices.view addSubview:imagesButton];
	//-----End Images Button----
	//-----Audio Button----
	UIButton *audioButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
	audioButton.frame = CGRectMake(105,0,100,100);
	[audioButton setTitle:@"Audio" forState:UIControlStateNormal];
	
	[audioButton addTarget:self action:@selector(btnShowAudio:) forControlEvents:UIControlEventTouchUpInside];
	
	[choices.view addSubview:audioButton];
	//-----End Audio Button----
	//-----Text Button----
	UIButton *textButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
	textButton.frame = CGRectMake(210,0,100,100);
	[textButton setTitle:@"Text" forState:UIControlStateNormal];
	
	[textButton addTarget:self action:@selector(btnChangeText:) forControlEvents:UIControlEventTouchUpInside];
	
	[choices.view addSubview:textButton];	
	//-----End Text Button----
	//-----Insert Additional choice buttons below----
	
	
	
	//-----Insert Additional choice buttons above---
	UIPopoverController *blarg = [[UIPopoverController alloc] initWithContentViewController:choices];
	[blarg setDelegate:self];
	[blarg setPopoverContentSize:size1 animated:NO];
	[choices release];
	appDelegate.viewController.editSelect = blarg;
	[blarg release];
	
	[appDelegate.viewController.editSelect 
	 presentPopoverFromRect:appDelegate.viewController.currentButton.frame inView:self.view
	 permittedArrowDirections:UIPopoverArrowDirectionAny 
	 animated:YES]; 
	
}
//----End code for interediate popover
//----Code For Popovers----

- (IBAction)btnShowAudio:(id)sender{ //Makes two views popup for single button. 
	IPAACAppDelegate *appDelegate = 
	[[UIApplication sharedApplication] delegate];
	CGSize size2;
	size2.width=320;
	size2.height=484;
	//appDelegate.viewController.currentButton = (UIButton *)sender;
	tempID = (int)appDelegate.viewController.currentButton.tag;
	NSLog(@"currentButton tag (ROUND1): %d",tempID);
	
	
	AudioViewController *sounds = 
	[[AudioViewController alloc] 
	 initWithNibName:@"AudioViewController" 
	 bundle:nil];	
	[sounds init:0];
	
	sounds.modalInPopover = NO; // This is the property that makes the popover behave modally		
	UIPopoverController *audioList = [[UIPopoverController alloc] initWithContentViewController:sounds];		
	[audioList setDelegate:self];
	[audioList setPopoverContentSize:size2 animated:NO];
	[sounds release];	   
	appDelegate.viewController.audioController = audioList;
	[audioList release];
	
	
	//Properties of the popover views. Order matters as it acts like a stack. i.e. since the image controller was setup last, it will be the first displayed.
	
	[appDelegate.viewController.audioController 
	 presentPopoverFromRect:appDelegate.viewController.currentButton.frame inView:self.view
	 permittedArrowDirections:UIPopoverArrowDirectionAny 
	 animated:YES]; 
	
}
- (IBAction)btnShowImages:(id)sender{ //Makes two views popup for single button. 
	IPAACAppDelegate *appDelegate = 
	[[UIApplication sharedApplication] delegate];
	CGSize size2;
	size2.width=320;
	size2.height=484;
	
	//tempID = appDelegate.viewController.currentButton.tag;
	NSLog(@"currentButton tag (ROUND1): %d",tempID);
	
	//Setup the image and audio popover views
	ImageViewController *images = 
	[[ImageViewController alloc] 
	 initWithNibName:@"ImageViewController" 
	 bundle:nil]; 
	NSLog(@"Made Image Table view");
	[images init:0];
		NSLog(@"init test");
	
	images.modalInPopover = NO; // This is the property that makes the popover behave modally  
	UIPopoverController *imageList = [[UIPopoverController alloc] initWithContentViewController:images];		
	[imageList setDelegate:self];
	[imageList setPopoverContentSize:size2 animated:NO];
	[images release];		
	appDelegate.viewController.imageController = imageList;	
	[imageList release];
	
	//Properties of the popover views. Order matters as it acts like a stack. i.e. since the image controller was setup last, it will be the first displayed.
	
	[appDelegate.viewController.imageController 
	 presentPopoverFromRect:appDelegate.viewController.currentButton.frame inView:self.view
	 permittedArrowDirections:UIPopoverArrowDirectionAny 
	 animated:YES];	
 	
	
}

- (IBAction)btnChangeText:(id)sender{
	//text alertview
	selectAlert = 3;
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Enter Text" message:@""
												   delegate:self cancelButtonTitle:@"Cancel"  otherButtonTitles:@"Submit", nil];
	
	alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField * alertTextField = [alert textFieldAtIndex:0];
        alertTextField.keyboardType = UIKeyboardTypeNumberPad;
        alertTextField.placeholder = @"Enter text";
//        [alert show];
//        [alert release];
    //:@"" label:@"Text";
	
	// Username
	textfieldName = [alert textFieldAtIndex:0];
	textfieldName.keyboardType = UIKeyboardTypeAlphabet;
	textfieldName.keyboardAppearance = UIKeyboardAppearanceAlert;
	textfieldName.autocorrectionType = UITextAutocorrectionTypeNo;
	
	[alert show];
	//[textfieldName release];
	[alert release];
}

/*
//----Code For Popovers----

- (IBAction)btnShowImages:(id)sender{ //Makes two views popup for single button. 
	IPAACAppDelegate *appDelegate = 
	[[UIApplication sharedApplication] delegate];
	
	appDelegate.viewController.currentButton = (UIButton *)sender;
	tempID = appDelegate.viewController.currentButton.tag;
	NSLog(@"currentButton tag (ROUND1): %d",tempID);
	
	//Setup the image and audio popover views
	ImageViewController *images = 
	[[ImageViewController alloc] 
	 initWithNibName:@"ImageViewController" 
	 bundle:nil]; 
	NSLog(@"Made Image Table view");
	images.modalInPopover = YES; // This is the property that makes the popover behave modally  
	UIPopoverController *imageList = [[UIPopoverController alloc] initWithContentViewController:images];		
	[imageList setDelegate:self];
	[images release];		
	appDelegate.viewController.imageController = imageList;	
	[imageList release];
	
	
	AudioViewController *sounds = 
	[[AudioViewController alloc] 
	 initWithNibName:@"AudioViewController" 
	 bundle:nil];		
	
	sounds.modalInPopover = YES; // This is the property that makes the popover behave modally		
	UIPopoverController *audioList = [[UIPopoverController alloc] initWithContentViewController:sounds];		
	[audioList setDelegate:self];
	
	[sounds release];	   
	appDelegate.viewController.audioController = audioList;
	[audioList release];
	
	
	//Properties of the popover views. Order matters as it acts like a stack. i.e. since the image controller was setup last, it will be the first displayed.
	
	[appDelegate.viewController.audioController 
	 presentPopoverFromRect:appDelegate.viewController.currentButton.frame inView:self.view
	 permittedArrowDirections:UIPopoverArrowDirectionAny 
	 animated:YES]; 
	
	[appDelegate.viewController.imageController 
	 presentPopoverFromRect:appDelegate.viewController.currentButton.frame inView:self.view
	 permittedArrowDirections:UIPopoverArrowDirectionAny 
	 animated:YES];	
 	
	//---------modify layer not finalized error fixed by commenting currentButton release--------
	//NSLog(@"%@",[NSString stringWithFormat:@"%@",detailImage]);
	
	
	//text alertview
	selectAlert = 3;
	UIAlertView *labelAlert = [[UIAlertView alloc] initWithTitle:@"Please Enter Text" message:@""
												   delegate:self cancelButtonTitle:@"Cancel"  otherButtonTitles:@"Submit", nil];
	
	[labelAlert alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField * alertTextField = [alert textFieldAtIndex:0];
        alertTextField.keyboardType = UIKeyboardTypeNumberPad;
        alertTextField.placeholder = @"Enter your name";
        [alert show];
        [alert release];:@"" label:@"Text"];
	
	// Username
	textfieldName = [labelAlert textFieldAtIndex:0];
	textfieldName.keyboardType = UIKeyboardTypeAlphabet;
	textfieldName.keyboardAppearance = UIKeyboardAppearanceAlert;
	textfieldName.autocorrectionType = UITextAutocorrectionTypeNo;
	
	[labelAlert show];
	//[textfieldName release];
	[labelAlert release];
	

}*/

- (void)setDetailImage:(id)newDetailImage{
	
    //if (detailImage != newDetailImage) {
	[detailImage release];		
	detailImage = [newDetailImage retain];
	
	IPAACAppDelegate *appDelegate = 
	[[UIApplication sharedApplication] delegate];
	
	tempID = (int)appDelegate.viewController.currentButton.tag;
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	
	NSString *imageName = [NSString stringWithFormat:@"%@",[newDetailImage description]];//Creates name of reference
	NSLog(@"Image name:%@",imageName);
	//imName[tempID] = imageName;
	[imName[tempID] release];
	imName[tempID] = [imageName mutableCopy];
	//imName[tempID] = [[NSString alloc] initWithString:(NSString *)imageName];
	
	NSLog(@"newDetailImage:%@",[NSString stringWithFormat:@"%@",[detailImage description]]);
	
	NSString *tempImagePath = [NSString stringWithFormat:@"%@/images/%@", documentsDir,imageName];
	NSLog(@"Image path:%@",tempImagePath);
	
	
	UIImage *tempImage = [UIImage imageWithContentsOfFile:tempImagePath];
	
	//---updates the clicked icon---
	[ButtonArr[tempID] setBackgroundImage:tempImage forState:UIControlStateNormal];
	[ButtonArr[tempID] setBackgroundImage:tempImage forState:UIControlStateHighlighted];
	[ButtonArr[tempID] setBackgroundImage:tempImage forState:UIControlStateReserved];
	[ButtonArr[tempID] setBackgroundImage:tempImage forState:UIControlStateDisabled];
	lineID[tempID][1] = 1;
	
	NSLog(@"Button Sender ID: %d",tempID); // creates temporary button based on lacthed in ID from earlier
	
	if (imageController != nil) {
        [imageController dismissPopoverAnimated:YES];
		NSLog(@"Image Controller Dismissed");
    }	
	
	
}
- (void)setDetailAudio:(id)newDetailAudio {
	
	//   if (detailAudio != newDetailAudio) {
	[detailAudio release];
	detailAudio = [newDetailAudio retain];
	
	//---update the view---
	NSLog(@"%@",[NSString stringWithFormat:@"Audio file: %@",[detailAudio description]]);
	//
	
	IPAACAppDelegate *appDelegate = 
	[[UIApplication sharedApplication] delegate];
	tempID = (int)appDelegate.viewController.currentButton.tag;
	
	NSString *tempStr = [detailAudio description];
	NSArray *temp = [tempStr componentsSeparatedByString:@"."];
	NSLog(@"button %d:%@",tempID,[temp objectAtIndex:0]);
	NSLog(@"button %d:%@",tempID,[temp objectAtIndex:1]);
	[auName[tempID] release];
	[auExt[tempID] release];
	auName[tempID]=[[temp objectAtIndex:0] mutableCopy];
	auExt[tempID]=[[temp objectAtIndex:1] mutableCopy];
	lineID[tempID][1]=1;
		
	//auName[tempID]=[[detailAudio description] mutableCopy];
	//
	//audioSelected.text = [NSString stringWithFormat:@"Audio file: %@",[detailAudio description]];		
	
	if (audioController != nil) {
		NSLog(@"Audio Controller Dismissed");
        [audioController dismissPopoverAnimated:YES];
    }	
	
}

//----End of Popover Code----

//Unused code which may be useful later
/*
 //Get the path to the SQL database
 NSLog(@"Testing DB");
 NSString * dbPath = [self getDBPath];
 NSLog(@"Path is %@",dbPath);
 
 //Set up the arrays which will hold the image and audio parameters
 NSString *imName[6];
 NSString *auName[6];
 NSString *auExt[6];
 
 //Create an array with the size and position of the icons
 frameArray *fArray = [frameArray new];
 
 
 for (int j = 0; j < 6; j++)
 {
 imName[j] = @"activityIcon.png"; //replace with empty image
 auName[j] = @"blank";	  //replace with empty sound
 auExt[j] = @"wav";		  //replace with empty sound extension
 }
 
 
 
 if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) 
 {
 
 //const char *sql = "select  imName,auName,auEXT from ActivitySheets where fName=\"Fruit\"";
 
 //Selected sheet to load goes here in this format
 NSString *selected_sheet = @"\"Fruit2\"";
 
 //Converts NSMutableString containing sql statement to const char for use
 NSMutableString *nssql = 
 [NSMutableString stringWithString:
 @"select imName,auName,auEXT from ActivitySheets where fName = "];
 [nssql appendString:selected_sheet];
 const char *sql = [nssql UTF8String];
 
 sqlite3_stmt *selectstmt;
 int i=0;
 if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) 
 {
 
 while(sqlite3_step(selectstmt) == SQLITE_ROW) {
 
 NSString *temp_imName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 0)];
 NSString *temp_auName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 1)];
 NSString *temp_auExt = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 2)];
 imName[i]=temp_imName;
 auName[i]=temp_auName;
 auExt[i]=temp_auExt;
 NSLog(@"%@ %@ %@",temp_imName,temp_auName,temp_auExt);
 i++;
 
 }
 NSLog(@"Count is %d",i);
 [fArray setButtonNumber: i];
 NSLog(@"(%d %d %d %d)\n",[fArray getVal: 0:0],[fArray getVal: 0:1],[fArray getVal: 0:2],[fArray getVal: 0:3]);
 }
 }
 else
 {
 sqlite3_close(database); //Even though the open call failed, close the database connection to release all the memory.
 }
 
 //Create systemSoundIDs for the audio clips used in the activity sheet.  Audio clips should be placed in the Resourced folder.
 AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] 
 pathForResource: auName[0] ofType:auExt[0]]],
 &systemSoundID);
 
 AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] 
 pathForResource: auName[1] ofType:auExt[1]]],
 &systemSoundID2);	
 
 AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] 
 pathForResource: auName[2] ofType:auExt[2]]],
 &systemSoundID3);	
 
 AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] 
 pathForResource: auName[3] ofType:auExt[3]]],
 &systemSoundID4);	
 
 AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] 
 pathForResource: auName[4] ofType:auExt[4]]],
 &systemSoundID5);	
 
 AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] 
 pathForResource: auName[5] ofType:auExt[5]]],
 &systemSoundID6);
 */
/*
 //Set button click action to play associated sound
 [ButtonArr[0] addTarget:self action:@selector(playImage1:) 
 forControlEvents:UIControlEventTouchUpInside];
 [ButtonArr[1] addTarget:self action:@selector(playImage2:) 
 forControlEvents:UIControlEventTouchUpInside];
 
 if (numIcons >= 3)
 {
 [ButtonArr[2] addTarget:self action:@selector(playImage3:) 
 forControlEvents:UIControlEventTouchUpInside];
 }
 
 if (numIcons >= 4)
 {
 [ButtonArr[3] addTarget:self action:@selector(playImage4:) 
 forControlEvents:UIControlEventTouchUpInside];
 }
 
 if (numIcons >= 5)
 {
 [ButtonArr[4] addTarget:self action:@selector(playImage5:) 
 forControlEvents:UIControlEventTouchUpInside];
 }
 
 if (numIcons == 6)
 {
 [ButtonArr[5] addTarget:self action:@selector(playImage6:) 
 forControlEvents:UIControlEventTouchUpInside];
 }
 */



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotate {
    
    UIInterfaceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    if (orientation == UIInterfaceOrientationLandscapeLeft  ||orientation ==  UIInterfaceOrientationLandscapeRight )
    {
        
        return YES;
    }
    return NO;
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewWillDisappear:(BOOL)animated
{
	[popover dismissPopoverAnimated:NO];
}

- (void)viewDidUnload {
	for(int honk =0;honk<16;honk++){
		[ButtonArr[honk] release];
		[text[honk] release];
		[imName[honk] release];
		[auName[honk] release];
		[auExt[honk] release];
	}
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[fArray release];
	[imageController release];
	[editSelect release];
	[audioController release];
	[popover release];
	[currentButton release];
	[button release];
	[fileList release];
	[textfieldName release];
    [super dealloc];
}

@end
