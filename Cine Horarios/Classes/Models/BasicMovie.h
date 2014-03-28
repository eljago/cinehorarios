//
//  BasicMovie2.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 20-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "MTLModel.h"
#import "MTLJSONAdapter.h"

@interface BasicMovie : MTLModel <MTLJSONSerializing>

@property (nonatomic, assign, readonly) NSUInteger movieID;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *imageURL;
@property (nonatomic, strong, readonly) NSNumber *duration;
@property (nonatomic, strong, readonly) NSString *portraitImageURL;
@property (nonatomic, strong, readonly) NSString *debut;
@property (nonatomic, strong, readonly) NSString *genres;

@end
