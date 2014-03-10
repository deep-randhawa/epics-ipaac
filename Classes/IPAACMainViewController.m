//
//  IPAACMainViewController.m
//  IPAAC
//
//  Copyright 2010 Purdue. All rights reserved.
//

#import "IPAACMainViewController.h"
#import "PDFViewController.h"
#import "PlayCoinTableViewController.h" //ADDED for BuyIt
#import "CoinSheetTableViewController.h" //ADDED for BuyIt

@implementation IPAACMainViewController


/*
 In the IPAACMainViewController.m file, we define what is going to happen for each of the two methods that
 we defined in the IPAACMainViewController.h file.  In order for these methods to be called, we must tell 
 Interface Builder how to call the methods. So after opening IPAACMainViewController.xib with interface builder
 we can add two RoundRec buttons to the view.  After titling them appropriately, go to the interface builder file
 and click on File's Owner.  Next click on the connections tab and draw a connection from the methods to the buttons
 that you just created.  This will tell interface builder that when the button is clicked, your app should 
 execute the appropriate method.
 */
-(IBAction)goToPlayIPAAC:(id)sender{//Send to Coin instead
	PlayCoinTableViewController *coinsViewController = [[PlayCoinTableViewController alloc] init];
	[self.navigationController pushViewController:coinsViewController animated:YES];
	//[[self navigationController] setNavigationBarHidden:YES animated:YES];
	[self.navigationController.navigationBar.topItem setTitle:@"Select Item List"];
	[coinsViewController release];
	
	
	/*
	 !!! In IPACC app, this is included. the above code is substituted in !!!
	//the first step for switching views is to initialize the next view controller to be placed on the stack
	PlayTypeViewController *playViewController = [[PlayTypeViewController alloc]  init];
    
      
   	//Next tell the navigation controller to push the view onto the stack and animate the views changing.
	[self.navigationController pushViewController:playViewController animated:YES];
	
    //Sets the title of the navigation bar at the top of the view for the top item of the navigation stack
    //This line must be placed below the 'pushViewController' command so that we are editing the title of the correct view
    [self.navigationController.navigationBar.topItem setTitle:@"Select Play Type"];

    
	//Finally release the view controller pointer because the navigation controller now knows what is on the stack.
	[playViewController release];
	*/
}

-(IBAction)goToActivitySheetStudio :(id)sender
{
	//Do the same thing for the activity sheet studio page but use a different class this time
	CoinSheetTableViewController *CoinEditor = [[CoinSheetTableViewController alloc]  init];
	[self.navigationController pushViewController :CoinEditor animated:YES];
    
    //Sets the title of the navigation bar at the top of the view for the top item of the navigation stack
    //This line must be placed below the 'pushViewController' command so that we are editing the title of the correct view
    [self.navigationController.navigationBar.topItem setTitle:@"Create New or Select Existing Item Select Sheet to Edit"];
    
	[CoinEditor release];
	
	
	/* !!!commented out for BuyIt!!!
	//Do the same thing for the activity sheet studio page but use a different class this time
	CreateTypeViewController *activitySheetEditor = [[CreateTypeViewController alloc]  init];
	[self.navigationController pushViewController:activitySheetEditor animated:YES];
    
    //Sets the title of the navigation bar at the top of the view for the top item of the navigation stack
    //This line must be placed below the 'pushViewController' command so that we are editing the title of the correct view
    [self.navigationController.navigationBar.topItem setTitle:@"Select Create Type"];
    
	[activitySheetEditor release];
	*/
}

-(IBAction)gotoWebsite :(id)sender
{
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"http://epics.ecn.purdue.edu/ipaac/"]];
}

