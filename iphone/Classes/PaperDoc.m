//
//  PaperDoc.m
//  Cumulus
//
//  Created by rif on 3/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PaperDoc.h"


@implementation PaperDoc

@synthesize pid, track, title, presenter, authors, location, date, path;


- (void) startParsingPaper { 
	//NSLog(@"starting to parse path %@", self.path);
	paperParser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL fileURLWithPath: self.path]];
	paperParser.delegate = self;
	[paperParser parse];
	[paperParser release];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
	attributes:(NSDictionary *)attributeDict {
	if ([elementName isEqualToString:@"meta"]) {
		if (![[attributeDict allKeys] containsObject:@"presenter"]) {
			return;
		}
		self.pid = [attributeDict objectForKey: @"pid"];
		self.track = [attributeDict objectForKey: @"track"];
		self.title = [attributeDict objectForKey: @"title"];
		//NSLog(@"title: %@", self.title);
		self.presenter = [attributeDict objectForKey: @"presenter"];
		self.authors = [((NSString *)[attributeDict objectForKey: @"authors"]) componentsSeparatedByString: @","];
		self.location = [attributeDict objectForKey: @"location"];
		
		NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
		[inputFormatter setDateFormat:@"dd-MM-yyyy HH:mm"];
		self.date = [inputFormatter dateFromString: [attributeDict objectForKey: @"date"]];
		[inputFormatter release];
		
		if ([self isLoadingComplete]) {
			//NSLog(@"title: %@ presenter: %@", self.title, self.presenter);
			[paperParser abortParsing];
		}
	}
}

- (bool)isLoadingComplete {
	return self.pid !=nil && self.track != nil && self.title != nil && self.presenter != nil && 
		self.authors != nil && self.location != nil && self.date != nil;
}

- (void)dealloc {
	[pid release];
	[track release];
	[title release];
	[presenter release];
	[authors release];
	[location release];
	[date release];
	[path release];
    [super dealloc];
}

@end
