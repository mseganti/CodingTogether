//
//  TaggedPhotosCDTVC.h
//  SPoTCD
//
//  Created by Michael Seganti on 3/15/13.
//  Copyright (c) 2013 Michael Seganti. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "Tags.h"

@interface TaggedPhotosCDTVC : CoreDataTableViewController
@property (strong, nonatomic) Tags *tag;
@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSArray *tagsToIgnore;
@end
