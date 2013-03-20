//
//  PhotographerCDTVCViewController.h
//  Photomania
//
//  Created by Michael Seganti on 3/8/13.
//  Copyright (c) 2013 Michael Seganti. All rights reserved.
//
// Can do "setPhotographer:" segue and will call method in destination VC.

#import "CoreDataTableViewController.h"

@interface PhotographerCDTVC : CoreDataTableViewController
@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;
@end
