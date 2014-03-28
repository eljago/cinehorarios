//
//  AppDelegate.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 01-04-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "AppDelegate.h"
#import "CinesVC.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "GAI.h"
#import "FileHandler.h"
#import "UIColor+CH.h"
#import "UIFont+CH.h"
//#import "RageIAPHelper.h"

#define COMPILE_GEOFARO true

/** Google Analytics configuration constants **/
static NSString *const kGaPropertyId = @"UA-41569093-1"; // Placeholder property ID.
static NSString *const kTrackingPreferenceKey = @"allowTracking";
static BOOL const kGaDryRun = NO;
static int const kGaDispatchPeriod = 30;

@implementation AppDelegate

@synthesize miGeofaro;
@synthesize miLaunchOptions,miNotificationsOptions;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    miLaunchOptions = launchOptions;

    // Initialize the RageIAPHelper singleton to register itself as the transaction observer as soon as posible.
    // This way, it will know if a transaction didn't get to finish before the app closed.
//    [RageIAPHelper sharedInstance];
    
    // Geofaro notifications
    [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeNewsstandContentAvailability)];
    
    [self setup_analytics];
    [self setup_afnetworking];
    [self setup_icloud_favorites];
    [self setup_appearances];
    
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
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dataDir = [cacheDir stringByAppendingPathComponent:@"data"];
    [FileHandler cleanDirectoryAtPath:dataDir];
    [FileHandler removeOldImages];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Notification Methods

-(void) storeDidChange:(NSNotification *)notification{
    
    NSDictionary *dict = [[NSUbiquitousKeyValueStore defaultStore] dictionaryRepresentation];
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"icloud.plist"];
    NSString *error = nil;
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:dict format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
    
    if(plistData)
    {
        [plistData writeToFile:plistPath atomically:YES];
    }
    else
    {
        NSLog(@"Error in saveData: %@", error);
    }
}

- (void)didAddNewFavorite:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSString *theaterName = [userInfo valueForKey:@"TheaterName"];
    NSUInteger theaterID = [[userInfo valueForKey:@"TheaterID"] integerValue];
    NSString *key = [NSString stringWithFormat:@"%d",theaterID];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"icloud.plist"];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    NSMutableDictionary *favorites = [NSMutableDictionary dictionaryWithDictionary:[dict objectForKey:@"Favorites"]];
    if ([favorites valueForKey:key]) {
        [favorites removeObjectForKey:key];
    }
    else{
        [favorites setValue:theaterName forKey:key];
    }
    if (!dict) {
        dict = [[NSMutableDictionary alloc] init];
    }
    [dict setValue:favorites forKey:@"Favorites"];
    
    NSString *error = nil;
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:dict format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
    
    if(plistData)
    {
        [plistData writeToFile:plistPath atomically:YES];
    }
    else
    {
        NSLog(@"Error in saveData: %@", error);
    }
    
    // Update data on the iCloud
    [[NSUbiquitousKeyValueStore defaultStore] setDictionary:favorites forKey:@"Favorites"];
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
                                             selector: @selector (storeDidChange:)
                                                 name: NSUbiquitousKeyValueStoreDidChangeExternallyNotification
                                               object: [NSUbiquitousKeyValueStore defaultStore]];
    
    // get changes that might have happened while this
    // instance of your app wasn't running
    [[NSUbiquitousKeyValueStore defaultStore] synchronize];
    
    // Observer to catch the local changes
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didAddNewFavorite:)
                                                 name:@"Toggle Favorite"
                                               object:nil];
}

- (void)setup_afnetworking
{
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:30 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
}

- (void)setup_analytics
{
    //    [[GAI sharedInstance].logger setLogLevel:kGAILogLevelVerbose];
    [GAI sharedInstance].dispatchInterval = kGaDispatchPeriod;
    [GAI sharedInstance].dryRun = kGaDryRun;
    self.tracker = [[GAI sharedInstance] trackerWithTrackingId:kGaPropertyId];
}

- (void)setup_appearances
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.window.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
    self.window.tintColor = [UIColor whiteColor];
    
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                            NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:22.0f],
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
    
    
}

#if COMPILE_GEOFARO

