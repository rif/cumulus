//
//  DataLoader.m
//  Cumulus
//
//  Created by rif on 1/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DataLoader.h"
#import "PaperDoc.h"
#import "AuthorDoc.h"
#import "TWZipArchive.h"

#define CHUNK 16384

@implementation DataLoader

static NSString *VERSION_LOCATION = @"http://loose.upt.ro/~horia/version.txt";
static NSString *CUMULODATA_LOCATION  = @"http://loose.upt.ro/~horia/cumulodata.zip";
static NSString *PAPERS_LOCATION = @"cumulodata/data/papers";
static NSString *AUTHORS_LOCATION = @"cumulodata/data/authors";
static NSString *FAVORITES_FILE = @"favorites.plist";
static NSString *FAVORITES_CSS = @"favorites.css";


@synthesize papers, authors, favorites, documentsDirectory;


- (id) init {
	[super init];
	NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    self.documentsDirectory = [docPaths objectAtIndex: 0];
	//NSLog(@"documents content: %@", [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.documentsDirectory error:nil]);
	return self;
}

- (bool) checkForNewVersion {
	NSLog(@"starting inquire for new version");
	remoteVersionSHA1 = [NSString stringWithContentsOfURL: [NSURL URLWithString:VERSION_LOCATION] encoding: NSUTF8StringEncoding error: nil];
	remoteVersionSHA1 = [remoteVersionSHA1 stringByTrimmingCharactersInSet: NSCharacterSet.whitespaceAndNewlineCharacterSet];
	versionLocation = [self.documentsDirectory stringByAppendingPathComponent:@"version.txt"];
	[remoteVersionSHA1 retain];
	[versionLocation retain];
	
	NSString *localVersionSHA1 = [NSString stringWithContentsOfFile: versionLocation encoding: NSUTF8StringEncoding error: nil];

	if ((remoteVersionSHA1 == nil) || [remoteVersionSHA1 isEqualToString: localVersionSHA1]) {
		NSLog(@"no new version found. %@ == %@", remoteVersionSHA1, localVersionSHA1);
		return NO;
	}
	NSLog(@"new version found. %@ != %@", remoteVersionSHA1, localVersionSHA1);
	return YES;
}

- (void) downloadData {
	downladedFile = [self.documentsDirectory stringByAppendingPathComponent:@"cumulodata.zip"];
	NSLog(@"saveLocation: %@", downladedFile);
	
	NSFileManager* fileManager = [NSFileManager defaultManager];
	
	if ([fileManager fileExistsAtPath:downladedFile]) {
		[fileManager removeItemAtPath:downladedFile error:nil];
	}
		NSLog(@"1");
	NSURLRequest *request = 
	[NSURLRequest requestWithURL: [NSURL URLWithString: CUMULODATA_LOCATION]
					 cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];    
	NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil]; 
	[received writeToFile:downladedFile atomically:1];
	//[request release];
	NSString *downloadedFileSHA1 = [self fileSHA1: downladedFile];
	NSLog(@"downloaded checksum:%@, remote checksum:%@.", downloadedFileSHA1, remoteVersionSHA1);
	
	if ([downloadedFileSHA1 isEqualToString: remoteVersionSHA1]) {
		[remoteVersionSHA1 writeToFile: versionLocation atomically: 1 encoding: NSUTF8StringEncoding error: nil];
		[self unzip];
	} else {
		NSLog(@"File corrupted! Abort mission.");
		[[NSFileManager defaultManager] removeItemAtPath: downladedFile error: nil];
	}
	[remoteVersionSHA1 release];
	[versionLocation release];
}

- (void) unzip {
	// delete previous data
	NSLog(@"unzipping...");
	[[NSFileManager defaultManager] removeItemAtPath:
	 [self.documentsDirectory stringByAppendingPathComponent: @"cumulodata"] error: nil];
	//NSLog(@"documents content: %@", [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.documentsDirectory error:nil]);
	[TWZipArchive unzipFileAtPath:downladedFile toDestination:documentsDirectory];
	//NSLog(@"documents content: %@", [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.documentsDirectory error:nil]);
	// delete downloaded zip file
	[[NSFileManager defaultManager] removeItemAtPath: downladedFile error: nil];
	UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle: @"Updates!"
														 message: @"New data downloaded from the internet, please restart." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show];
	[errorAlert release];
}

- (void) loadPapers {
	//NSLog(@"loading papers");
	NSString *papersDirectory = [self.documentsDirectory stringByAppendingPathComponent: PAPERS_LOCATION];
	if (![[NSFileManager defaultManager] fileExistsAtPath: papersDirectory]) {
		UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle: @"First usage!"
															 message: @"Please connect your device to the internet and wait for data to be downloaded." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[errorAlert show];
		[errorAlert release];
	}
	NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath: papersDirectory error:nil];
	self.papers = [NSMutableArray arrayWithCapacity:50];
	for (NSString *file in files) {
		if([[file pathExtension] isEqualToString: @"html"]){
			PaperDoc *pd = [[PaperDoc alloc] init];
			pd.path = [papersDirectory stringByAppendingPathComponent: file];
			[pd startParsingPaper];
			if (pd.title == nil){
		    NSLog(@"inserting %@", pd.path);
			}
			[self.papers addObject: pd];
			[pd release];
		}
	}
	
}

