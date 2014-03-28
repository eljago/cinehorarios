//
//  BasicItem2.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 22-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "MTLModel.h"
#import "MTLJSONAdapter.h"

@interface BasicItem : MTLModel <MTLJSONSerializing>

@property (nonatomic, assign, readonly) NSUInteger itemID;
@property (nonatomic, strong, readonly) NSString *name;

@end
