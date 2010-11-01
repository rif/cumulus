//
//  AuthorDoc.m
//  Cumulus
//
//  Created by rif on 4/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AuthorDoc.h"


@implementation AuthorDoc
@synthesize name, path;


- (void) startParsingAuthor { 
	//NSLog(@"starting to parse author at path %@", self.path);
	authorParser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL fileURLWithPath: self.path]];
	authorParser.delegate = self;
	[authorParser parse];
	[authorParser release];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
	attributes:(NSDictionary *)attributeDict {
	if ([elementName isEqualToString:@"meta"]) {
		if (![[attributeDict allKeys] containsObject:@"name"]) {
			return;
		}
		self.name = [attributeDict objectForKey: @"name"];
		if ([self isLoadingComplete]) {
			//NSLog(@"author: %@", self.name);
			[authorParser abortParsing];
		}
	}
}

- (bool)isLoadingComplete {
	return self.name != nil;
}

- (void)dealloc {
    [super dealloc];
	[name release];
	[path release];
}

@end
