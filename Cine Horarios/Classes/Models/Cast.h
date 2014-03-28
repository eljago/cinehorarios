//
//  Cast.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 23-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cast : NSObject

@property (nonatomic, strong, readonly) NSArray *directors;
@property (nonatomic, strong, readonly) NSArray *actors;

-(id)initWithDirectors:(NSArray *)directors actors:(NSArray *)actors;

@end
