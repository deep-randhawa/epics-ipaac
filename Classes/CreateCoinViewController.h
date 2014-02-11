//
//  CreateActivityViewController.h
//  CreateActivity
//
//  Copyright 2010 Purdue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@class frameArray;

@interface CreateCoinViewController : UIViewController <UIPopoverControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
	

	//numIcons is a user defined number of icons to place on activity sheet (1 < numIcons <= 6)
	int numIcons,numIconsOld;
	int dirty;
	int selectAlert;
	
	NSString *imName[16];
	NSString *auName[16];
	NSString *auExt[16];
	NSString *price[16];
	int	lineID[16][2];
	
	NSString *editsheet;
	
	//Initialize view with placeholder icons
	UIButton *ButtonArr[16];
	UILabel *LabelArr[16];
	UIImage *buttonImage[16];
	UIPopoverController *popover;
	
	//Initialize the variables used by the image picker
	UIButton *button;
	UITextField *textfieldName;
	
	NSArray *fileList;
	
	frameArray *fArray;
	UIPopoverController *imageController,*audioController,*editSelect;//two seperate controllers for the audio and image lists
    id detailAudio,detailImage; //added second ID for second popover
	
	UIButton *currentButton;
	
	int tempID;
	//for testing purposes only
	//IBOutlet UIImageView *iconView;
}

- (id) init: (NSString *) select: (int) clean:(NSArray *) files;


- (IBAction) recordAudio;
- (IBAction) goBack;
- (void) saveSheet;
- (void)getFileName;
- (void)setDetailAudio:(id)newDetailAudio;
- (void)setDetailImage:(id)newDetailImage;
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
- (IBAction) importImage:(id)sender;

- (void) pressAdd:(id)sender;
- (void) pressSub:(id)sender;
- (IBAction) pressSave;

//- (BOOL) textFieldShouldReturn:(UITextField *)textField;

- (NSString *) getDBPath;

- (void)getFileName;

- (IBAction) btnShowImages:(id)sender;
- (IBAction)importImage:(id)sender;
- (IBAction) btnShowAudio:(id)sender;
- (IBAction)btnChangeText:(id)sender;

@property (nonatomic, retain) UIPopoverController *imageController; 
@property (nonatomic, retain) UIPopoverController *audioController;
@property (nonatomic, retain) UIPopoverController *popover;
@property (nonatomic, retain) UIPopoverController *editSelect;
@property (nonatomic, retain) id detailAudio;
@property (nonatomic, retain) id detailImage;
@property (nonatomic, retain) UIButton *currentButton;


@end

