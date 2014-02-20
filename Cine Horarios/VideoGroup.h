//
//  VideoGroup.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 18-02-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "MTLModelPersistable.h"
#import "MTLJSONAdapter.h"

@interface VideoGroup : MTLModelPersistable <MTLJSONSerializing>

@property (nonatomic, strong, readonly) NSMutableArray *videos;

+ (void)getVideosWithBlock:(void (^)(VideoGroup *videoGroup, NSError *error))block page:(NSUInteger)page;
+ (id)loadVideoGroup;

@end
