//
//  RecordingTestViewController.m
//  RecordingTest
//
//  Copyright 2010 Purdue. All rights reserved.
//

#import "RecordingTestViewController.h"


@implementation RecordingTestViewController

@synthesize txtName,lblHello, soundRecorder;


- (void)addSaveButton{    // Method for creating button, with background image and other properties
	
    UIButton *saveButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    saveButton.frame = CGRectMake(406.0, 280.0, 212.0, 97.0);
    UIImage *buttonImageNormal = [UIImage imageNamed:@"Save.png"];
	UIImage *buttonImageNormal2 = [UIImage imageNamed:@"SaveSelected.png"];
    [saveButton setBackgroundImage:buttonImageNormal forState:UIControlStateNormal];
	[saveButton setBackgroundImage:buttonImageNormal2 forState:UIControlStateHighlighted];
    [saveButton addTarget:self action:@selector(saveToFolder:) forControlEvents:UIControlEventTouchUpInside];
	
	[self.view addSubview:saveButton];  
	
	[saveButton release];
}


- (void)removeSaveButton{    // Method for creating button, with background image and other properties
	
    UIButton *saveButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    saveButton.frame = CGRectMake(406.0, 280.0, 212.0, 97.0);
    //UIImage *buttonImageNormal = [UIImage imageNamed:@"Save.png"];
	UIImage *buttonImageNormal2 = [UIImage imageNamed:@"SaveSelected.png"];
    [saveButton setBackgroundImage:buttonImageNormal2 forState:UIControlStateNormal];
	[saveButton setBackgroundImage:buttonImageNormal2 forState:UIControlStateHighlighted];
    //[saveButton addTarget:self action:@selector(saveToFolder:) forControlEvents:UIControlEventTouchUpInside];
	
	[self.view addSubview:saveButton];  
	
	[saveButton release];
}



//Accepts user input for desired filename.  Then checks if filename exists.  If a valid filename is entered
//the recorded audio clip is saved with the filename entered by the user
- (IBAction) saveToFolder:(id) sender {
    
    NSString *printMessage;
    
    if([txtName.text length] == 0)
	{
		printMessage = @"ERROR!  Please enter a filename before trying to save.";
        lblHello.text = printMessage;
        goto emptyCheck;
	}

    
    // Get path to documents directory
    NSArray *arrayPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    // Finds the contained Documents directory specific to this app
    NSString *documentsDirectory = [arrayPaths objectAtIndex:0];  
    
    //NSString *documentsDirectory = [NSHomeDirectory()
    //							   stringByAppendingPathComponent:@"Documents"];
    
    
    
    NSError *error;
    // Create an object that we will later use to look for a file and return a boolean value on whether or not it exists
    NSFileManager *manager = [NSFileManager defaultManager];
    // File we want to move, stored in original top level directory
    
    
    //Get filename for the recording from the user
    NSString *fName;
    fName = txtName.text;
    NSLog(@"\n%@",fName);
    
    
    NSString *demoFile = [NSHomeDirectory()
                          stringByAppendingPathComponent:@"Documents/recording.aiff"];
    
    // Define where to move the temporary recording file and what to name it
    NSString *demoFileMoved = [NSString stringWithFormat:@"%@/audio/%@.aiff", documentsDirectory,fName];
    
    //Check to see if filename already exists 
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:demoFileMoved];
    NSLog(@"File exists BOOL = %i",fileExists);
    
    
    if(fileExists == 0)
    {
        NSLog(@"fileExists check false");
        // Attempt the copy
        if ([manager copyItemAtPath:demoFile toPath:demoFileMoved error:&error] != YES)
            NSLog(@"Unable to move file: %@", [error localizedDescription]);
        
        // Attempt to delete the file at filePath2
        //if ([manager removeItemAtPath:demoFile error:&error] != YES)
        //	NSLog(@"Unable to delete file: %@", [error localizedDescription]);
        
        NSString *audioDirectory;
        audioDirectory = [documentsDirectory stringByAppendingPathComponent:@"audio"];

        // Show contents of audio directory
        NSLog(@"%@: %@",audioDirectory,
              [manager contentsOfDirectoryAtPath:audioDirectory error:&error]);
        
        printMessage = @"File successfully saved!";
        lblHello.text = printMessage; 
    }
    else
    {   
        NSLog(@"fileExists check true");
        
        printMessage = @"ERROR!  Filename exists.  Please choose another filename.";        
        lblHello.text = printMessage;     
        
        NSLog(@"Documents directory: %@",
              [manager contentsOfDirectoryAtPath:documentsDirectory error:&error]);
    }
    
emptyCheck:
    NSLog(@"END saveToFolder");
    
} //end saveToFolder



