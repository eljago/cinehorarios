//
//  GAI+CH.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 21-02-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "GAI+CH.h"
#import "GAITracker.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"

@implementation GAI (CH)

+ (void) trackPage:(NSString *)pageName {
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[[GAIDictionaryBuilder createAppView] set:pageName forKey:kGAIScreenName] build]];
}
+ (void) sendEventWithCategory:(NSString *)category action:(NSString *)action label:(NSString *)label {
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:category
                                                          action:action
                                                           label:label
                                                           value:nil] build]];
}

@end
