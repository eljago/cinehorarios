//
//  Genre.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 20-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "MTLModel.h"
#import "MTLJSONAdapter.h"

@interface Genre : MTLModel <MTLJSONSerializing>

@property (nonatomic, assign, readonly) NSUInteger genreID;
@property (nonatomic, strong, readonly) NSString *name;

@end
