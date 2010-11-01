//
//  PapersViewController.h
//  Cumulus
//
//  Created by rif on 4/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataLoader;

@interface PapersViewController : UITableViewController {
	NSArray *weekDays;
	NSMutableDictionary *paperDict;
	UITableViewCell *nibLoadedCell;
}

@property (nonatomic, retain) NSMutableDictionary *paperDict;
@property (nonatomic, retain) IBOutlet UITableViewCell *nibLoadedCell;

- (void)setupPapersForTrack: NSString;
- (void)setupPapersForAuthor: NSString;
- (void) setupFavoritePapers;
- (void) loadDictionary: NSArray;
@end
