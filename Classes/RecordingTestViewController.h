//
//  RecordingTestViewController.h
//  RecordingTest
//
//  Copyright 2010 Purdue. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioRecorder.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <AVFoundation/AVAudioSession.h>
#import <CoreAudio/CoreAudioTypes.h>

@interface RecordingTestViewController : UIViewController<AVAudioRecorderDelegate,AVAudioPlayerDelegate,UITextFieldDelegate> 
{
    //Flag which is set while recording
	BOOL recording;
	BOOL playing;
	
	//AVAudioPlayer *newPlayer;// = [[AVAudioPlayer alloc] initWithContentsOfURL: [NSURL fileURLWithPath:filePath] error: nil];

    //Variables used for audio recording
	AVAudioRecorder * soundRecorder;
	NSString * soundFileURL;
	
	//Text field used for filename entry and label used to display prompts/feedback
	IBOutlet UITextField *txtName;
	IBOutlet UILabel     *lblHello;
	
}

//Action which dismisses the textfield keyboard
- (IBAction)doneButtonOnKeyboardPressed: (id)sender;

@property (nonatomic, retain) AVAudioRecorder * soundRecorder;

- (IBAction) record:(id) sender;
- (IBAction) play:(id) sender;
- (IBAction) goBack;

@property(nonatomic,retain) IBOutlet UITextField *txtName;
@property(nonatomic,retain) IBOutlet UILabel     *lblHello;


@end


