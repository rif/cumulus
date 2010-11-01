//
//  TraksViewController.h
//  Cumulus
//
//  Created by rif on 1/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataLoader;
@class PapersViewController;
@class SchedulerViewController;

@interface TraksViewController : UITableViewController {
	DataLoader *dataLoader;
	SchedulerViewController *htmlViewController;
	PapersViewController *papersViewController;
}

@property (nonatomic, retain) IBOutlet SchedulerViewController *htmlViewController;
@property (nonatomic, retain) IBOutlet PapersViewController *papersViewController;

- (void)orientationDidChange:NSNotification;
@end
