//
//  GAI+CH.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 21-02-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "GAI.h"

@interface GAI (CH)

+ (void) trackPage:(NSString *)pageName;
+ (void) sendEventWithCategory:(NSString *)category action:(NSString *)action label:(NSString *)label;

@end
