//
//  NewsViewConroller.h
//  Cumulus
//
//  Created by rif on 4/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NSXMLParserDelegate;
@interface NewsViewConroller : UIViewController<NSXMLParserDelegate> {
	UIWebView *tweetsView;
	UITabBarItem *tabButton;
	
	NSMutableData *tweetsData;
	NSMutableString *tweetsString;
	NSMutableDictionary *currentTweetDict;
	NSString *currentElementName;
	NSMutableString *currentText;
	NSSet *interestingTags;
}

@property (nonatomic, retain) IBOutlet UIWebView *tweetsView;
@property (nonatomic, retain) IBOutlet UITabBarItem *tabButton;

@end
