//
//  Theater2.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 19-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "MTLModelPersistable.h"
#import "MTLJSONAdapter.h"

@interface Theater2 : MTLModelPersistable <MTLJSONSerializing>

@property (nonatomic, assign, readonly) NSUInteger theaterID;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *webURL;
@property (nonatomic, strong, readonly) NSArray *functions;

+ (void)getTheaterWithBlock:(void (^)(Theater2 *theater, NSError *error))block theaterID:(NSUInteger )theaterID;
+ (id)loadTheaterithTheaterID:(NSUInteger)theaterID;

@end
