//
//  SpeakersViewController.m
//  Cumulus
//
//  Created by rif on 1/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AuthorsViewController.h"
#import "AuthorDoc.h"
#import "DataLoader.h"
#import "AuthorHtmlViewController.h"
#import "CumulusAppDelegate.h"


@implementation AuthorsViewController

@synthesize htmlViewController, searchController;

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
	self.title = @"Authors";
	dataLoader = [CumulusAppDelegate defaultDataLoader];
	[dataLoader retain];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	 searchResults = [NSMutableArray arrayWithArray: dataLoader.authors];
	[searchResults retain];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void) searchAuthors: (NSString*) searchTerm {
	if (![searchTerm isEqualToString: @""]) {
		[searchResults removeAllObjects];
		for (AuthorDoc *ad in dataLoader.authors) {
			NSString *name = [ad.name lowercaseString];
			NSString *text = [searchTerm lowercaseString];
			if ([name rangeOfString: text].length != 0) {
				[searchResults addObject: ad];
			}
		}
		[searchController.searchResultsTableView reloadData];
	}
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[self searchAuthors: searchBar.text];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchTerm {
	[self searchAuthors: searchTerm];
}

- (void) searchBarCancelButtonClicked: (UISearchBar *) searchBar {
	[searchResults release];
	searchResults = [NSMutableArray arrayWithArray: dataLoader.authors];
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
	if (searchResults == nil) {
		searchResults = [NSMutableArray arrayWithArray: dataLoader.authors];
	}
    return [searchResults count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	AuthorDoc *author = [searchResults objectAtIndex: indexPath.row];
	cell.textLabel.text = author.name;
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
	NSLog(@"did select start");
	AuthorDoc *ad = [searchResults objectAtIndex: indexPath.row];
	NSString *viewingFile = ad.path;
	NSLog(@"viewvin file: %@", viewingFile);
	NSURL *url = [NSURL fileURLWithPath:viewingFile isDirectory: NO];
	NSURLRequest *request = [NSURLRequest requestWithURL: url];
	NSLog(@"request: %@", request);
	self.htmlViewController.title = ad.name;
	[self.htmlViewController.webView loadRequest: request];
	NSLog(@"htmlviewcontroller: %@", self.htmlViewController);
	[self.navigationController pushViewController: self.htmlViewController animated:YES];
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

/*
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchTerm {
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	[searchBar resignFirstResponder];
}*/

- (void)dealloc {
	[searchResults release];
	[dataLoader release];
    [super dealloc];
}


@end

