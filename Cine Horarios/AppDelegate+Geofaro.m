//
//  AppDelegate+Geofaro.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 27-01-15.
//  Copyright (c) 2015 Arturo Espinoza Carrasco. All rights reserved.
//

#import "AppDelegate+Geofaro.h"
#import <objc/runtime.h>

#include <stdio.h>
#include <dlfcn.h>
#import <mach-o/dyld.h>

@implementation AppDelegate (Geofaro)

- (void)setMiGeofaro:(Geofaro *)miGeofaro { objc_setAssociatedObject(self, @selector(miGeofaro), miGeofaro, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }
- (Geofaro *)miGeofaro { return objc_getAssociatedObject(self, @selector(miGeofaro)); }

- (void)setMiLaunchOptions:(NSDictionary *)miLaunchOptions { objc_setAssociatedObject(self, @selector(miLaunchOptions), miLaunchOptions, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }
- (NSDictionary *)miLaunchOptions { return objc_getAssociatedObject(self, @selector(miLaunchOptions)); }

- (void)setMiNotificationsOptions:(NSDictionary *)miNotificationsOptions { objc_setAssociatedObject(self, @selector(miNotificationsOptions), miNotificationsOptions, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }
- (NSDictionary *)miNotificationsOptions { return objc_getAssociatedObject(self, @selector(miNotificationsOptions)); }


- (void)geofaroApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.miLaunchOptions = launchOptions;
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
        [application registerForRemoteNotifications];
    }else{
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeNewsstandContentAvailability)];
#pragma GCC diagnostic pop
    }
}

- (void)geofaroApplicationDidEnterBackground:(UIApplication *)application {
    application.applicationIconBadgeNumber = 0;
    
    UIApplication* app = [UIApplication sharedApplication];
    UIBackgroundTaskIdentifier __block bgTask = [app beginBackgroundTaskWithExpirationHandler: ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [app endBackgroundTask:bgTask];
            bgTask = UIBackgroundTaskInvalid;
        });
    }];
}

- (void)geofaroApplicationWillEnterForeground:(UIApplication *)application {
    application.applicationIconBadgeNumber = 0;
}

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
//            NSString *pseudoToken = [NSString stringWithFormat:@"%@",[[[UIDevice currentDevice]identifierForVendor]UUIDString]];
            
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
                
                
                self.miGeofaro = [Geofaro sharedGeofaro];
                [self.miGeofaro setDelegate:self];
                [self.miGeofaro setFlagNotificaciones:YES];
                [self.miGeofaro
                 setNotificacionBotonCancel:@"OK"];
                [self.miGeofaro setUd:token];
                [self.miGeofaro setErrorImage:[UIImage imageNamed:@"imagenerror.png"]];
                [self.miGeofaro setFlagOcultarBarraStatus:YES];
                [self.miGeofaro setFlagAlertaPower:NO];
                [self.miGeofaro setLaunchOptions:self.miLaunchOptions];
                [self.miGeofaro iniciar];
                
                
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

@end
