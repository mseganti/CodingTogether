//
//  FlickrPhotoTVC.h
//  Shutterbug
//
//  Created by Michael Seganti on 2/27/13.
//  Copyright (c) 2013 Michael Seganti. All rights reserved.
//


#import "CoreDataTableViewController.h"

@interface FlickrPhotoCDTVC : CoreDataTableViewController
@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;
@end
