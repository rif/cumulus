//
//  TraksViewController.m
//  Cumulus
//
//  Created by rif on 1/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TraksViewController.h"
#import "DataLoader.h"
#import "PapersViewController.h"
#import "SchedulerViewController.h"
#import "PaperDoc.h"
#import "CumulusAppDelegate.h"

@implementation TraksViewController
@synthesize htmlViewController, papersViewController;

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

- (void)viewDidLoad {
	[super viewDidLoad];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	self.title = @"Tracks";
	dataLoader = [CumulusAppDelegate defaultDataLoader];
	[dataLoader retain];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChange:) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
}

- (void)orientationDidChange:(NSNotification *)note { 
	UIInterfaceOrientation toInterfaceOrientation = [[UIDevice currentDevice] orientation];
	if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
		[self presentModalViewController:self.htmlViewController.navigationController animated:YES];
	}
	if (toInterfaceOrientation == UIInterfaceOrientationPortrait){
		[[self parentViewController] dismissModalViewControllerAnimated:YES];
	}
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
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


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[dataLoader getTracks] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	/*PaperDoc *pd = [dataLoader.papers objectAtIndex: indexPath.row];
	
	if (pd.title != nil && pd.presenter != nil) {
		cell.textLabel.text = pd.title;
		cell.detailTextLabel.text = pd.presenter;
	}*/
	NSString *track = [[dataLoader getTracks] objectAtIndex: indexPath.row];
	cell.textLabel.text = track;
	NSMutableString *days = [NSMutableString stringWithCapacity: 90];
	bool first = YES;
	
	NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
	NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
	[outputFormatter setLocale:usLocale];
	[outputFormatter setDateFormat:@"EEEE"];
	
	for (PaperDoc *pd in [dataLoader getPapersForTrack: track]){
		//NSLog(@"Paper: %@", pd);
		NSString *dayToBeAdded = [outputFormatter stringFromDate: pd.date];
		if ([days rangeOfString: dayToBeAdded].length == 0) {
			if (!first) {
				[days appendString: @", "];
			}
			[days appendString: dayToBeAdded];
			first = NO;
		}
	}
	cell.detailTextLabel.text = days;
	[outputFormatter release];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
	
	[self.papersViewController setupPapersForTrack: [[dataLoader getTracks] objectAtIndex: indexPath.row]];
	[self.navigationController pushViewController: self.papersViewController animated:YES];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)dealloc {
	[dataLoader release];
    [super dealloc];
}


@end

