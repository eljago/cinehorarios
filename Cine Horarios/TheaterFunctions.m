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
    NSLog(@"%@",attributes);
    
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

+ (void)getMovieTheatersFavoritesWithBlock:(void (^)(NSArray *theaters, NSError *error))block movieID:(NSUInteger )movieID {
    NSString *path = [NSString stringWithFormat:RemoteMovieTheaterFunctionsPath,movieID];
    [[CineHorariosApiClient sharedClient] GET:path parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        
        NSArray *theaters = [TheaterFunctions theatersFunctionsFromJSON:JSON];
        
        if (block) {
            block(theaters, nil);
        }
    } failure:^(NSURLSessionDataTask * __unused task, NSError *error) {
        if (block) {
            block([NSArray array], error);
        }
    }];
}
    
@end
