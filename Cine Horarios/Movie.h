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
@property (nonatomic, assign, readonly) NSUInteger duration;
@property (nonatomic, strong, readonly) NSString *nameOriginal;
@property (nonatomic, strong, readonly) NSString *information;
@property (nonatomic, strong, readonly) NSString *rating;
@property (nonatomic, assign, readonly) NSUInteger year;
@property (nonatomic, strong, readonly) NSString *metacriticURL;
@property (nonatomic, assign, readonly) NSUInteger metacriticScore;
@property (nonatomic, strong, readonly) NSString *imdbCode;
@property (nonatomic, assign, readonly) NSUInteger imdbScore;
@property (nonatomic, strong, readonly) NSString *rottenTomatoesURL;
@property (nonatomic, assign, readonly) NSUInteger rottenTomatoesScore;
@property (nonatomic, strong, readonly) NSString *debut;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong, readonly) NSString *genres;
@property (nonatomic, strong, readonly) NSArray *videos;
@property (nonatomic, strong, readonly) NSArray *people;

+ (void)getCinemaWithBlock:(void (^)(Movie *movie, NSError *error))block movieID:(NSUInteger )movieID;
+ (id)loadMovieWithMovieID:(NSUInteger)movieID;

@end
