//
//  IPAACAppDelegate.h
//  IPAAC
//
//  Copyright Purdue 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CreateWebViewController;
@class CreateCoinViewController;
@class CreateMatchViewController;
@class CreateSentenceViewController;
@class CreateActivityViewController;

@interface IPAACAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
	//The first thing we must do is create an instance of the UINavigationController.  We'll call it navController.
	//After this, we must go into the IPAACAppDelegate.m file and define what needs
	//to happen when the app is launched
	UINavigationController *navController;
	CreateWebViewController *webController;
	CreateCoinViewController *coinController;
	CreateMatchViewController *matchController;
	CreateSentenceViewController *sentenceController;
	CreateActivityViewController *viewController;
	
	int sheettype;
	
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) CreateWebViewController *webController;
@property (nonatomic, retain) CreateActivityViewController *viewController;
@property (nonatomic, retain) CreateCoinViewController *coinController;
@property (nonatomic, retain) CreateSentenceViewController *sentenceController;
@property (nonatomic, retain) CreateMatchViewController *matchController;

- (NSString *)applicationDocumentsDirectory;

@end

