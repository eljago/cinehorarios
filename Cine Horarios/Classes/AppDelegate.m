//
//  AppDelegate.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 01-04-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+Geofaro.h"
#import "FileHandler.h"
#import "UIColor+CH.h"
#import "Harpy.h"
#import <Crashlytics/Crashlytics.h>
#import "NSArray+FKBMap.h"
#import "FavoritesManager.h"
#import "Constants.h"
#import "iOSHierarchyViewer.h"
#import "Appirater.h"

#include <stdio.h>
#include <dlfcn.h>
#import <mach-o/dyld.h>

NSString *const kAppID = @"469612283";
/** GOOGLE ANALYTIC CONSTANTS **/
static NSString *const kGaPropertyId = @"UA-41569093-1"; // Placeholder property ID.
static NSString *const kTrackingPreferenceKey = @"allowTracking";
static BOOL const kGaDryRun = NO;
static int const kGaDispatchPeriod = 30;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // CRASHLYTICS
    [Crashlytics startWithAPIKey:@"3a7f665fa908b2b3200d0c3d1e3faef88c20af23"];
    
    [self setup_analytics];
    [self setup_afnetworking];
    [self setup_icloud_favorites];
    [self setup_appearances];
    [self setupHarpy];
    [self setup_appirater];
    
    [self geofaroApplication:application didFinishLaunchingWithOptions:launchOptions];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[GAI sharedInstance] dispatch];
    
    [self geofaroApplicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [Appirater appEnteredForeground:YES];
    
    [self geofaroApplicationWillEnterForeground:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dataDir = [cacheDir stringByAppendingPathComponent:@"data"];
    [FileHandler cleanDirectoryAtPath:dataDir];
    [FileHandler removeOldImages];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    // Check if new app version is available
    [self checkHarpy];
    
    [iOSHierarchyViewer start];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Notification Methods

-(void) storeDidChange:(NSNotification *)notification{
    NSDictionary * userInfo = [notification userInfo];
    NSInteger reason = [[userInfo objectForKey:NSUbiquitousKeyValueStoreChangeReasonKey] integerValue];
    // 4 reasons:
    switch (reason) {
        case NSUbiquitousKeyValueStoreServerChange:
            // Updated values
            break;
        case NSUbiquitousKeyValueStoreInitialSyncChange:
            // First launch
            break;
        case NSUbiquitousKeyValueStoreQuotaViolationChange:
            // No free space
            break;
        case NSUbiquitousKeyValueStoreAccountChange:
            // iCloud accound changed
            break;
        default:
            break;
    }
    NSArray * keys = [userInfo objectForKey:NSUbiquitousKeyValueStoreChangedKeysKey];
    for (NSString * key in keys)
    {
        if ([key isEqualToString:CH_ICLOUD_NEW_FAVORITES]) {
            NSDictionary *dict = [[NSUbiquitousKeyValueStore defaultStore] dictionaryRepresentation];
            NSArray *theatersIdsICLOUD = [dict objectForKey:CH_ICLOUD_NEW_FAVORITES];
            NSArray *theatersIdsLOCAL = [[FavoritesManager sharedManager] theatersIds];
            if (![theatersIdsICLOUD isEqualToArray:theatersIdsLOCAL]) {
                [FavoritesManager prepareForDownloadBySavingToUserDefaultsFavoriteTheatersIds:theatersIdsICLOUD];
                [FavoritesManager setShouldDownloadFavorites:YES];
            }
        }
    }
}

- (void)updateFavorites:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    
    NSArray *theatersIds = [userInfo valueForKey:@"TheaterIds"];
    // Update data on the iCloud
    [[NSUbiquitousKeyValueStore defaultStore] setArray:theatersIds  forKey:CH_ICLOUD_NEW_FAVORITES];
}

#pragma mark - Setup Methods

- (void)setup_icloud_favorites
{
    //    NSURL *ubiq = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
    //    if (ubiq) {
    //        NSLog(@"iCloud access at %@", ubiq);
    //        // TODO: Load document...
    //    } else {
    //        NSLog(@"No iCloud access");
    //    }
    // register to observe notifications from the store
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(storeDidChange:)
                                                 name: NSUbiquitousKeyValueStoreDidChangeExternallyNotification
                                               object: [NSUbiquitousKeyValueStore defaultStore]];
    
    // get changes that might have happened while this
    // instance of your app wasn't running
    [[NSUbiquitousKeyValueStore defaultStore] synchronize];
    
    // Observer to catch the local changes
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateFavorites:)
                                                 name:@"Update Favorites"
                                               object:nil];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ( ![userDefaults boolForKey:CH_ICLOUD_RESETED_FAVORITES] )
    {
        [[NSUbiquitousKeyValueStore defaultStore] setDictionary:@{} forKey:CH_ICLOUD_FAVORITES];
        [[NSUbiquitousKeyValueStore defaultStore] synchronize];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPath = [paths firstObject];
        NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"icloud.plist"];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if ([fileManager fileExistsAtPath:plistPath]) {
            // SAVE TO USER DEFAULTS ARRAY OF THEATERS IDS READ FROM THE OLD FILE ICLOUD.PLIST
            NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
            NSDictionary *favorites = [dict valueForKey:CH_ICLOUD_FAVORITES];
            NSArray *keys = [favorites allKeys];
            keys = [keys fkbMap:^id(id inputItem) {
                return [NSNumber numberWithInteger:[inputItem integerValue]];
            }];
            [FavoritesManager prepareForDownloadBySavingToUserDefaultsFavoriteTheatersIds:keys];
            
            // REMOVE ICLOUD.PLIST FILE
            [fileManager removeItemAtPath:plistPath error:nil];
        }
        
        if ([[FavoritesManager getFavoriteTheatersIdsFromUserDefaults] count]) {
            // set in userdefaults that the favorite theaters should be downloaded
            [FavoritesManager setShouldDownloadFavorites:YES];
        }
        // SET IN USERDEFAULTS THAT THE FAVORITES HAVE BEEN RESETED
        [userDefaults setBool:YES forKey:CH_ICLOUD_RESETED_FAVORITES];
    }
}

