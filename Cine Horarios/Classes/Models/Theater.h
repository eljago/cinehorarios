//
//  Theater2.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 19-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "MTLModelPersistable.h"
#import "MTLJSONAdapter.h"

@interface Theater : MTLModelPersistable <MTLJSONSerializing>

@property (nonatomic, assign, readonly) NSUInteger theaterID;
@property (nonatomic, assign, readonly) NSUInteger cinemaID;
@property (nonatomic, strong, readonly) NSString *latitude;
@property (nonatomic, strong, readonly) NSString *longitude;
@property (nonatomic, strong, readonly) NSString *information;
@property (nonatomic, strong, readonly) NSString *address;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *webURL;
@property (nonatomic, strong, readonly) NSString *date;
@property (nonatomic, strong, readonly) NSArray *functions;

+ (void)getTheaterWithBlock:(void (^)(Theater *theater, NSError *error))block theaterID:(NSUInteger )theaterID date:(NSDate *)date;
+ (id)loadTheaterWithTheaterID:(NSUInteger)theaterID date:(NSDate *)date;
+ (void)getMovieTheatersWithBlock:(void (^)(NSArray *theaters, NSError *error))block movieID:(NSUInteger )movieID;
+ (void)getFavoriteTheatersWithBlock:(void (^)(NSArray *theaters, NSError *error))block;
+ (NSArray *) getFavoriteTheatersFromDocuments;
+ (void) saveFavoriteTheatersToDocuments:(NSArray *)favoriteTheaters;
+ (void) setShouldDownloadFavoriteTheaters:(BOOL)shouldDownload;
+ (BOOL) getShouldDownloadFavoriteTheaters;
+ (NSArray *) getFavoriteTheatersIdsArray;
+ (void) saveFavoriteTheatersIdsArray: (NSArray *)favoriteTheatersIdsArray;
+ (void) addOrRemoveTheaterFromFavoriteTheaterIds:(Theater *)theater;
+ (Theater *) getTheaterFromFavoritesInDocumentsWithTheaterID:(NSUInteger)theaterID;
+ (Theater *) getTheaterFromArray:(NSArray *)theatersArray withTheaterID:(NSUInteger)theaterID;
+ (void) removeFromFavoritesInDocumentsTheaterWithTheaterID:(NSUInteger)theaterID;
- (void) addToFavoriteTheatersInDocuments;
- (void) addOrRemoveFromFavoritesWithCompletionBlock:(void (^)())completionBlock;

@end
