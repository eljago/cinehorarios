//
//  Movie2.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 22-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "MTLModelPersistable.h"
#import "MTLJSONAdapter.h"

@interface Movie : MTLModelPersistable <MTLJSONSerializing>

@property (nonatomic, assign, readonly) NSUInteger movieID;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *imageURL;
@property (nonatomic, strong, readonly) NSNumber *duration;
@property (nonatomic, strong, readonly) NSString *nameOriginal;
@property (nonatomic, strong, readonly) NSString *information;
@property (nonatomic, strong, readonly) NSString *rating;
@property (nonatomic, strong, readonly) NSNumber *year;
@property (nonatomic, strong, readonly) NSString *metacriticURL;
@property (nonatomic, strong, readonly) NSNumber *metacriticScore;
@property (nonatomic, strong, readonly) NSString *imdbCode;
@property (nonatomic, strong, readonly) NSNumber *imdbScore;
@property (nonatomic, strong, readonly) NSString *rottenTomatoesURL;
@property (nonatomic, strong, readonly) NSNumber *rottenTomatoesScore;
@property (nonatomic, strong, readonly) NSString *debut;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong, readonly) NSString *genres;
@property (nonatomic, strong, readonly) NSArray *videos;
@property (nonatomic, strong, readonly) NSArray *people;
@property (nonatomic, assign, readonly) BOOL hasFunctions;

+ (void)getCinemaWithBlock:(void (^)(Movie *movie, NSError *error))block movieID:(NSUInteger )movieID;
+ (id)loadMovieWithMovieID:(NSUInteger)movieID;

@end
