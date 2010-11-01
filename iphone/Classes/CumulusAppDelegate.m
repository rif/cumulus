//
//  CumulusAppDelegate.m
//  Cumulus
//
//  Created by rif on 1/9/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "CumulusAppDelegate.h"
#import "DataLoader.h"


@implementation CumulusAppDelegate

static DataLoader *dataLoader = nil;

@synthesize window;
@synthesize tabBarController;
@synthesize navigationController;

+ (DataLoader *)defaultDataLoader {
    if (!dataLoader) dataLoader = [[DataLoader alloc] init];
    return dataLoader;
}


- (void)applicationDidFinishLaunching:(UIApplication *)application {
    // Add the tab bar controller's current view as a subview of the window
	[window addSubview:tabBarController.view];
	[NSThread detachNewThreadSelector:@selector(internet) toTarget:self withObject:nil];
	[[CumulusAppDelegate defaultDataLoader] loadPapers];
	[[CumulusAppDelegate defaultDataLoader] loadAuthors];
	[[CumulusAppDelegate defaultDataLoader] loadFavorites];
	
	//NSLog(@"finished launching");
}


- (void)internet {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	//NSLog(@"starting new thread...");
	if ([[CumulusAppDelegate defaultDataLoader] checkForNewVersion]){
		[[CumulusAppDelegate defaultDataLoader] downloadData];
	}
	//NSLog(@"finished checking for new version");
	[pool release];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	[[CumulusAppDelegate defaultDataLoader] saveFavorites];
}

/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}
*/

/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/


- (void)dealloc {
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end

