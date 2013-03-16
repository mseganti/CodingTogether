//
//  FilteredPhotosByTagCDTVC.m
//  SPoTCD
//
//  Created by Michael Seganti on 2/28/13.
//  Copyright (c) 2013 Michael Seganti. All rights reserved.
//

#import "FilteredPhotosByTagCDTVC.h"
#import "FlickrFetcher.h"
#import "Photo+Flickr.h"

@implementation FilteredPhotosByTagCDTVC


// Fires off a block on a queue to fetch data from Flickr.
// When the data comes back, it is loaded into Core Data by posting a block to do so on
//   self.managedObjectContext's proper queue (using performBlock:).
// Data is loaded into Core Data by calling photoWithFlickrInfo:inManagedObjectContext: category method.

- (IBAction)refresh
{
    [self.refreshControl beginRefreshing];
    dispatch_queue_t fetchQ = dispatch_queue_create("Flickr Fetch", NULL);
    dispatch_async(fetchQ, ^{
        NSArray *photos = [FlickrFetcher stanfordPhotos];
        
        // put the photos in Core Data
        [self.managedObjectContext performBlock:^{  // Do this Block in the managedObjectContext's thread
            for (NSDictionary *photo in photos) {
                [Photo photoWithFlickrInfo:photo ignoreTags:self.tagsToIgnore inManagedObjectContext:self.managedObjectContext];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.refreshControl endRefreshing];
            });
        }];
    });
}

@end
