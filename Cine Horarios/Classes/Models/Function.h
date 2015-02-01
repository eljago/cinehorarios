//
//  Function2.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 20-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "MTLModelPersistable.h"
#import "MTLJSONAdapter.h"

@interface Function : MTLModel <MTLJSONSerializing>

@property (nonatomic, assign, readonly) NSUInteger movieID;
@property (nonatomic, strong, readonly) NSString *showtimes;
@property (nonatomic, strong, readonly) NSString *functionTypes;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *imageURL;
@property (nonatomic, strong, readonly) NSString *portraitImageURL;

+ (void)getMovieTheatersFavoritesWithBlock:(void (^)(NSArray *theaterFunctions, NSError *error))block movieID:(NSUInteger )movieID theaters:(NSArray *)theaters date:(NSDate *)date;

@end
