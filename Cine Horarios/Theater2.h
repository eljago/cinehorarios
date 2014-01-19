//
//  Theater2.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 19-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "MTLModel.h"
#import "MTLJSONAdapter.h"

@interface Theater2 : MTLModel <MTLJSONSerializing>

@property (nonatomic, assign, readonly) NSUInteger theaterID;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, assign, readonly) NSUInteger cinemaID;

+ (void)getTheatersWithBlock:(void (^)(NSArray *theaters, NSError *error))block cinemaID:(NSUInteger )cinemaID;

@end
