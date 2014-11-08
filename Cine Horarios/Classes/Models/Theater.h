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
+ (id)loadTheaterithTheaterID:(NSUInteger)theaterID date:(NSDate *)date;
+ (void)getMovieTheatersWithBlock:(void (^)(NSArray *theaters, NSError *error))block movieID:(NSUInteger )movieID;

@end
