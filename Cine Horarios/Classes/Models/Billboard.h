//
//  Billboard.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 20-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "MTLModelPersistable.h"
#import "MTLJSONAdapter.h"

@interface Billboard : MTLModelPersistable <MTLJSONSerializing>

@property (nonatomic, strong, readonly) NSArray *movies;

+ (void)getBillboardWithBlock:(void (^)(Billboard *billboard, NSError *error))block;
+ (id)loadBillboard;
+ (void)getComingSoonWithBlock:(void (^)(Billboard *billboard, NSError *error))block;
+ (id)loadComingSoon;

@end
