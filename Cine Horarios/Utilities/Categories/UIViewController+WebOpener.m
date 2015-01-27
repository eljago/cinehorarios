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
    
    NSString *actionSheetTitle = @"Abrir enlace en:";
    NSString *cancelTitle = @"Cancelar";
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"App", @"Safari", nil];
    
    if ([self.openInChromeController isChromeInstalled]) {
        [actionSheet addButtonWithTitle:@"Chrome"];
    }
    
    if (appImdbUrlString) {
        NSURL *nsurl = [NSURL URLWithString:appImdbUrlString];
        if ([[UIApplication sharedApplication] canOpenURL:nsurl]) {
            [actionSheet addButtonWithTitle:@"App Imdb"];
        }
    }
    
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:@"App"]) {
        WebVC *wvc = [self.storyboard instantiateViewControllerWithIdentifier:@"WebVC"];
        wvc.urlString = self.webToOpenUrlString;
        [self.navigationController pushViewController:wvc animated:YES];
    }
    else if ([buttonTitle isEqualToString:@"Safari"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.webToOpenUrlString]];
    }
    else if ([buttonTitle isEqualToString:@"Chrome"]) {
        if ([self.openInChromeController isChromeInstalled]) {
            [self.openInChromeController openInChrome:[NSURL URLWithString:self.webToOpenUrlString]
                                      withCallbackURL:nil
                                         createNewTab:YES];
        }
    }
    else if ([buttonTitle isEqualToString:@"App Imdb"]) {
        NSURL *url = [NSURL URLWithString:self.imdbAppUrlString];
        [[UIApplication sharedApplication] openURL:url];
    }
}

@end
