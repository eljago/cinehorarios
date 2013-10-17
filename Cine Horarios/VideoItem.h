//
//  VideoItem.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 17-04-13.
//  Copyright (c) 2013 Arturo Espinoza Carrasco. All rights reserved.
//

#import "BasicImageItem.h"

@interface VideoItem : BasicImageItem

@property (nonatomic, strong, readonly) NSString *code;

- (id)initWithAttributes:(NSDictionary *)attributes;

@end
//    code = "j_SY2jFfl2c";
//    "image_url" = "/uploads/covers/video/41/1a658381.jpg";
//    name = "Trailer Oficial 1 Subtitulado";
