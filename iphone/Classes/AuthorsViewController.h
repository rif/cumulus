//
//  SpeakersViewController.h
//  Cumulus
//
//  Created by rif on 1/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DataLoader;
@class AuthorHtmlViewController;

@interface AuthorsViewController : UITableViewController <UISearchBarDelegate>{
	DataLoader *dataLoader;
	AuthorHtmlViewController *htmlViewController;
	UISearchDisplayController *searchController;
	NSMutableArray *searchResults;
}

@property (nonatomic, retain) IBOutlet AuthorHtmlViewController *htmlViewController;
@property (nonatomic, retain) IBOutlet UISearchDisplayController *searchController;

@end
