//
//  FavoritesManager.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 14-12-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "FavoritesManager.h"
#import "Theater.h"
#import "NSArray+FKBMap.h"
#import "CineHorariosApiClient.h"
#import "BasicItemImage.h"
#import "Constants.h"

static NSString * const kFavoriteTheatersPath = @"/api/theaters";
static NSString * const kTheatersDataPathComponent = @"favoriteTheaters.data";

static NSString * const kShouldDownloadFavoriteTheaters = @"ShouldDownloadFavoriteTheaters";

@implementation FavoritesManager

+ (FavoritesManager *)sharedManager {
    static FavoritesManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

- (id)init {
    if (self = [super init]) {
        [self loadFavoritesTheaters];
        [self loadCinemas];
    }
    return self;
}

- (NSArray *) getDictionaryRepresentationArray {
    NSMutableArray *dictionaryRepresentationArray = [NSMutableArray new];
    for (Theater *theater in _favoriteTheaters) {
        NSDictionary *theaterDictionary = @{
                                      @"name": theater.name,
                                      @"id": [NSNumber numberWithInteger:theater.theaterID],
                                      @"cinema_id": [NSNumber numberWithInteger:theater.cinemaID],
                                      @"web_url": theater.webURL,
                                      @"information": theater.information,
                                      @"address": theater.address,
                                      @"date": theater.date,
                                      @"latitude": theater.latitude,
                                      @"longitude": theater.longitude
                                      };
        [dictionaryRepresentationArray addObject:theaterDictionary];
    }
    return [NSArray arrayWithArray:dictionaryRepresentationArray];
}
- (void) loadFromDictionaryRepresentationArray:(NSArray *)dictinoaryRepresentationArray {
    NSMutableArray *newFavoriteTheatersArray = [NSMutableArray new];
    for (NSDictionary *theaterDictionary in dictinoaryRepresentationArray) {
        Theater *theater = [MTLJSONAdapter modelOfClass:Theater.class fromJSONDictionary:theaterDictionary error:nil];
        [newFavoriteTheatersArray addObject:theater];
    }
    [self saveFavoriteTheatersToDocuments];
}



#pragma mark - Class Methods

+ (NSString *) favoriteTheatersPath {
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *favoritesPath = [documentsPath stringByAppendingPathComponent:kTheatersDataPathComponent];
    return favoritesPath;
}

+ (void) setShouldDownloadFavorites:(BOOL)shouldDownload {
    [[NSUserDefaults standardUserDefaults] setBool:shouldDownload forKey:kShouldDownloadFavoriteTheaters];
}
+ (BOOL) getShouldDownloadFavorites {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kShouldDownloadFavoriteTheaters];
}

+ (NSString *) favoriteTheaterIdsParameter {
    NSArray *favoriteTheatersIds = [self getFavoriteTheatersIdsFromUserDefaults];
    NSString *theatersString;
    if (favoriteTheatersIds) {
        theatersString = [NSString stringWithFormat:@"%@", [favoriteTheatersIds firstObject]];
        for (int i=1; i<favoriteTheatersIds.count;i++) {
            theatersString = [theatersString stringByAppendingFormat:@",%@",favoriteTheatersIds[i]];
        }
    }
    
    return theatersString;
}

+ (void) prepareForDownloadBySavingToUserDefaultsFavoriteTheatersIds:(NSArray *)theatersIds {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:theatersIds forKey:CH_ICLOUD_FAVORITES_IDS];
}
+ (NSArray *) getFavoriteTheatersIdsFromUserDefaults {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults valueForKey:CH_ICLOUD_FAVORITES_IDS];
}

#pragma mark - Instance Methods
#pragma mark Private
- (NSMutableArray *) loadFavoritesTheaters {
    NSString *favoritesPath = [FavoritesManager favoriteTheatersPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:favoritesPath]) {
        _favoriteTheaters = [NSMutableArray new];
        [self saveFavoriteTheatersToDocuments];
    }
    else {
        _favoriteTheaters = [NSKeyedUnarchiver unarchiveObjectWithFile:favoritesPath];
    }
    return _favoriteTheaters;
}

