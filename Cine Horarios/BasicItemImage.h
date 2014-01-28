//
//  BasicItemImage.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 22-01-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#import "BasicItem.h"
#import "MTLJSONAdapter.h"

@interface BasicItemImage : BasicItem <MTLJSONSerializing>

@property (nonatomic, strong, readonly) NSString *imageURL;

@end