- (void)addRecordButton{    // Method for creating button, with background image and other properties
	
    UIButton *recordButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    recordButton.frame = CGRectMake(283.0, 53.0, 212.0, 97.0);
    UIImage *buttonImageNormal = [UIImage imageNamed:@"Record.png"];
	UIImage *buttonImageNormal2 = [UIImage imageNamed:@"RecordSelected.png"];
    [recordButton setBackgroundImage:buttonImageNormal forState:UIControlStateNormal];
	[recordButton setBackgroundImage:buttonImageNormal2 forState:UIControlStateHighlighted];
    [recordButton addTarget:self action:@selector(record:) forControlEvents:UIControlEventTouchUpInside];
	
	[self.view addSubview:recordButton]; 
	
	[recordButton release];
}

- (void)removeRecordButton{    // Method for creating button, with background image and other properties
	
    UIButton *recordButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    recordButton.frame = CGRectMake(283.0, 53.0, 212.0, 97.0);
    //UIImage *buttonImageNormal = [UIImage imageNamed:@"Record.png"];
	UIImage *buttonImageNormal2 = [UIImage imageNamed:@"RecordSelected.png"];
    [recordButton setBackgroundImage:buttonImageNormal2 forState:UIControlStateNormal];
	[recordButton setBackgroundImage:buttonImageNormal2 forState:UIControlStateHighlighted];
    //[recordButton addTarget:self action:@selector(record:) forControlEvents:UIControlEventTouchUpInside];
	
	[self.view addSubview:recordButton]; 
	
	[recordButton release];
}


//This method toggles recording and updates the Record button's background image
- (IBAction) record:(id) sender {
	
	if (recording) 
	{
        [self.soundRecorder stop];
        recording = NO;	
		
		//Terrible way to toggle button background image
		UIButton *recordButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		recordButton.frame = CGRectMake(283.0, 53.0, 212.0, 97.0);
		UIImage *buttonImageNormal = [UIImage imageNamed:@"Record.png"];
		UIImage *buttonImageNormal2 = [UIImage imageNamed:@"RecordSelected.png"];
		[recordButton setBackgroundImage:buttonImageNormal forState:UIControlStateNormal];
		[recordButton setBackgroundImage:buttonImageNormal2 forState:UIControlStateHighlighted];
		[recordButton addTarget:self action:@selector(record:) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:recordButton]; 
		
		//Enable ability to play back most recently recorded audio clip
		[self addPlayButton];
		[self addSaveButton];
		
		[recordButton release];
		
    }
	else 
	{
		[soundRecorder record];
		recording = YES;
		
		//Terrible way to toggle button background image
		UIButton *recordButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
		recordButton.frame = CGRectMake(283.0, 53.0, 212.0, 97.0);
		UIImage *buttonImageNormal = [UIImage imageNamed:@"Stop.png"];
		UIImage *buttonImageNormal2 = [UIImage imageNamed:@"StopSelected.png"];
		[recordButton setBackgroundImage:buttonImageNormal forState:UIControlStateNormal];
		[recordButton setBackgroundImage:buttonImageNormal2 forState:UIControlStateHighlighted];
		[recordButton addTarget:self action:@selector(record:) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:recordButton]; 
		
		//Disable ability to playback audio while user is recording
		[self removePlayButton];
		[self removeSaveButton];
		
		[recordButton release];
    }
} //end record



- (void)addPlayButton{    // Method for creating button, with background image and other properties
	
    UIButton *playButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    playButton.frame = CGRectMake(529.0, 53.0, 212.0, 97.0);
    UIImage *buttonImageNormal = [UIImage imageNamed:@"Play.png"];
	UIImage *buttonImageNormal2 = [UIImage imageNamed:@"PlaySelected.png"];
    [playButton setBackgroundImage:buttonImageNormal forState:UIControlStateNormal];
	[playButton setBackgroundImage:buttonImageNormal2 forState:UIControlStateHighlighted];
    [playButton addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
	
	[self.view addSubview:playButton];  
	
	[playButton release];
}

- (void)removePlayButton{    // Method for creating button, with background image and other properties
	
    UIButton *playButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    playButton.frame = CGRectMake(529.0, 53.0, 212.0, 97.0);
    //UIImage *buttonImageNormal = [UIImage imageNamed:@"Stop.png"];
	UIImage *buttonImageNormal2 = [UIImage imageNamed:@"PlaySelected.png"];
    [playButton setBackgroundImage:buttonImageNormal2 forState:UIControlStateNormal];
	[playButton setBackgroundImage:buttonImageNormal2 forState:UIControlStateHighlighted];
    //[playButton addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
	
	[self.view addSubview:playButton];  
	
	[playButton release];
} //end removePlayButton


- (void)changePlayToStop{    // Method for creating button, with background image and other properties
	
    UIButton *playButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    playButton.frame = CGRectMake(529.0, 53.0, 212.0, 97.0);
    UIImage *buttonImageNormal = [UIImage imageNamed:@"Stop.png"];
	UIImage *buttonImageNormal2 = [UIImage imageNamed:@"StopSelected.png"];
    [playButton setBackgroundImage:buttonImageNormal forState:UIControlStateNormal];
	[playButton setBackgroundImage:buttonImageNormal2 forState:UIControlStateHighlighted];
    [playButton addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
	
	[self.view addSubview:playButton];  
	
	[playButton release];
} //end changePlayToStop


//This method plays back the most recently recorded audio clip
- (IBAction) play:(id) sender {
	
	
	if (!playing)
	{
		//Currently NOT playing back audio, so toggle flag and execute change state code
		playing = YES;
		
		//Disable ability to record or save while playing an audio clip
		//[self changePlayToStop];
		[self removePlayButton];
		[self removeRecordButton];
		[self removeSaveButton];
		
		
		NSString * filePath = [NSHomeDirectory()
							   stringByAppendingPathComponent:@"Documents/recording.aiff"];
		
		
		AVAudioPlayer *newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: [NSURL fileURLWithPath:filePath] error: nil];
		//newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: [NSURL fileURLWithPath:filePath] error: nil];

		newPlayer.delegate = self;
		//[newPlayer play];
		NSLog(@"playing file at url %@ %d",[[newPlayer url] description],[newPlayer play]);
	}
	else 
	{
		//Currently playing back audio, so toggle flag and execute change state code
		playing = NO;
		[self addPlayButton];
		[self addRecordButton];
		[self addSaveButton];
		
		//[newPlayer stop];
		//[newPlayer release];
	}

	
} //end play


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
	playing = NO;
	
	//Re-enable buttons once file has finished playing
	[self addSaveButton];
	[self addRecordButton];
	[self addPlayButton];
}


