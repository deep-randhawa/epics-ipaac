//
//  PlayActivitySheet.h
//  Play the selected activity sheet
//
//  Copyright 2010 Purdue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@class frameArray;

@interface PlayCoinItemSelect : UIViewController 


{
	NSString *selected_sheet;
	NSString *selected_item;
	NSString *imageFile[16];
	NSString *item_price;
	NSMutableArray *price;
 
}
- (id) init:(NSString *) select;

@property(nonatomic,retain) NSMutableArray *price;

- (IBAction) itemSelect: (id) sender;

- (NSString *) getDBPath;

- (IBAction)unlockButton;


@end
