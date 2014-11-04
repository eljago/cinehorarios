//
//  Person.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 22-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "MTLModel.h"
#import "MTLJSONAdapter.h"

@interface Person : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, assign, readonly) BOOL actor;
@property (nonatomic, assign, readonly) BOOL director;
@property (nonatomic, strong, readonly) NSString *character;
@property (nonatomic, strong, readonly) NSString *imageURL;
@property (nonatomic, strong, readonly) NSString *imdbCode;

@end