-(IBAction)gotoContactUs :(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"About Us" message:@"If you have questions, suggestions, or would like to report an error, please contact us at epicsipaac@gmail.com or visit our website for more information.  Also check out our other applications, SPEAKall!, MAKEit!, and SPEAKone!"
												   delegate :self cancelButtonTitle :nil otherButtonTitles :@"OK",nil];
	[alert show];
	[alert release];
}
//Code which calls the PDFViewer
-(void)pdf
{
	// Create an instance of PDFViewController
	PDFViewController *controller = [[PDFViewController alloc] initWithNibName :@"PDFViewController" bundle:nil];
	[self.navigationController pushViewController:controller animated:YES];
	// Release 'controller'
	//[controller release];
}


//Code which initiates a pop up with general information about IPAAC in an alert view
-(void)info{
	//Present popover view with information about the app
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"BUYit! Information" message:@"Version 1.1.0\n\nEPICS: GLASS\nPurdue University\nCopyright 2013-2014\n\nhttp://epics.ecn.purdue.edu/glass-at/index.html"
												   delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
	[alert show];
	[alert release];
}
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	//Create info button in the navigation toolbar 
	UIButton* infoButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
	[infoButton addTarget:self action:@selector(info) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *modalButton = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
	[self.navigationItem setRightBarButtonItem:modalButton animated:YES];
	[modalButton release];
	
	
	//Create user manual button in the navigation toolbar 
	//UIButton* pdfButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	//[pdfButton addTarget:self action:@selector(pdf) forControlEvents:UIControlEventTouchUpInside];
	//UIBarButtonItem *modalButton2 = [[UIBarButtonItem alloc] initWithCustomView:pdfButton];
	UIBarButtonItem *modalButton2 = [[UIBarButtonItem alloc] initWithTitle:@"User Manual" style:UIBarButtonItemStylePlain target:self action:@selector(pdf)];
   //modalButton2.title = @"User Manual";
	[self.navigationItem setLeftBarButtonItem:modalButton2 animated:YES];
	[modalButton2 release];
    

	//Set the title of the navigation bar -- the title of the navigation bar is also used as the name for the 
	//'Back' button on connected views
	self.navigationItem.title = @"BUYit!";
	// Change navigation bar color!!! For BUYit
	[self.navigationController.navigationBar setTintColor:[UIColor colorWithHue:0.280 saturation:0.50 brightness:0.60 alpha:1]]; 
	
	
    //The following block of code checks to see if there is a subdirectory in the Documents directory for both images and audio
    //If either of the subdirectories does not exist, they will be created
    //This should only have to be done the first time the app is run after installation
	NSError *error;
    //NSString *audioDirectory;
    NSString *imagesDirectory;
	NSString *demoFile, *demoFileMoved;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //audioDirectory = [documentsDirectory stringByAppendingPathComponent:@"audio"];
    
    BOOL isFolder = YES;
    
    /*if (![fileManager fileExistsAtPath:audioDirectory isDirectory:&isFolder])
    {
		[fileManager createDirectoryAtPath:audioDirectory withIntermediateDirectories:YES attributes:nil error:&error];

        NSLog(@"Creating audio subdirectory");
		
		// Define where the original file is within the mainBundle
		demoFile = [[NSBundle mainBundle] pathForResource:@"pennydemo" ofType:@"wav"]; 
		// Define where to move the temporary file and what to name it
		demoFileMoved = [NSString stringWithFormat:@"%@/audio/pennydemo.wav", documentsDirectory];
		// Copy the original file from the mainBundle to the desired directory
		[fileManager copyItemAtPath:demoFile toPath:demoFileMoved error:&error];
		
		demoFile = [[NSBundle mainBundle] pathForResource:@"nickeldemo" ofType:@"wav"]; 
		demoFileMoved = [NSString stringWithFormat:@"%@/audio/nickeldemo.wav", documentsDirectory];
		[fileManager copyItemAtPath:demoFile toPath:demoFileMoved error:&error];
		
		demoFile = [[NSBundle mainBundle] pathForResource:@"dimedemo" ofType:@"wav"]; 
		demoFileMoved = [NSString stringWithFormat:@"%@/audio/dimedemo.wav", documentsDirectory];
		[fileManager copyItemAtPath:demoFile toPath:demoFileMoved error:&error];
		
		demoFile = [[NSBundle mainBundle] pathForResource:@"quarterdemo" ofType:@"wav"]; 
		demoFileMoved = [NSString stringWithFormat:@"%@/audio/quarterdemo.wav", documentsDirectory];
		[fileManager copyItemAtPath:demoFile toPath:demoFileMoved error:&error];
    }
    */
    imagesDirectory = [documentsDirectory stringByAppendingPathComponent:@"images"];
    
    if (![fileManager fileExistsAtPath:imagesDirectory isDirectory:&isFolder]) 
    {
        [fileManager createDirectoryAtPath:imagesDirectory withIntermediateDirectories:YES attributes:nil error:&error];
        NSLog(@"Creating images subdirectory");
		
		
		// Define where the original file is within the mainBundle
		demoFile = [[NSBundle mainBundle] pathForResource:@"pennydemo" ofType:@"png"]; 
		// Define where to move the temporary file and what to name it
		demoFileMoved = [NSString stringWithFormat:@"%@/images/pennydemo.png", documentsDirectory];
		// Copy the original file from the mainBundle to the desired directory
		[fileManager copyItemAtPath:demoFile toPath:demoFileMoved error:&error];
		
        
		demoFile = [[NSBundle mainBundle] pathForResource:@"snack" ofType:@"png"]; 
		demoFileMoved = [NSString stringWithFormat:@"%@/images/snack.png", documentsDirectory];
		[fileManager copyItemAtPath:demoFile toPath:demoFileMoved error:&error];
		

		
        demoFile = [[NSBundle mainBundle] pathForResource:@"drink" ofType:@"jpg"]; 
		demoFileMoved = [NSString stringWithFormat:@"%@/images/drink.jpg", documentsDirectory];
		[fileManager copyItemAtPath:demoFile toPath:demoFileMoved error:&error];
        
        demoFile = [[NSBundle mainBundle] pathForResource:@"car" ofType:@"png"]; 
		demoFileMoved = [NSString stringWithFormat:@"%@/images/car.png", documentsDirectory];
		[fileManager copyItemAtPath:demoFile toPath:demoFileMoved error:&error];
        
        demoFile = [[NSBundle mainBundle] pathForResource:@"shoe" ofType:@"png"]; 
		demoFileMoved = [NSString stringWithFormat:@"%@/images/shoe.png", documentsDirectory];
		[fileManager copyItemAtPath:demoFile toPath:demoFileMoved error:&error];
		
		demoFile = [[NSBundle mainBundle] pathForResource:@"tshirt" ofType:@"png"]; 
		demoFileMoved = [NSString stringWithFormat:@"%@/images/tshirt.png", documentsDirectory];
		[fileManager copyItemAtPath:demoFile toPath:demoFileMoved error:&error];
        
        demoFile = [[NSBundle mainBundle] pathForResource:@"nickeldemo" ofType:@"png"]; 
		demoFileMoved = [NSString stringWithFormat:@"%@/images/nickeldemo.png", documentsDirectory];
		[fileManager copyItemAtPath:demoFile toPath:demoFileMoved error:&error];
		
		demoFile = [[NSBundle mainBundle] pathForResource:@"dimedemo" ofType:@"png"]; 
		demoFileMoved = [NSString stringWithFormat:@"%@/images/dimedemo.png", documentsDirectory];
		[fileManager copyItemAtPath:demoFile toPath:demoFileMoved error:&error];
		
		demoFile = [[NSBundle mainBundle] pathForResource:@"quarterdemo" ofType:@"png"]; 
		demoFileMoved = [NSString stringWithFormat:@"%@/images/quarterdemo.png", documentsDirectory];
		[fileManager copyItemAtPath:demoFile toPath:demoFileMoved error:&error];
		
		// Define where the original file is within the mainBundle
		demoFile = [[NSBundle mainBundle] pathForResource:@"pennydemo" ofType:@"jpg"]; 
		// Define where to move the temporary file and what to name it
		demoFileMoved = [NSString stringWithFormat:@"%@/images/pennydemo.jpg", documentsDirectory];
		// Copy the original file from the mainBundle to the desired directory
		[fileManager copyItemAtPath:demoFile toPath:demoFileMoved error:&error];
		
		demoFile = [[NSBundle mainBundle] pathForResource:@"nickeldemo" ofType:@"jpg"]; 
		demoFileMoved = [NSString stringWithFormat:@"%@/images/nickeldemo.jpg", documentsDirectory];
		[fileManager copyItemAtPath:demoFile toPath:demoFileMoved error:&error];
		
		demoFile = [[NSBundle mainBundle] pathForResource:@"dimedemo" ofType:@"jpg"]; 
		demoFileMoved = [NSString stringWithFormat:@"%@/images/dimedemo.jpg", documentsDirectory];
		[fileManager copyItemAtPath:demoFile toPath:demoFileMoved error:&error];
		
		demoFile = [[NSBundle mainBundle] pathForResource:@"quarterdemo" ofType:@"jpg"]; 
		demoFileMoved = [NSString stringWithFormat:@"%@/images/quarterdemo.jpg", documentsDirectory];
		[fileManager copyItemAtPath:demoFile toPath:demoFileMoved error:&error];
        
        demoFile = [[NSBundle mainBundle] pathForResource:@"balloon" ofType:@"png"]; 
		demoFileMoved = [NSString stringWithFormat:@"%@/images/balloon.png", documentsDirectory];
		[fileManager copyItemAtPath:demoFile toPath:demoFileMoved error:&error];
        
        // Define where the original file is within the mainBundle
		demoFile = [[NSBundle mainBundle] pathForResource:@"crayon" ofType:@"png"]; 
		// Define where to move the temporary file and what to name it
		demoFileMoved = [NSString stringWithFormat:@"%@/images/crayon.png", documentsDirectory];
		// Copy the original file from the mainBundle to the desired directory
		[fileManager copyItemAtPath:demoFile toPath:demoFileMoved error:&error];
		
//		// Define where the original file is within the mainBundle
//		demoFile = [[NSBundle mainBundle] pathForResource:@"Iwant" ofType:@"JPG"]; 
//		// Define where to move the temporary file and what to name it
//		demoFileMoved = [NSString stringWithFormat:@"%@/images/Iwant.JPG", documentsDirectory];
//		// Copy the original file from the mainBundle to the desired directory
//		[fileManager copyItemAtPath:demoFile toPath:demoFileMoved error:&error];
//		
//		demoFile = [[NSBundle mainBundle] pathForResource:@"gummybears" ofType:@"JPG"]; 
//		demoFileMoved = [NSString stringWithFormat:@"%@/images/gummybears.JPG", documentsDirectory];
//		[fileManager copyItemAtPath:demoFile toPath:demoFileMoved error:&error];
//		
//		demoFile = [[NSBundle mainBundle] pathForResource:@"few" ofType:@"JPG"]; 
//		demoFileMoved = [NSString stringWithFormat:@"%@/images/few.JPG", documentsDirectory];
//		[fileManager copyItemAtPath:demoFile toPath:demoFileMoved error:&error];
//		
//		demoFile = [[NSBundle mainBundle] pathForResource:@"many" ofType:@"JPG"]; 
//		demoFileMoved = [NSString stringWithFormat:@"%@/images/many.JPG", documentsDirectory];
//		[fileManager copyItemAtPath:demoFile toPath:demoFileMoved error:&error];
  }
	
	[self syncFiles];
	
} //end viewDidLoad


