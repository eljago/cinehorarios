//
//  Video.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 22-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "MTLModel.h"
#import "MTLJSONAdapter.h"

@class BasicMovie;

@interface Video : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *code;
@property (nonatomic, strong, readonly) NSString *imageURL;
@property (nonatomic, strong, readonly) NSString *videoType;
@property (nonatomic, strong, readonly) BasicMovie *movie;

@end
