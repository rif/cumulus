//
//  AuthorHtmlViewController.h
//  Cumulus
//
//  Created by rif on 4/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PapersViewController;


@interface AuthorHtmlViewController : UIViewController {
		UIWebView *webView;
		PapersViewController *papersViewController;
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet PapersViewController *papersViewController;

-(void) showPapers;

@end
