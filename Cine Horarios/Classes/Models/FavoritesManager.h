//
//  FavoritesManager.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 14-12-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Theater;

@interface FavoritesManager : NSObject

@property (nonatomic, strong) NSMutableArray *favoriteTheaters;

+ (instancetype) sharedManager;

+ (void) setShouldDownloadFavorites:(BOOL)shouldDownload;
+ (BOOL) getShouldDownloadFavorites;

+ (void) prepareForDownloadBySavingToUserDefaultsFavoriteTheatersIds:(NSArray *)theatersIds;
+ (NSArray *) getFavoriteTheatersIdsFromUserDefaults;


- (NSArray *) theatersIds;
- (void)downloadFavoriteTheatersWithBlock:(void (^)(NSError *error))block;
- (void) saveFavoriteTheatersToDocuments;
- (BOOL) containsTheaterWithTheaterID:(NSInteger)theaterID;
- (Theater *) theaterWithTheaterID:(NSInteger)theaterID;
- (BOOL) removeTheaterWithTheaterID:(NSInteger)theaterID;
- (void) addTheater:(Theater *)theater;
- (void) toggleTheater:(Theater *)theater;
- (void) toggleTheater:(Theater *)theater withCompletionBlock:(void (^)())completionBlock;

- (void) loadFromDictionaryRepresentationArray:(NSArray *)dictinoaryRepresentationArray;
- (NSArray *) getDictionaryRepresentationArray;

- (NSArray *)getTheatersWithCinemaID:(NSInteger)cinemaID;

@end
