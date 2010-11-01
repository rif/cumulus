//
//  AuthorDoc.h
//  Cumulus
//
//  Created by rif on 4/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NSXMLParserDelegate;
@interface AuthorDoc : NSObject<NSXMLParserDelegate> {
	NSString *name;
	NSString *path;
	NSXMLParser *authorParser;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *path;

-(void)startParsingAuthor;
-(bool)isLoadingComplete;

@end