//By attaching this action to 'Did exit on' in Interface Builder, the keyboard is dismissed after the user hits 'Done'
- (IBAction)doneButtonOnKeyboardPressed: (id)sender
{}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self addRecordButton];   // Call add button methods on view load  
	[self removePlayButton];   
	[self removeSaveButton];  
	
	recording = NO;
		
    //Set path to save recorded audio from
	NSString * filePath = [NSHomeDirectory()
						   stringByAppendingPathComponent:@"Documents/recording.aiff"];

    //Assign the audio recorder's settings
	NSDictionary *recordSettings = 
	[[NSDictionary alloc] initWithObjectsAndKeys:
	 [NSNumber numberWithFloat: 44100.0],AVSampleRateKey,
	 [NSNumber numberWithInt: kAudioFormatAppleIMA4],    
	 AVFormatIDKey,
	 [NSNumber numberWithInt: 1],                         
	 AVNumberOfChannelsKey,
	 [NSNumber numberWithInt: AVAudioQualityMax],         
	 AVEncoderAudioQualityKey,nil];
	
    //Create an audio recorder
	AVAudioRecorder *newRecorder = [[AVAudioRecorder alloc] 
									initWithURL: [NSURL fileURLWithPath:filePath]
									settings: recordSettings
									error: nil];
	
	[recordSettings release];
	self.soundRecorder = newRecorder;
	[newRecorder release];
	
	//prepare to record so recording begins without delay
	[newRecorder setDelegate:self];
	[newRecorder prepareToRecord];
	newRecorder.meteringEnabled = NO;
	
	soundRecorder.delegate = self;
	 
}  //end viewDidLoad


//Button which pops the current view off the navigation controller stack in order to go back to the previous view
- (IBAction) goBack{
	
	[self goBackAlert];
	
	if (recording == YES)
	{
		NSLog(@"Still recording");
	}
	else if (playing == YES)
	{
		NSLog(@"Still playing audio");
	}
	else 
	{
		//Audio is not being recorded or played back so it is safe to proceed
		//Hide the nav bar so that the toolbar created in the nib is used
		[[self navigationController] setNavigationBarHidden:YES animated:YES]; 
		[self.navigationController popViewControllerAnimated:YES];
		
		// Create an object that we will later use to look for a file and return a boolean value on whether or not it exists
		NSFileManager *manager = [NSFileManager defaultManager];
		
		NSString *demoFile = [NSHomeDirectory()
							  stringByAppendingPathComponent:@"Documents/recording.aiff"];
		
		// Delete demoFile
		[manager removeItemAtPath:demoFile error:NULL];		
		NSLog(@"Removing recording.aiff whether it exists or not");
	}
	
 }
 


- (void) goBackAlert
{
	if (playing)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!\n" message:@"Currently playing back audio!"
												   delegate:self cancelButtonTitle:nil  otherButtonTitles:@"Wait until playback ends", nil];
		
		//Display the alertView
		[alert show];
		//Release from memory
		[alert release];
	}
	else if (recording)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!\n" message:@"Currently recording audio!"
													   delegate:self cancelButtonTitle:nil  otherButtonTitles:@"OK", nil];
		
		//Display the alertView
		[alert show];
		//Release from memory
		[alert release];
	}
		
} //end goBackAlert



- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
	NSLog(@"finished recording to %@",[[recorder url] description]);
}  //end 



- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
	NSLog(@"Error %@",[error description]);
}


// Override to allow orientations other than the default portrait orientation.
//This has been modified so that the app runs ONLY in Landscape Left.  Refer to LandscapeMode.doc on the SPS for full details
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


- (void)dealloc
{
	[soundRecorder release];
	[soundFileURL release];
	[txtName release];
	[lblHello release];
	[super dealloc];
}

@end

