//
//  TheaterFunctions.m
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 17-10-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "TheaterFunctions.h"
#import "Function.h"
#import "CineHorariosApiClient.h"

NSString *const RemoteMovieTheaterFunctionsPath = @"/api/shows/%d/favorite_theaters.json";

@implementation TheaterFunctions
    
- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super initWithAttributes:attributes];
    if (!self) {
        return nil;
    }
    NSMutableArray *mutableFunctions = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in attributes[@"functions"]) {
        Function *function = [[Function alloc] initWithAttributes:dict];
        [mutableFunctions addObject:function];
    }
    self.functions = [[NSMutableArray alloc] initWithArray:mutableFunctions];
    
    return self;
}

+ (NSArray *) theatersFunctionsFromJSON:(id) JSON {
    
    NSMutableArray *mutableItems = [[NSMutableArray alloc] init];
    for (NSDictionary *theaterAttributes in JSON) {
        TheaterFunctions *theater = [[TheaterFunctions alloc] initWithAttributes:theaterAttributes];
        [mutableItems addObject:theater];
    }
    
    return [NSArray arrayWithArray:mutableItems];
}

+ (void)getMovieTheatersFavoritesWithBlock:(void (^)(NSArray *theaterFunctions, NSError *error))block movieID:(NSUInteger )movieID theaters:(NSArray *)theaters {
    NSString *path = [NSString stringWithFormat:RemoteMovieTheaterFunctionsPath,movieID];
    NSString *theatersString = [NSString stringWithFormat:@"%d",((BasicItem *)[theaters firstObject]).itemId];
    for (int i=1; i<theaters.count;i++) {
        BasicItem *item = theaters[i];
        theatersString = [theatersString stringByAppendingFormat:@",%d",item.itemId];
    }

    [[CineHorariosApiClient sharedClient] GET:path parameters:@{ @"favorites": theatersString } success:^(NSURLSessionDataTask * __unused task, id JSON) {
        
        NSArray *theaterFunctions = [TheaterFunctions theatersFunctionsFromJSON:JSON];
        
        if (block) {
            block(theaterFunctions, nil);
        }
    } failure:^(NSURLSessionDataTask * __unused task, NSError *error) {
        if (block) {
            block([NSArray array], error);
        }
    }];
}
    
@end
