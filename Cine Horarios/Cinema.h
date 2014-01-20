//
//  Cinema.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 19-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "MTLModelPersistable.h"
#import "MTLJSONAdapter.h"

@interface Cinema : MTLModelPersistable <MTLJSONSerializing>

@property (nonatomic, assign, readonly) NSUInteger cinemaID;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSArray *theaters;

+ (void)getCinemaWithBlock:(void (^)(Cinema *cinema, NSError *error))block cinemaID:(NSUInteger )cinemaID;
+ (id)loadCinemaWithCinemaID:(NSUInteger)cinemaID;

@end
