//
//  ShowItem.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 04-04-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "BasicImageItem.h"

@interface BasicMovie : BasicImageItem

@property (nonatomic, strong,  readonly) NSString *duration;
@property (nonatomic, strong,  readonly) NSString *debut;
@property (nonatomic, strong,  readonly) NSString *genres;
@property (nonatomic, strong, readonly) NSString *portraitImageURL;

+ (NSArray *) getLocalCartelera;
+ (NSArray *) getLocalComingSoon;
+ (void)getCarteleraWithBlock:(void (^)(NSArray *movies, NSError *error))block;
+ (void)getComingSoonWithBlock:(void (^)(NSArray *movies, NSError *error))block;

@end