- (void) loadAuthors {
	//NSLog(@"loading authors");
	NSString *authorsDirectory = [self.documentsDirectory stringByAppendingPathComponent: AUTHORS_LOCATION];
	NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath: authorsDirectory error: nil];
	self.authors = [NSMutableArray arrayWithCapacity:50];
	for (NSString *file in files) {
		if([[file pathExtension] isEqualToString: @"html"]){
			AuthorDoc *ad = [[AuthorDoc alloc] init];
			ad.path = [authorsDirectory stringByAppendingPathComponent: file];
			[ad startParsingAuthor];
			//NSLog(@"Autor: %@", ad);
			[self.authors addObject: ad];
			//NSLog(@"inserted: %@", ad);
			[ad release];
			//NSLog(@"salut!");
		}
	}
	
}

-(NSArray *)getTracks{
	NSMutableArray *tracks = [NSMutableArray arrayWithCapacity: [self.papers count]];
	for(PaperDoc *paper in self.papers){
		if (![tracks containsObject: paper.track]) {
			[tracks addObject: paper.track];
		}
	}
	return tracks;
}
-(NSArray *)getPapersForTrack :(NSString*) track {
	NSMutableArray *trackPapers = [NSMutableArray arrayWithCapacity: [self.papers count]];
	for(PaperDoc *paper in self.papers){
		if ( [paper.track isEqualToString: track]) {
			[trackPapers addObject: paper];
		}
	}
	return trackPapers;
}

-(NSArray *)getPapersForAuthor :(NSString *) author {
	NSMutableArray *authorPapers = [NSMutableArray arrayWithCapacity: [self.papers count]];
	for(PaperDoc *paper in self.papers){
		if ( [paper.authors containsObject: author] || [paper.presenter isEqualToString: author]) {
			[authorPapers addObject: paper];
		}
	}
	return authorPapers;
}

-(NSArray *)getFavoritePapers {
		NSMutableArray *favoritePapers = [NSMutableArray arrayWithCapacity: [self.favorites count]];
		for(NSString *pid in self.favorites){
			[favoritePapers addObject: [self getPaperForPid: pid]];
		}
		return favoritePapers;
}

-(void)loadFavorites {
	NSString *favFile = [self.documentsDirectory stringByAppendingPathComponent: FAVORITES_FILE];
	if ([[NSFileManager defaultManager] fileExistsAtPath: favFile]) {
		self.favorites = [NSMutableArray arrayWithContentsOfFile: favFile];
	} else {
		self.favorites = [NSMutableArray arrayWithCapacity: 80];
	}
	[self updateFavoritesCss];
}

-(void)saveFavorites {
	NSString *favFile = [self.documentsDirectory stringByAppendingPathComponent: FAVORITES_FILE];
	[favorites writeToFile:favFile atomically:YES];
	//NSLog(@"saved favorites at: %@", favFile);
}

-(PaperDoc *)getPaperForPid: (NSString *) pid {
	for(PaperDoc *paper in self.papers){
		if ([paper.pid isEqualToString: pid]) {
			return paper;
		}
	}
	return nil;
}

-(void)addToFavorites: (NSString *) pid {
	[self.favorites addObject: pid];
	[self updateFavoritesCss];
}

-(void)removeFromFavorites: (NSString *) pid {
	[self.favorites removeObject: pid];
	[self updateFavoritesCss];
}

-(void) updateFavoritesCss {
	NSMutableString *fileContent = [NSMutableString stringWithCapacity: 500];
	for (NSString *pid in self.favorites) {
		if (![[self.favorites lastObject] isEqualToString: pid]) {
			[fileContent appendFormat: @"#%@, ", pid];
		} else {
			[fileContent appendFormat: @"#%@ ", pid];
		}
	}
	[fileContent appendString: @"{background:#121E55 url('cumulodata/schedule/img/star.png') no-repeat right top;}"];
	[fileContent writeToFile: [self.documentsDirectory stringByAppendingPathComponent: FAVORITES_CSS] atomically: YES encoding: NSUTF8StringEncoding error:nil];
}

- (NSString *)fileSHA1: (NSString *) path {
    
    // define path of Info.plist
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:path];
    
    CC_SHA1_CTX sha1;
    CC_SHA1_Init(&sha1);
    
    BOOL finished = NO;
    
    while (!finished) {
		NSData *fileData = [[NSData alloc] initWithData:[handle readDataOfLength:4096]];
		CC_SHA1_Update(&sha1, [fileData bytes], [fileData length]);
		
		if( [fileData length] == 0 ) {
			finished = YES;
		}
		
		[fileData release];
    }
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1_Final(digest, &sha1);
    NSString* checksum = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
						  digest[0], digest[1], 
						  digest[2], digest[3],
						  digest[4], digest[5],
						  digest[6], digest[7],
						  digest[8], digest[9],
						  digest[10], digest[11],
						  digest[12], digest[13],
						  digest[14], digest[15],
						  digest[16], digest[17],
						  digest[18], digest[19]   ];
	
    return checksum;
}

- (void)dealloc {
	[self.documentsDirectory release];
	[self.papers release];
	[self.authors release];
    [super dealloc];
}
@end
