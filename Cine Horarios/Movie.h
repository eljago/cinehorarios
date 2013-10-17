//
//  MovieItem.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 08-04-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "BasicMovie.h"

@class BasicImageItem;

@interface Movie : BasicMovie

@property (nonatomic, strong,  readonly) NSString *nameOriginal;
@property (nonatomic, strong,  readonly) NSString *year;
@property (nonatomic, strong,  readonly) NSString *synopsis;
@property (nonatomic, strong,  readonly) NSString *rating;
@property (nonatomic, strong,  readonly) NSArray *images;
@property (nonatomic, strong,  readonly) NSArray *videos;
@property (nonatomic, strong,  readonly) NSArray *actors;
@property (nonatomic, strong,  readonly) NSArray *directors;
@property (nonatomic, strong,  readonly) NSString *facebook_id;
@property (nonatomic, strong,  readonly) NSString *scoreMetacritic;
@property (nonatomic, strong,  readonly) NSString *scoreImdb;
@property (nonatomic, strong,  readonly) NSString *scoreRottenTomatoes;
@property (nonatomic, strong,  readonly) NSString *urlMetacritic;
@property (nonatomic, strong,  readonly) NSString *urlImdb;
@property (nonatomic, strong,  readonly) NSString *urlRottenTomatoes;

- (id)initWithAttributes:(NSDictionary *)attributes;

+ (Movie *) getLocalMovieWithMovieID:(NSUInteger) movieID;
+ (void)getMovieWithBlock:(void (^)(Movie *movie, NSError *error))block
                                    movieID:(NSUInteger )movieID;
@end
