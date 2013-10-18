//
//  TheaterFunctions.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 17-10-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "Theater.h"

@interface TheaterFunctions : Theater

@property (nonatomic, strong) NSArray *functions;
+ (void)getMovieTheatersFavoritesWithBlock:(void (^)(NSArray *theaters, NSError *error))block movieID:(NSUInteger )movieID;

@end
