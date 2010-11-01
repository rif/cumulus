//
//  PaperHtmlViewController.m
//  Cumulus
//
//  Created by rif on 4/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PaperHtmlViewController.h"
#import "PaperDoc.h"
#import "CumulusAppDelegate.h"
#import "DataLoader.h"

@implementation PaperHtmlViewController

@synthesize webView, favButton, request, paper;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


- (void)viewDidLoad {
    [super viewDidLoad];
	self.favButton = [[UIBarButtonItem alloc] initWithImage: not_favorite_img style: UIBarButtonItemStylePlain target: self action:@selector(markAsFavorite)]; 
	self.navigationItem.rightBarButtonItem = self.favButton;
	favorite_img = [UIImage imageNamed:@"favyes.png"];
	[favorite_img retain];
	not_favorite_img = [UIImage imageNamed:@"favnot.png"];
	[not_favorite_img retain];
}


- (void) markAsFavorite {
	if ([[CumulusAppDelegate defaultDataLoader].favorites containsObject: self.paper.pid]) {
		[[CumulusAppDelegate defaultDataLoader] removeFromFavorites: self.paper.pid];
		self.favButton.image = not_favorite_img;
	} else {
		[[CumulusAppDelegate defaultDataLoader] addToFavorites: self.paper.pid];
		self.favButton.image = favorite_img;
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.webView loadRequest: self.request];
	if ([[CumulusAppDelegate defaultDataLoader].favorites containsObject: self.paper.pid]) {
		self.favButton.image = favorite_img;
	} else {
		self.favButton.image = not_favorite_img;
	}
}
	

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
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


- (void)dealloc {
	[paper release];
	[webView release];
	[favButton release];
	[favorite_img release];
	[not_favorite_img release];
    [super dealloc];
}


@end
