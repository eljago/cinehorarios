//
//  GFKDao.h
//  GeoDemo
//
//  Created by Daniel on 10/20/14.
//  Copyright (c) 2014 Geofaro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface GFKDao : NSObject



@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (GFKDao *)sharedDao;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;



@end
