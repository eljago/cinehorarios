//
//  Function.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 11-05-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "BasicImageItem.h"

@interface Function : BasicImageItem

@property (nonatomic, readonly) NSString *types;
@property (nonatomic, readonly) NSString *showtimes;
@property (nonatomic, readonly) NSString *portraitImageURL;

- (id)initWithAttributes:(NSDictionary *)attributes;
+ (NSArray *) getLocalFunctionsWithTheaterID:(NSUInteger) theaterID dateString:(NSString *)dateString;
+ (void)getFunctionsWithBlock:(void (^)(NSArray *functions, NSString *theater_url, NSError *error))block
                                      theaterID:(NSUInteger )theaterID
                                           date:(NSDate *)date;
+ (NSArray *) getLocalMovieFunctionsWithMovieID:(NSUInteger) movieID theaterID:(NSUInteger)theaterID dateString:(NSString *)dateString;
+ (void)getMovieFunctionsWithBlock:(void (^)(NSArray *functions, NSError *error))block
                           movieID:(NSUInteger )movieID
                         theaterID:(NSUInteger )theaterID
                              date:(NSDate *)date;
@end
