//
//  AppDelegate.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 01-04-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "AppDelegate.h"
#import "FileHandler.h"
#import "UIColor+CH.h"
#import "Harpy.h"
#import <Crashlytics/Crashlytics.h>
#import "NSArray+FKBMap.h"
#import "FavoritesManager.h"
#import "Constants.h"
#import "iOSHierarchyViewer.h"

#include <stdio.h>
#include <dlfcn.h>
#import <mach-o/dyld.h>


#define COMPILE_GEOFARO false

/** GOOGLE ANALYTIC CONSTANTS **/
static NSString *const kGaPropertyId = @"UA-41569093-1"; // Placeholder property ID.
static NSString *const kTrackingPreferenceKey = @"allowTracking";
static BOOL const kGaDryRun = NO;
static int const kGaDispatchPeriod = 30;

@implementation AppDelegate


@synthesize miLaunchOptions,miNotificationsOptions;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // CRASHLYTICS
    [Crashlytics startWithAPIKey:@"3a7f665fa908b2b3200d0c3d1e3faef88c20af23"];
    

#if COMPILE_GEOFARO
    miLaunchOptions = launchOptions;
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
        [application registerForRemoteNotifications];
    }else{
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeNewsstandContentAvailability)];
#pragma GCC diagnostic pop
    }
#endif
    
    [self setup_analytics];
    [self setup_afnetworking];
    [self setup_icloud_favorites];
    [self setup_appearances];
    [self setupHarpy];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    application.applicationIconBadgeNumber = 0;
    [[GAI sharedInstance] dispatch];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    UIApplication* app = [UIApplication sharedApplication];
    
    UIBackgroundTaskIdentifier __block bgTask = [app beginBackgroundTaskWithExpirationHandler: ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [app endBackgroundTask:bgTask];
            bgTask = UIBackgroundTaskInvalid;
        });
    }];

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    application.applicationIconBadgeNumber = 0;
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
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
        
        if ([[[FavoritesManager sharedManager] theatersIds] count]) {
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
    [[Harpy sharedInstance] setAppID:@"469612283"];
    
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


#if COMPILE_GEOFARO

#pragma mark
#pragma mark GEOPUSH
#pragma mark - Application PUSH
#pragma mark - Push

char* MakeStringCopy (const char* string)
{
    if (string == NULL)
        return NULL;
    
    char* res = (char*)malloc(strlen(string) + 1);
    strcpy(res, string);
    return res;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken");
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
        
        if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")){
            NSLog(@"iOS 8");
            NSURL *frameworkURL = [[[NSBundle mainBundle] privateFrameworksURL] URLByAppendingPathComponent:@"GeoFaroKit.framework"];
            NSBundle *frameworkBundle = [NSBundle bundleWithURL:frameworkURL];
            void* gfk_handle =
            dlopen(MakeStringCopy([frameworkBundle.executableURL.path UTF8String]), RTLD_NOW);
            if (gfk_handle != NULL) {
                NSLog(@"Handler Ok");
            }else{
                NSLog(@"%s",dlerror());
            }
            NSString *pseudoToken = [NSString stringWithFormat:@"%@",[[[UIDevice currentDevice]identifierForVendor]UUIDString]];
            
            GFKManagerOptions *opciones = [NSClassFromString(@"GFKManagerOptions")nuevaConfiguracionParaAppID:@"21" conClienteId:@"Cine" appUsaToken:YES token:token appUsaRegiones:YES appName:@"appCineHorarios"];
            
            GFKManager *manager =
            [[NSClassFromString(@"GFKManager") alloc] init];
            [manager setOpciones:opciones];
            [manager setDelegate:self];
            NSLog(@"%@",manager);
            NSError *geoError;
            BOOL ok = [manager iniciarGeoFaroReporteError:&geoError];
            if (ok) {
                NSLog(@"Geofaro ha iniciado Error:%@",geoError);
            }else{
                NSLog(@"Geofaro NO ha iniciado Error:%@",geoError);
                
            }
            
            [[NSNotificationCenter defaultCenter]
             addObserver:self
             selector:@selector(reachabilityChanged:)
             name:kReachabilityChangedNotification object:nil];
            Reachability * reach = [Reachability reachabilityWithHostname:@"www.geofaro.com"];
            reach.reachableBlock = ^(Reachability *reachability){
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"Si");
                    [manager intentarConexionConEstado:YES];
                });
            };
            reach.unreachableBlock = ^(Reachability *reachability){
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"NO");
                    [manager intentarConexionConEstado:NO];
                });
            };
            [reach startNotifier];
        }else{
            if (SYSTEM_VERSION_EQUAL_TO(@"7.0"))
            {
                NSLog(@"Intentar Librería iOS 7");
                // ACA IRA CÓDIGO PARA LIBRERIA DE SER IMPLEMENTADA
                
                
                _miGeofaro = [Geofaro sharedGeofaro];
                [_miGeofaro setDelegate:self];
                [_miGeofaro setFlagNotificaciones:YES];
                [_miGeofaro
                 setNotificacionBotonCancel:@"OK"];
                [_miGeofaro setUd:token];
                [_miGeofaro setErrorImage:[UIImage imageNamed:@"imagenerror.png"]];
                [_miGeofaro setFlagOcultarBarraStatus:YES];
                [_miGeofaro setFlagAlertaPower:NO];
                [_miGeofaro setLaunchOptions:miLaunchOptions];
                [_miGeofaro iniciar];
                
                
            }else{
                NSLog(@"No Cargar Geofaro");
            }
        }
        
        
        
        
        //[self iniciarGeofaro];
        
        /*
        
        //21 ch 18 qr
        GFKManagerOptions *opciones = [GFKManagerOptions nuevaConfiguracionParaAppID:@"21" conClienteId:@"cine" appUsaToken:YES token:token appUsaRegiones:YES appName:@"appCineHorarios"];
        
        
        
        GFKManager *manager = [GFKManager GeoFaroManager];
        // PASO 5 -> Setear las opciones del paso 3 al GFKManager creado en el paso 4
        [manager setDelegate:self];
        [manager setOpciones:opciones];
        
        /***********************************************************/
        // PASO 6 -> Iniciar GeoFaro
        /*
        NSError *geoError;
        BOOL ok = [manager iniciarGeoFaroReporteError:&geoError];
        
        if (ok) {
            NSLog(@"Geofaro ha iniciado Error:%@",geoError);
            
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(reachabilityChanged:)
                                                         name:kReachabilityChangedNotification
                                                       object:nil];
            
            Reachability * reach = [Reachability reachabilityWithHostname:@"www.google.com"];
            
            reach.reachableBlock = ^(Reachability * reachability)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"Si");
                    [manager intentarConexionConEstado:YES];
                    
                });
            };
            
            reach.unreachableBlock = ^(Reachability * reachability)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"NO");
                    [manager intentarConexionConEstado:NO];
                });
            };
            
            [reach startNotifier];
            
            */
            
        /*}else{
            NSLog(@"Geofaro NO ha iniciado Error:%@",geoError);
        }
        */
        
    }
    
        
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"didReceiveRemoteNotification %@",userInfo);
    long numero = application.applicationIconBadgeNumber++;
    [application setApplicationIconBadgeNumber:numero];
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    
    /*
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

            NSLog(@"miNotificationsOptions %@",miNotificationsOptions);
             NSString *sn = [dict valueForKey:@"SN"];
             NSString *so = [dict valueForKey:@"SO"];
             NSLog(@"sn %@",sn);
             NSLog(@"so %@",so);
        }
    }else{
        NSLog(@"no es iOS7");
        //iOS 6
        //NSURLConnection
    }
    */
    completionHandler(UIBackgroundFetchResultNewData);
}


- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
   // NSLog(@">.<");
}

/* Sent periodically to notify the delegate of download progress. */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    
    //NSLog(@"^_^");
}

/* Sent when a download has been resumed. If a download failed with an
 * error, the -userInfo dictionary of the error will contain an
 * NSURLSessionDownloadTaskResumeData key, whose value is the resume
 * data.
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    
    //NSLog(@"o.0");
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

#pragma mark - GeofaroDelegate



-(void)reachabilityChanged:(NSNotification*)note{
    // Revisar el estado de conexión
}

- (void)geofaro:(Geofaro *)geofaro areaIN:(CLRegion *)areaInfo
{
    
}

- (void)geofaro:(Geofaro *)geofaro areaOUT:(CLRegion *)areaInfo
{
    
}

- (void)geofaro:(Geofaro *)geofaro faroEncontrado:(NSDictionary *)faroInfo
{
    
}

- (void)geofaro:(Geofaro *)geofaro faroEncontradoNuevo:(NSDictionary *)faroInfo
{
    
}

- (void)geofaro:(Geofaro *)geofaro faroEncontradoPromocionViewController:(UIViewController *)promocionViewController
{
    UIViewController *viewController = self.window.rootViewController.presentedViewController;
    if (viewController) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [viewController presentViewController:promocionViewController
                                         animated:YES completion:^{
                                         }]; });
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.window.rootViewController
             presentViewController:promocionViewController animated:YES completion:^{
             }]; });
    }
}



-(void)mostrarPromocionViewControllerConAnuncio:
(PromocionViewController*)pvc{
    UIViewController *viewController =
    self.window.rootViewController.presentedViewController;
    if (viewController) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [viewController presentViewController:pvc
                                         animated:YES completion:^{
                                         }]; });
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.window.rootViewController
             presentViewController:pvc animated:YES completion:^{
             }]; });
    }
}

#endif


@end
