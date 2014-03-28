//
//  AnnotationGroup.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 23-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "MTLModelPersistable.h"
#import "MTLJSONAdapter.h"

@interface AnnotationGroup : MTLModelPersistable <MTLJSONSerializing>

@property (nonatomic, strong, readonly) NSMutableArray *annotationTheaters;

+ (void)getAnnotationsWithBlock:(void (^)(AnnotationGroup *annotationGroup, NSError *error))block;
+ (id)loadAnnotationGroup;

@end