- (void)setup_afnetworking
{
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:30 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
}

- (void)setup_analytics
{
    //    [[GAI sharedInstance].logger setLogLevel:kGAILogLevelVerbose];
    [GAI sharedInstance].dispatchInterval = kGaDispatchPeriod;
    [GAI sharedInstance].dryRun = kGaDryRun;
    self.tracker = [[GAI sharedInstance] trackerWithTrackingId:kGaPropertyId];
}

- (void) setup_appirater {
    [Appirater setAppId:kAppID];
    [Appirater setDaysUntilPrompt:5];
    [Appirater setUsesUntilPrompt:0];
    [Appirater setSignificantEventsUntilPrompt:-1];
    [Appirater setTimeBeforeReminding:7];
    [Appirater setDebug:NO];
    [Appirater appLaunched:YES];
}

- (void)setup_appearances
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.window.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
    self.window.tintColor = [UIColor whiteColor];
    
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                            NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:19.0f],
                                                            NSForegroundColorAttributeName: [UIColor whiteColor]
                                                            }];
    
    //    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor navColor]];
    
    [[UIToolbar appearance] setTintColor:[UIColor navColor]];
    
    [[UITabBar appearance] setBarTintColor:[UIColor blackColor]];
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setTintAdjustmentMode:UIViewTintAdjustmentModeNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{
                                                        NSForegroundColorAttributeName : [UIColor whiteColor]
                                                        }
                                             forState:UIControlStateSelected];
    
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    pageControl.backgroundColor = [UIColor whiteColor];
    
}

- (void) setupHarpy {
    // Set the App ID for your app
    [[Harpy sharedInstance] setAppID:kAppID];
    
    // Set the UIViewController that will present an instance of UIAlertController
    [[Harpy sharedInstance] setPresentingViewController:_window.rootViewController];
    
    // (Optional) Set the App Name for your app
    [[Harpy sharedInstance] setAppName:@"Cine Horarios"];
    
    /* (Optional) Set the Alert Type for your app
     By default, Harpy is configured to use HarpyAlertTypeOption */
    [[Harpy sharedInstance] setAlertType:HarpyAlertTypeOption];
    
    /* (Optional) If your application is not availabe in the U.S. App Store, you must specify the two-letter
     country code for the region in which your applicaiton is available. */
//    [[Harpy sharedInstance] setCountryCode:@"es_CL"];
    
    /* (Optional) Overides system language to predefined language.
     Please use the HarpyLanguage constants defined inHarpy.h. */
    [[Harpy sharedInstance] setForceLanguageLocalization:HarpyLanguageSpanish];
    
    [[Harpy sharedInstance] setAlertControllerTintColor:[UIColor alertViewColort]];
    
    // Perform check for new version of your app
    [[Harpy sharedInstance] checkVersion];
}

- (void) checkHarpy {
    /*
     Perform weekly check for new version of your app
     Useful if you user returns to your app from background after extended period of time
     Place in applicationDidBecomeActive:
     
     Also, performs version check on first launch.
     */
    [[Harpy sharedInstance] checkVersionWeekly];
}

@end