- (void) syncFiles
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
	
	NSError *error;
	NSArray *images =
	[fileManager contentsOfDirectoryAtPath:documentsDirectory error:&error];
	
	
	int isCopy;
	for (NSString *s in images) 
	{
		NSArray *components = [s componentsSeparatedByString:@"."];
		NSInteger cnt = [components count];
		NSLog(@"%@ with count %d",components, cnt);
		//NSLog(@"%d",cnt);
		NSString *demoFile = [NSString stringWithFormat:@"%@/%@", documentsDirectory,s];
		NSString *demoFileMovedImages = [NSString stringWithFormat:@"%@/images/%@", documentsDirectory,s];
		//NSString *demoFileMovedAudio = [NSString stringWithFormat:@"%@/audio/%@", documentsDirectory,s];
		
		isCopy = 0;
		
		//cnt is the number of files in the Documents directory
		if(cnt>1)
		{
			NSString *s1 = [components objectAtIndex:(cnt-1)];
			
			
			//NSComparisonResult result;
			//result = [s1 compare:jp1];
			
			//isCopy = 1 if the file is of a supported image file
			//isCopy = 2 if the file is of a supported audio file
			
			if ([[s1 uppercaseString] isEqualToString:@"JPG"])
			{
				isCopy = 1;
			}
			else if ([[s1 uppercaseString] isEqualToString:@"JPEG"])
			{
				isCopy = 1;
			}
			else if ([[s1 uppercaseString] isEqualToString:@"PNG"])
			{
				isCopy = 1;
			}
			else if ([[s1 uppercaseString] isEqualToString:@"GIF"])
			{
				isCopy = 1;
			}
			else if ([[s1 uppercaseString] isEqualToString:@"BMP"])
			{
				isCopy = 1;
			}
			else if ([[s1 uppercaseString] isEqualToString:@"BMPF"])
			{
				isCopy = 1;
			}
			else if ([[s1 uppercaseString] isEqualToString:@"TIFF"])
			{
				isCopy = 1;
			}
			else if ([[s1 uppercaseString] isEqualToString:@"TIF"])
			{
				isCopy = 1;
			}
			else if ([[s1 uppercaseString] isEqualToString:@"ICO"])
			{
				isCopy = 1;
			}
			else if ([[s1 uppercaseString] isEqualToString:@"CUR"])
			{
				isCopy = 1;
			}
			else if ([[s1 uppercaseString] isEqualToString:@"XBM"])
			{
				isCopy = 1;
			}
			else if ([[s1 uppercaseString] isEqualToString:@"WAV"])
			{
				isCopy = 2;
			}
			else if ([[s1 uppercaseString] isEqualToString:@"CAF"])
			{
				isCopy = 2;
			}
			else if ([[s1 uppercaseString] isEqualToString:@"AIFF"])
			{
				isCopy = 2;
			}
			else if ([[s1 uppercaseString] isEqualToString:@"MP3"])
			{
				isCopy = 2;
			}
			
			
			NSLog(@"%@ with value %d",s1,isCopy);
		} //end cnt if
		
		
		if(isCopy == 1)
		{
			// Copy to images directory
			if ([fileManager copyItemAtPath:demoFile toPath:demoFileMovedImages error:&error] != YES)
				NSLog(@"Unable to move file: %@", [error localizedDescription]);
			
			NSLog(@"Copying file %@ to %@",demoFile,demoFileMovedImages);
			// Delete demoFile
			[fileManager removeItemAtPath:demoFile error:NULL];		
		}
		
		/*if(isCopy == 2)
		{
			// Copy to audio directory
			//if ([fileManager copyItemAtPath:demoFile toPath:demoFileMovedAudio error:&error] != YES)
				NSLog(@"Unable to move file: %@", [error localizedDescription]);
			
			//NSLog(@"Copying file %@ to %@",demoFile,demoFileMovedAudio);
			//delete demofile
			//[fileManager removeItemAtPath:demoFile error:NULL];
		}*/
		//NSLog(@"haha");
		//NSLog(@"%@",components);
	} //end *s for
	
	//NSLog(@"%@",images);
} //end syncFiles	



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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;

}


- (void)dealloc {
    [super dealloc];
}


@end
