//
//  PaperHtmlViewController.h
//  Cumulus
//
//  Created by rif on 4/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PaperDoc;

@interface PaperHtmlViewController : UIViewController {
	UIWebView *webView;
	UIBarButtonItem *favButton;
	PaperDoc *paper;
	NSURLRequest *request;
	UIImage *favorite_img;
	UIImage *not_favorite_img;
}

@property (nonatomic, retain) NSURLRequest *request;
@property (nonatomic, retain) PaperDoc *paper;
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *favButton;

- (void) markAsFavorite;

@end
