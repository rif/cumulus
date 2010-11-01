//
//  DataLoader.h
//  Cumulus
//
//  Created by rif on 1/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <zlib.h>
#import <CommonCrypto/CommonDigest.h>
@class PaperDoc;

@interface DataLoader : NSObject {
	NSMutableArray *papers;
	NSMutableArray *authors;
	NSMutableArray *favorites;
	NSString *documentsDirectory;
	NSString *downladedFile;
	NSString *versionLocation;
	NSString *remoteVersionSHA1;
}

@property (nonatomic, retain) NSString *documentsDirectory;
@property (nonatomic, retain) NSMutableArray *papers;
@property (nonatomic, retain) NSMutableArray *authors;
@property (nonatomic, retain) NSMutableArray *favorites;

-(bool)checkForNewVersion;
-(void)downloadData;
-(void)unzip;
-(void)loadPapers;
-(void)loadAuthors;
-(void)loadFavorites;
-(void)saveFavorites;
-(void)addToFavorites: NSString;
-(void)removeFromFavorites: NSString;
-(void)updateFavoritesCss;
-(NSArray *)getTracks;
-(NSArray *)getPapersForTrack: NSString;
-(NSArray *)getPapersForAuthor: NSString;
-(NSArray *)getFavoritePapers;
-(PaperDoc *)getPaperForPid: NSString;
-(NSString *)fileSHA1: NSString; 

@end