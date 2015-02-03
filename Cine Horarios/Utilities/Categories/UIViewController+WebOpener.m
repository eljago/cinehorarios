//
//  NSObject+WebOpener.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 26-01-15.
//  Copyright (c) 2015 Arturo Espinoza Carrasco. All rights reserved.
//

#import "UIViewController+WebOpener.h"
#import <objc/runtime.h>
#import "OpenInChromeController.h"
#import "WebVC.h"
#import "SIAlertView.h"

@implementation UIViewController (WebOpener)

- (void)setImdbAppUrlString:(NSString *)imdbAppUrlString { objc_setAssociatedObject(self, @selector(imdbAppUrlString), imdbAppUrlString, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }
- (NSString *)imdbAppUrlString { return objc_getAssociatedObject(self, @selector(imdbAppUrlString)); }

- (void)setWebToOpenUrlString:(NSString *)webToOpenUrlString { objc_setAssociatedObject(self, @selector(webToOpenUrlString), webToOpenUrlString, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }
- (NSString *)webToOpenUrlString { return objc_getAssociatedObject(self, @selector(webToOpenUrlString)); }

- (void)setOpenInChromeController:(OpenInChromeController *)openInChromeController { objc_setAssociatedObject(self, @selector(openInChromeController), openInChromeController, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }
- (OpenInChromeController *)openInChromeController {
    if (!objc_getAssociatedObject(self, @selector(openInChromeController))) {
        OpenInChromeController *oicc = [[OpenInChromeController alloc] init];
        [self setOpenInChromeController:oicc];
        return oicc;
    }
    return objc_getAssociatedObject(self, @selector(openInChromeController));
}

-(void)goWebPageWithUrlString:(NSString *)urlString imdbAppUrlString:(NSString *)appImdbUrlString {
    self.imdbAppUrlString = appImdbUrlString;
    self.webToOpenUrlString = urlString;
    
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Abrir enlace en:" andMessage:nil];
    
    [alertView addButtonWithTitle:@"App"
                             type:SIAlertViewButtonTypeCancel
                          handler:^(SIAlertView *alert) {
                              WebVC *wvc = [self.storyboard instantiateViewControllerWithIdentifier:@"WebVC"];
                              wvc.urlString = self.webToOpenUrlString;
                              [self.navigationController pushViewController:wvc animated:YES];
                          }];
    [alertView addButtonWithTitle:@"Safari"
                             type:SIAlertViewButtonTypeCancel
                          handler:^(SIAlertView *alert) {
                              [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.webToOpenUrlString]];
                          }];
    if ([self.openInChromeController isChromeInstalled]) {
        [alertView addButtonWithTitle:@"Chrome"
                                 type:SIAlertViewButtonTypeCancel
                              handler:^(SIAlertView *alert) {
                                  if ([self.openInChromeController isChromeInstalled]) {
                                      [self.openInChromeController openInChrome:[NSURL URLWithString:self.webToOpenUrlString]
                                                                withCallbackURL:nil
                                                                   createNewTab:YES];
                                  }
                              }];
    }
    
    if (appImdbUrlString) {
        NSURL *nsurl = [NSURL URLWithString:appImdbUrlString];
        if ([[UIApplication sharedApplication] canOpenURL:nsurl]) {
            [alertView addButtonWithTitle:@"App Imdb"
                                     type:SIAlertViewButtonTypeCancel
                                  handler:^(SIAlertView *alert) {
                                      NSURL *url = [NSURL URLWithString:self.imdbAppUrlString];
                                      [[UIApplication sharedApplication] openURL:url];
                                  }];
        }
    }
    
    [alertView addButtonWithTitle:@"Cancelar"
                             type:SIAlertViewButtonTypeDestructive
                          handler:nil];
    
    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    [alertView show];
}

@end
