//
//  Constants.h
//  Cine Horarios
//
//  Created by Arturo Espinoza Carrasco on 22-12-14.
//  Copyright (c) 2014 Arturo Espinoza Carrasco. All rights reserved.
//

#define CH_ICLOUD_RESETED_FAVORITES     @"ResetedFavorites" // bool in the userdefaults used to check if the favorites have been transfered from the old version that saves the favories in the the documents dir to the new one that saves them in the userdefaults
#define CH_ICLOUD_FAVORITES             @"Favorites" // key used in icloud in the old version to save the favorite theaters
#define CH_ICLOUD_NEW_FAVORITES         @"NewFavorites" // new key to save the favorite theaters in the icloud
#define CH_ICLOUD_FAVORITES_IDS         @"FavoritesIds" // key used to save the favorites in the userdefaults

#define COMPILE_GEOFARO true