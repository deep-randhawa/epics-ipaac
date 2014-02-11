//
//  PDFViewController.h
//  PDF
//
//  Created by Remy Panicker on 11/18/10.
//  Copyright 2010 Purdue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDFViewController : UIViewController  {
	UIWebView	*webView;
	NSURL	*pdfUrl;
}

@property (nonatomic, retain) IBOutlet UIWebView	*webView;
@property (nonatomic, retain) NSURL			*pdfUrl;

@end