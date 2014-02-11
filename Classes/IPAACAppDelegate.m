//
//  IPAACAppDelegate.m
//  IPAAC
//
//  Copyright Purdue 2010. All rights reserved.
//
//  Edited to be submitted as BUYit! by Matt MacLennan
//

#import "IPAACAppDelegate.h"
#import "IPAACMainViewController.h"
#import "CreateActivityViewController.h"

@implementation IPAACAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize webController;
@synthesize coinController;
@synthesize matchController;
@synthesize sentenceController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	/*Once the navController has been defined in the IPAACAppDelegate.h file, we need to define
	what is going to happen when our app is launched.  What we need to do here is as follows:
	 1. allocate memory for our navController
	 2. Create an instance of our "IPAACMainViewController" Class and allocate memory for it.
	 3. Push the view controller onto the stack
	 4. Release the pointer to the newly created instance of IPAACMainViewController because we no longer need it.
	 5. Add the view as a subview for the navController
	 
	 We also need to make sure that the navController gets released when the application is done running.  
	 This is done at the bottom of the file in the dealloc method.
	 
	 **Note that in order to create an instance of the IPAACMainViewController, we must import the header file
	 as seen above in the import section.
	 
	 When this is complete, we need to go into our IPAACMainViewController.h file and define what will happen next
	 
	*/ 
	//Step 1
    navController = [[UINavigationController alloc] init];
	//Step 2
	IPAACMainViewController *mainViewController = [[IPAACMainViewController alloc] init];
	//Step 3
	[navController pushViewController:mainViewController animated:NO];
	//Step 4
	[mainViewController release];
	//Step 5 //fixes iOS6 rotation - EDITED BY ADITYA SHARMA on 03/26/2013.
	window.rootViewController=navController;
    [window addSubview:navController.view];
    
    [window makeKeyAndVisible];
	
	//The following line of code makes the application start up in landscape mode.
	application.statusBarOrientation = UIInterfaceOrientationLandscapeLeft;
	
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
    
}

#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {

    [viewController release];
	[webController release];
	[coinController release];
	[matchController release];
	[sentenceController release];
    [window release];
    [super dealloc];
}


@end

