//
//  NSObject+WebOpener.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 26-01-15.
//  Copyright (c) 2015 Arturo Espinoza Carrasco. All rights reserved.
//

#import <Foundation/Foundation.h>
@class OpenInChromeController;

@interface UIViewController (WebOpener) <UIActionSheetDelegate>

-(void)goWebPageWithUrlString:(NSString *)urlString imdbAppUrlString:(NSString *)appImdbUrlString;
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
