//
//  NewsViewConroller.m
//  Cumulus
//
//  Created by rif on 4/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NewsViewConroller.h"
#import "CumulusAppDelegate.h"
#import "DataLoader.h"

#define INTERESTING_TAG_NAMES @"text", @"created_at", nil

@implementation NewsViewConroller

//static NSString *NEWS_LOCATION = @"http://twitter.com/statuses/public_timeline.xml";
static NSString *NEWS_LOCATION = @"http://twitter.com/statuses/user_timeline/icsm2010.xml";
static NSString *NEWS_HTML = @"news.html";
static NSString *HTML_TEMPLATE = @"<html><head><link rel=\"stylesheet\" href=\"cumulodata/news.css\"/><title>Favorites</title><meta name=\"viewport\" content=\"width=device-width,initial-scale=1,user-scalable=no\"/></head><body id=\"chat\">%@</body></html>";

@synthesize tweetsView, tabButton;

-(IBAction) updateTweets {
	[tweetsData release];
	tweetsData = [[NSMutableData alloc] init];
	NSURL *url = [NSURL URLWithString: NEWS_LOCATION];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
	NSURLConnection *connection = [[NSURLConnection alloc]
								   initWithRequest:request
								   delegate:self];
	[connection release];
	[request release];
}

- (void) startParsingTweets {
	NSXMLParser *tweetParser = [[NSXMLParser alloc] initWithData:tweetsData];
	tweetParser.delegate = self;
	[tweetParser parse];
	[tweetParser release];
}

- (void)timerFireMethod:(NSTimer*)theTimer {
	NSLog(@"updaing tweets");
	[self updateTweets];
}

- (void)viewDidAppear:(BOOL)animated {
    tabButton.badgeValue = nil;
}

- (void) viewDidLoad {
	[super viewDidLoad];
	interestingTags = [[NSSet alloc] initWithObjects: INTERESTING_TAG_NAMES];
	// updating tweets every 2 minutes
	[NSTimer scheduledTimerWithTimeInterval:120 target: self selector:@selector(timerFireMethod:) userInfo: nil repeats: YES];
	NSString *htmlFile = [[CumulusAppDelegate defaultDataLoader].documentsDirectory stringByAppendingPathComponent: NEWS_HTML];
	
	//NSString *oldNews = [NSString stringWithContentsOfFile: htmlFile encoding: NSUTF8StringEncoding error:nil];
	//NSString *html = [NSString stringWithFormat:HTML_TEMPLATE, oldNews];
	//[html writeToFile:htmlFile atomically:YES encoding: NSUTF8StringEncoding error: nil];
	
	//NSString *oldNews = [NSString stringWithContentsOfFile: htmlFile encoding: NSUTF8StringEncoding error:nil];
	//NSLog(@"Loading news:\n%@", oldNews);
	NSURL *url = [NSURL fileURLWithPath:htmlFile isDirectory: NO];
	NSURLRequest *request = [NSURLRequest requestWithURL: url];
	[tweetsView loadRequest: request];
	[self updateTweets];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[tweetsData appendData: data];
}

-(void) connection:(NSURLConnection *)connection didFailWithError: (NSError *)error {
	NSLog(@"Nu prea ii conexiune la net...");
}


- (void) connectionDidFinishLoading: (NSURLConnection*) connection {
	[self startParsingTweets];
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
	[tweetsString release];
	tweetsString = [[NSMutableString alloc]
					initWithCapacity: (20 * (140 + 20)) ];
	currentElementName = nil;
	currentText = nil;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
	attributes:(NSDictionary *)attributeDict {
	if ([elementName isEqualToString:@"status"]) {
		[currentTweetDict release];
		currentTweetDict = [[NSMutableDictionary alloc]
							initWithCapacity: [interestingTags count]];
	}
	else if ([interestingTags containsObject: elementName]) {
		currentElementName = elementName;
		currentText = [[NSMutableString alloc] init];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
	if ([elementName isEqualToString:currentElementName]) {
		[currentTweetDict setValue: currentText forKey: currentElementName];
	} else if ([elementName isEqualToString:@"status"]) {
		[tweetsString appendFormat:@"<div class=\"tweet\"><p>%@</p></div>",
		 //[currentTweetDict valueForKey:@"created_at"],
		 [currentTweetDict valueForKey:@"text"]];
	}
	[currentText release];
	currentText = nil;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	[currentText appendString:string];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	NSString *htmlFile = [[CumulusAppDelegate defaultDataLoader].documentsDirectory stringByAppendingPathComponent: NEWS_HTML];
	NSString *oldNews = [NSString stringWithContentsOfFile: htmlFile encoding: NSUTF8StringEncoding error:nil];
	NSString *html = [NSString stringWithFormat:HTML_TEMPLATE, tweetsString];
	//NSLog(@"News:\n %@ \n\n=====\n\n %@", oldNews, html);
	if (![oldNews isEqualToString: html]) {
		[html writeToFile:htmlFile atomically:YES encoding: NSUTF8StringEncoding error: nil];
		
		//NSString *newsText = [NSString stringWithContentsOfFile: htmlFile encoding: NSUTF8StringEncoding error:nil];
		//NSLog(@"Updating news:\n%@", newsText);
		
		NSURL *url = [NSURL fileURLWithPath:htmlFile isDirectory: NO];
		NSURLRequest *request = [NSURLRequest requestWithURL: url];
		NSLog(@"news request: %@", request);
		[tweetsView loadRequest: request];
		
		tabButton.badgeValue = @"New!";
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[tweetsView release];
	[interestingTags release];
    [super dealloc];
}

@end
