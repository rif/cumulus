//
//  PapersViewController.m
//  Cumulus
//
//  Created by rif on 4/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PapersViewController.h"
#import "DataLoader.h"
#import "PaperDoc.h"
#import "PaperHtmlViewController.h"
#import "CumulusAppDelegate.h"

@implementation PapersViewController

@synthesize paperDict, nibLoadedCell;

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
	self.paperDict = [NSMutableDictionary dictionaryWithCapacity: 7];
	weekDays = [NSArray arrayWithObjects: @"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", nil];
	[weekDays retain];
	//NSLog(@"papers did load");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.tableView reloadData];
	//NSLog(@"papers did appear");
}


- (void) setupPapersForTrack: (NSString *)track {
	self.title = track;
	[self loadDictionary: [[CumulusAppDelegate defaultDataLoader] getPapersForTrack: track]];
	[self.tableView reloadData];
}

- (void) setupPapersForAuthor: (NSString *)author {
	self.title = author;
	[self loadDictionary: [[CumulusAppDelegate defaultDataLoader] getPapersForAuthor: author]];
	[self.tableView reloadData];
}

- (void) setupFavoritePapers {
	self.title = @"Favorites";
	[self loadDictionary: [[CumulusAppDelegate defaultDataLoader] getFavoritePapers]];
	[self.tableView reloadData];
}

- (void) loadDictionary: (NSArray *) currentPapers {
	[self.paperDict removeAllObjects];
	NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
	NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
	[outputFormatter setLocale:usLocale];
	[outputFormatter setDateFormat:@"EEEE"];
	for(PaperDoc* paper in currentPapers){
		NSString *wd = [outputFormatter stringFromDate: paper.date];
		NSString *dayIndex = [NSString stringWithFormat: @"%d", [weekDays indexOfObject: wd]];
		
		if ([[self.paperDict allKeys] containsObject: dayIndex]) {
			[[self.paperDict objectForKey: dayIndex] addObject: paper];
		} else {
			NSMutableArray *array = [NSMutableArray arrayWithCapacity: 20];
			[array addObject: paper];
			[self.paperDict setObject: array forKey: dayIndex];
		}

	}
	[outputFormatter release];
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
}
*/

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


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.paperDict allKeys] count];
}

int numericSorter(id string1, id string2, void *contex) {
    return [string1 compare:string2 options:NSNumericSearch];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSArray *sortedArray = [[self.paperDict allKeys] sortedArrayUsingFunction:numericSorter context:nil];
	NSString *key = [sortedArray objectAtIndex: section];
    return [[self.paperDict objectForKey: key] count];
}


// Customize the appearance of table view cells.
/*- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	PaperDoc *pd = [self.currentPapers objectAtIndex: indexPath.row];
	
	if (pd.title != nil && pd.presenter != nil) {
		cell.textLabel.text = pd.title;
		cell.detailTextLabel.text = pd.presenter;
	}
    return cell;
}*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	//sort by day of the week
	NSArray *sortedArray = [[self.paperDict allKeys] sortedArrayUsingFunction:numericSorter context:nil];
	NSString *key = [sortedArray objectAtIndex: indexPath.section];
	
	static NSString *SectionsTableIdentifier = @"SectionsTableIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: SectionsTableIdentifier];
	if (cell == nil) {
		//cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SectionsTableIdentifier] autorelease];
		[[NSBundle mainBundle] loadNibNamed:@"PaperTableCell" owner:self options:NULL];
		cell = nibLoadedCell;
	}
	//sort by hour
	NSSortDescriptor *dateAscendingDescriptor = [[[NSSortDescriptor alloc]
												  initWithKey:@"date"
												  ascending:YES
												  selector:@selector(compare:)] autorelease];
	NSArray *sortDescriptors = [NSArray arrayWithObjects: dateAscendingDescriptor, nil];
	NSArray *papers = [[self.paperDict objectForKey: key] sortedArrayUsingDescriptors: sortDescriptors];
	PaperDoc *pd = [papers objectAtIndex: indexPath.row];
	NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
	[outputFormatter setDateFormat:@"HH:mm"];

	if (pd.title != nil && pd.presenter != nil && pd.date != nil) {
		//cell.textLabel.text = pd.title;
		//cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", [outputFormatter stringFromDate: pd.date], pd.presenter];
		UILabel *titleLabel = (UILabel*) [cell viewWithTag:1];
		titleLabel.text = pd.title;
		UILabel *hourLabel = (UILabel*) [cell viewWithTag:2];
		hourLabel.text = [NSString stringWithFormat:@"%@ - %@", [outputFormatter stringFromDate: pd.date], pd.location];
		UILabel *presenterLabel = (UILabel*) [cell viewWithTag:3]; 
		presenterLabel.text = pd.presenter;
		if ([[CumulusAppDelegate defaultDataLoader].favorites containsObject: pd.pid]){
			UIImageView *favImg = (UIImageView*) [cell viewWithTag:4];
			favImg.image = [UIImage imageNamed:@"favyes.png"];
		}
	}
	[outputFormatter release];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	PaperHtmlViewController *phvc = [[PaperHtmlViewController alloc] initWithNibName: @"PaperHtmlViewController" bundle:nil];
	//sort by day of the week
	NSArray *sortedArray = [[self.paperDict allKeys] sortedArrayUsingFunction:numericSorter context:nil];
	NSString *key = [sortedArray objectAtIndex: indexPath.section];
	//sort by hour
	NSSortDescriptor *dateAscendingDescriptor = [[[NSSortDescriptor alloc]
												  initWithKey:@"date"
												  ascending:YES
												  selector:@selector(compare:)] autorelease];
	NSArray *sortDescriptors = [NSArray arrayWithObjects: dateAscendingDescriptor, nil];
	NSArray *papers = [[self.paperDict objectForKey: key] sortedArrayUsingDescriptors: sortDescriptors];
	PaperDoc *pd = [papers objectAtIndex: indexPath.row];
	NSURL *url = [NSURL fileURLWithPath:pd.path isDirectory: NO];
	NSURLRequest *request = [NSURLRequest requestWithURL: url];
	phvc.request = request;
	phvc.paper = pd;
	[self.navigationController pushViewController: phvc animated:YES];
	[phvc release];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSArray *sortedArray = [[self.paperDict allKeys] sortedArrayUsingFunction:numericSorter context:nil];
	NSString *key = [sortedArray objectAtIndex: section];
	NSString *day = [weekDays objectAtIndex: [key integerValue]];
	return day;
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
	[weekDays release];
	[paperDict release];
    [super dealloc];
}


@end

