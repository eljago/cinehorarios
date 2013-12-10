//
//  Theater.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 11-05-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "BasicItem.h"

@interface Theater : BasicItem

@property (nonatomic, assign, readonly) NSUInteger cinemaID;

- (id)initWithAttributes:(NSDictionary *)attributes;

+ (NSArray *) getLocalTheatersWithCinemaID:(NSUInteger) cinemaID;

+ (void)getTheatersWithBlock:(void (^)(NSArray *cinemas, NSError *error))block
                                      cinemaID:(NSUInteger )cinemaID;

+ (NSArray *) getLocalMovieTheatersWithMovieID:(NSUInteger) movieID;
+ (void)getMovieTheatersWithBlock:(void (^)(NSArray *theaters, NSError *error))block movieID:(NSUInteger )movieID;
@end
