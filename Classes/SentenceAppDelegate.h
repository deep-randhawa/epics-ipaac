//
//  SentenceAppDelegate.h
//  Sentence
//
//  Created by epics on 2/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SentenceViewController;

@interface SentenceAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    SentenceViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet SentenceViewController *viewController;

@end

