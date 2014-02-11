//
//  IPAACMainViewController.h
//  IPAAC
//
//  Copyright 2010 Purdue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>


@interface IPAACMainViewController : UIViewController {

}


/*
Now that we have initialized our navController and pushed our main controller view onto the stack
 we need to tell the program how to navigate between pages.  So we make two functions, one that will
 navigate to the Play IPAAC page and one that will navigate to the IPAAC Activity Sheet Studio.
 Once the functions are initialized, we can go into our IPAACMainViewController.m file and define
 what happens for each one of these methods.
 
 */
//Initialize the function that will navigate to the Play IPAAC page
-(IBAction)goToPlayIPAAC:(id)sender;

//Initialize the function that will navigate to the Activity Sheet Studio page
-(IBAction)goToActivitySheetStudio:(id)sender;
-(IBAction)goToWebsite:(id)sender;
-(IBAction)gotoContactUs:(id)sender;

//Initialize the function which presents a popover with info about IPAAC
-(void)info;
-(void)pdf;
- (void) syncFiles;

@end
