//
//  HtmlViewController.m
//  Cumulus
//
//  Created by rif on 1/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SchedulerViewController.h"
#import "PaperHtmlViewController.h"
#import "CumulusAppDelegate.h"
#import "PaperDoc.h"
#import "DataLoader.h"

@implementation SchedulerViewController

@synthesize webView, schedulerDict, weekDays;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	[self.webView reload];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.weekDays = [NSArray arrayWithObjects: @"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", nil];
	NSArray *schedulerPaths = [NSArray arrayWithObjects:@"cumulodata/schedule/Sunday.html",
							   @"cumulodata/schedule/Monday.html",
							   @"cumulodata/schedule/Tuesday.html",
							   @"cumulodata/schedule/Wednesday.html",
							   @"cumulodata/schedule/Thursday.html",
							   @"cumulodata/schedule/Friday.html",
							   @"cumulodata/schedule/Saturday.html",
							   nil];
	self.schedulerDict = [NSDictionary dictionaryWithObjects:schedulerPaths forKeys:weekDays];
	NSDate *today = [NSDate date];
	NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
	NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
	[outputFormatter setLocale:usLocale];
	[outputFormatter setDateFormat:@"EEEE"];
	NSString *day = [outputFormatter stringFromDate: today];
	[outputFormatter release];

	self.title = day;
	prevDayButton = self.navigationItem.leftBarButtonItem;
	[prevDayButton retain];
	nextDayButton = self.navigationItem.rightBarButtonItem;
	[nextDayButton retain];
	[self updateButtons];
}

-(void)updateButtons {
	if ([self.weekDays indexOfObject: self.title] < [self.weekDays count] - 1){
		self.navigationItem.rightBarButtonItem.title = [self.weekDays objectAtIndex: [self.weekDays indexOfObject: self.title] + 1];
		[self.navigationItem setRightBarButtonItem: nextDayButton animated: YES];
	} else {
		[self.navigationItem setRightBarButtonItem: nil animated: YES];
	}
	if ([self.weekDays indexOfObject: self.title] > 0){
		NSLog(@"Test: %@ %@", self.weekDays, self.title);
		self.navigationItem.leftBarButtonItem.title = [self.weekDays objectAtIndex: [self.weekDays indexOfObject: self.title] - 1];
		[self.navigationItem setLeftBarButtonItem: prevDayButton animated: YES];
	} else {
		[self.navigationItem setLeftBarButtonItem: nil animated: YES];
	}
	NSString *generalScheule = [[CumulusAppDelegate defaultDataLoader].documentsDirectory stringByAppendingPathComponent: [self.schedulerDict objectForKey: self.title]];
	NSURL *url = [NSURL fileURLWithPath:generalScheule isDirectory: NO];
	NSURLRequest *request = [NSURLRequest requestWithURL: url];
	//NSLog(@"scheduler request: %@", request);
	[self.webView loadRequest: request];
}

- (void)prevDay {
	NSUInteger dayIndex = [self.weekDays indexOfObject: self.title];
	if (dayIndex > 0) {
		self.title = [self.weekDays objectAtIndex: dayIndex - 1];
	}
	[self updateButtons];
}

- (void)nextDay {
	NSUInteger dayIndex = [self.weekDays indexOfObject: self.title];
	if (dayIndex < [self.weekDays count] - 1) {
		self.title = [self.weekDays objectAtIndex: dayIndex + 1];
	}
	[self updateButtons];
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
	if (navigationType == UIWebViewNavigationTypeLinkClicked) {
		NSURL *url = request.URL;
		
		PaperHtmlViewController *phvc = [[PaperHtmlViewController alloc] initWithNibName: @"PaperHtmlViewController" bundle:nil];
		PaperDoc *paper = nil;
		for (PaperDoc *pd in [CumulusAppDelegate defaultDataLoader].papers) {
			NSString *path = url.path;
			if ([pd.path isEqualToString: path]) {
				paper = pd;
				break;
			}
		}
		if (paper != nil) {
			phvc.request = request;
			phvc.paper = paper;
			[self.navigationController pushViewController: phvc animated:YES];
		}
		[phvc release];
		
		return NO;
	}
	return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
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
	[webView dealloc];
	[schedulerDict dealloc];
	[weekDays release];
	[nextDayButton release];
	[prevDayButton release];
    [super dealloc];
}


@end
