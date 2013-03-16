//
//  RecentPhotoTVC.h
//  SPoT
//
//  Created by Michael Seganti on 2/28/13.
//  Copyright (c) 2013 Michael Seganti. All rights reserved.
//

#import "FilteredPhotosByTagCDTVC.h"

#define MAX_RECENT_PHOTOS 8

@interface RecentPhotosCDTVC : CoreDataTableViewController
@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;
@end
