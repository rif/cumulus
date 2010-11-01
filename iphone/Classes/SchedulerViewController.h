//
//  HtmlViewController.h
//  Cumulus
//
//  Created by rif on 1/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SchedulerViewController : UIViewController <UIWebViewDelegate>{
	UIWebView *webView;
	NSDictionary *schedulerDict;
	NSArray *weekDays;
	UIBarButtonItem *prevDayButton;
	UIBarButtonItem *nextDayButton;
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) NSDictionary *schedulerDict;
@property (nonatomic, retain) NSArray *weekDays;

-(IBAction) prevDay;
-(IBAction) nextDay;
-(void) updateButtons;

@end