- (void) loadCinemas {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Cinemas" ofType:@"plist"];
    NSArray *cinemasLocal = [NSArray arrayWithContentsOfFile:filePath];
    
    NSMutableArray *mutableCinemas = [NSMutableArray array];
    for (NSDictionary *dict in cinemasLocal) {
        BasicItemImage *cinema = [MTLJSONAdapter modelOfClass:BasicItemImage.class fromJSONDictionary:dict error:NULL];
        [mutableCinemas addObject:cinema];
    }
    _cinemasArray = [NSArray arrayWithArray:mutableCinemas];
}

#pragma mark Public


- (NSArray *) theatersIds {
    return [_favoriteTheaters fkbMap:^id(Theater *theater) {
        return [NSNumber numberWithInteger:theater.theaterID];
    }];
}

- (void)downloadFavoriteTheatersWithBlock:(void (^)(NSError *error))block {
    
    NSString *favoriteTheaterIdsParameter = [FavoritesManager favoriteTheaterIdsParameter];
    if ([FavoritesManager getShouldDownloadFavorites] && favoriteTheaterIdsParameter) {
        [[CineHorariosApiClient sharedClient] GET:kFavoriteTheatersPath parameters:@{ @"favorites": favoriteTheaterIdsParameter } success:^(NSURLSessionDataTask * __unused task, id JSON) {
            
            _favoriteTheaters = [[JSON fkbMap:^Theater *(NSDictionary *theaterDictionary) {
                return [MTLJSONAdapter modelOfClass:Theater.class fromJSONDictionary:theaterDictionary error:nil];
            }] mutableCopy];
            [self saveFavoriteTheatersToDocuments];
            
            [FavoritesManager setShouldDownloadFavorites:NO];
            
            if (block) {
                block(nil);
            }
        } failure:^(NSURLSessionDataTask * __unused task, NSError *error) {
            if (block) {
                block(error);
            }
        }];
    }
    else {
        [FavoritesManager setShouldDownloadFavorites:NO];
        block(nil);
    }
}

- (void) saveFavoriteTheatersToDocuments {
    NSString *favoritesPath = [FavoritesManager favoriteTheatersPath];
    [NSKeyedArchiver archiveRootObject:_favoriteTheaters toFile:favoritesPath];
    
    NSArray *theaterIds = [self theatersIds];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Update Favorites"
                                                        object:self
                                                      userInfo:@{@"TheaterIds": theaterIds}];
}

- (BOOL) containsTheaterWithTheaterID:(NSInteger)theaterID {
    return [[self theatersIds] containsObject:[NSNumber numberWithInteger:theaterID]];
}
- (Theater *) theaterWithTheaterID:(NSInteger)theaterID {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"theaterID = %lu",(unsigned long)theaterID];
    return [[_favoriteTheaters filteredArrayUsingPredicate:predicate] firstObject];
    
}
- (BOOL) removeTheaterWithTheaterID:(NSInteger)theaterID {
    Theater *theater = [self theaterWithTheaterID:theaterID];
    if (theater) {
        [_favoriteTheaters removeObject:theater];
        [self saveFavoriteTheatersToDocuments];
        return YES;
    }
    else {
        return NO;
    }
}
- (void) addTheater:(Theater *)theater {
    
    NSDictionary *theaterDict = @{
                                  @"id": [NSNumber numberWithInteger:theater.theaterID],
                                  @"cinema_id": [NSNumber numberWithInteger:theater.cinemaID],
                                  @"name": theater.name,
                                  @"address": theater.address,
                                  @"latitude": theater.latitude,
                                  @"longitude": theater.longitude,
                                  @"web_url": theater.webURL,
                                  @"information": theater.information,
                                  @"date": theater.date
                                  };
    Theater *newTheater = [MTLJSONAdapter modelOfClass:Theater.class
                                    fromJSONDictionary:theaterDict
                                                 error:nil];
    if (newTheater) {
        [_favoriteTheaters addObject:newTheater];
        [self saveFavoriteTheatersToDocuments];
    }
}

- (void) toggleTheater:(Theater *)theater {
    if ([self containsTheaterWithTheaterID:theater.theaterID])
        [self removeTheaterWithTheaterID:theater.theaterID];
    else
        [self addTheater:theater];
}
- (void) toggleTheater:(Theater *)theater withCompletionBlock:(void (^)())completionBlock {
    [self toggleTheater:theater];
    completionBlock();
}


- (NSArray *)getTheatersWithCinemaID:(NSInteger)cinemaID {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cinemaID = %lu",(unsigned long)cinemaID];
    return [_favoriteTheaters filteredArrayUsingPredicate:predicate];
}

@end
