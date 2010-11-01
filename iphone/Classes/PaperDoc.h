//
//  PaperDoc.h
//  Cumulus
//
//  Created by rif on 3/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NSXMLParserDelegate;
@interface PaperDoc : NSObject<NSXMLParserDelegate> {
	NSString *pid;
	NSString *track;
	NSString *title;
	NSString *presenter;
	NSArray *authors;
	NSString *location;
	NSDate *date;
	NSString *path;
	NSXMLParser *paperParser;
}

@property (nonatomic, retain) NSString *pid;
@property (nonatomic, retain) NSString *track;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *presenter;
@property (nonatomic, retain) NSArray *authors;
@property (nonatomic, retain) NSString *location;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSString *path;

-(void)startParsingPaper;
-(bool)isLoadingComplete;

@end