#pragma mark
#pragma mark GEOPUSH
#pragma mark - Application PUSH
#pragma mark - Push
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token= [[[[deviceToken description]
                        stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]]
                       stringByReplacingOccurrencesOfString:@" "
                       withString:@""]
                      stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken token %@",token);
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:token forKey:@"TOKEN"];
    
    if (token !=nil)
    {
        [self iniciarGeofaro];
    }
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"didReceiveRemoteNotification %@",userInfo);
    int numero = application.applicationIconBadgeNumber++;
    [application setApplicationIconBadgeNumber:numero];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"AppDelegate: didReceiveRemoteNotification %@ fetchCompletionHandler",userInfo);
    if(self.esiOS7) {
        NSDictionary *aps = [userInfo valueForKey:@"aps"];
        NSLog(@"AppDelegate: userInfo %@",aps);
        //NSLog(@"userInfo %i",[[aps valueForKey:@"content-available"] intValue]);
        BOOL descargar = [[aps valueForKey:@"content-available"] intValue] != 0; // myBool is NO for 0, YES for anything else
        //NSLog(@"%i",descargar);
        if (descargar) {
            NSLog(@"AppDelegate: descargar");
        }else{
            NSLog(@"AppDelegate: no descargar");
        }
        
        if ([userInfo valueForKey:@"dict"]) {
            miNotificationsOptions = [userInfo valueForKey:@"dict"];
            [miGeofaro actualizarServicios:miNotificationsOptions];
            /*
             NSLog(@"miNotificationsOptions %@",miNotificationsOptions);
             NSString *sn = [dict valueForKey:@"SN"];
             NSString *so = [dict valueForKey:@"SO"];
             NSLog(@"sn %@",sn);
             NSLog(@"so %@",so);
             */
        }
    }else{
        NSLog(@"no es iOS7");
        //iOS 6
        //NSURLConnection
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSLog(@">.<");
}

/* Sent periodically to notify the delegate of download progress. */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    
    NSLog(@"^_^");
}

/* Sent when a download has been resumed. If a download failed with an
 * error, the -userInfo dictionary of the error will contain an
 * NSURLSessionDownloadTaskResumeData key, whose value is the resume
 * data.
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    
    NSLog(@"o.0");
}
/*
 - (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
 {
 NSLog(@"performFetchWithCompletionHandler");
 }
 */
- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    /*
     NSLog(@"I'm running in the background!");
     // Execute your background request here:
     NSError *error = nil;
     NSString *string = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.brightmediums.com"] encoding:NSUTF8StringEncoding error:&error];
     NSLog(@"Error: %@, Response %@", error, string);
     //Make sure to run one of the following methods:
     completionHandler(UIBackgroundFetchResultNewData);
     */
    /*
     * Other options are:
     UIBackgroundFetchResultFailed
     UIBackgroundFetchResultNoData
     */
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError %@",error);
}

- (void)iniciarGeofaro
{
    NSLog(@"AppDelegate: iniciarGeofaro");
    miGeofaro = [Geofaro sharedGeofaro];
    [miGeofaro setDelegate:self];
    [miGeofaro setFlagNotificaciones:YES];
    [miGeofaro setFlagAlertaPower:NO];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [miGeofaro setUd:[userDefaults valueForKey:@"TOKEN"]];
    [miGeofaro setLaunchOptions:miLaunchOptions];
    [miGeofaro actualizarServicios:miNotificationsOptions];
    [miGeofaro setNotificacionBotonCancel:@"Ver"];
    [miGeofaro setFlagOcultarBarraStatus:YES];
    
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    if (height > 500) {
        [miGeofaro setErrorImage:[UIImage imageNamed:@"Default-568h"]];
    } else {
        [miGeofaro setErrorImage:[UIImage imageNamed:@"Default"]];
    }
    [miGeofaro iniciar];
}

#pragma mark - GeofaroDelegate
- (void)geofaro:(Geofaro *)geofaro faroEncontrado:(NSDictionary *)faroInfo
{
    NSLog(@"AppDelegate: faroEncontrado %@",faroInfo);
}

- (void)geofaro:(Geofaro *)geofaro faroEncontradoNuevo:(NSDictionary *)faroInfo
{
    NSLog(@"AppDelegate: faroEncontradoNuevo %@",faroInfo);
}

- (void)geofaro:(Geofaro *)geofaro faroEncontradoPromocionViewController:(UIViewController *)promocionViewController
{
    NSLog(@"AppDelegate: faroEncontradoPromocionViewController");
    UIViewController *viewController = self.window.rootViewController.presentedViewController;
    if (viewController) {
        [viewController presentViewController:promocionViewController animated:YES completion:^{
            //[[UIApplication sharedApplication] setStatusBarHidden:YES];
        }];
    }else{
        [self.window.rootViewController presentViewController:promocionViewController animated:YES completion:^{
            //[[UIApplication sharedApplication] setStatusBarHidden:YES];
        }];
    }
}


#endif


@end
