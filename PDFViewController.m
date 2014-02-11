//
//  PDFViewController.m
//  PDF
//
//  Created by Remy Panicker on 11/18/10.
//  Copyright 2010 Purdue. All rights reserved.
//


#import "PDFViewController.h"

@implementation PDFViewController

@synthesize webView, pdfUrl;


#pragma mark -
#pragma mark UIViewController methods


// View Did Load method -- Load the PDF
- (void)viewDidLoad {
	[super viewDidLoad];
	// Tells the webView to load pdfUrl
	pdfUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"User Manual" ofType:@"pdf"]];
	[webView loadRequest:[NSURLRequest requestWithURL:pdfUrl]];
}


// Dealloc method -- webView, pdfURL
- (void)dealloc {
	[webView release];
	[pdfUrl release];
	[super dealloc];
}


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Override to allow orientations other than the default portrait orientation.
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

@end
