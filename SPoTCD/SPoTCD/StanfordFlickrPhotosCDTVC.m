//
//  StanfordFlickrPhotosTVC.m
//  SPoT
//
//  Created by Michael Seganti on 2/28/13.
//  Copyright (c) 2013 Michael Seganti. All rights reserved.
//

#import "StanfordFlickrPhotosCDTVC.h"
#import "FlickrFetcher.h"
#import "NetworkIndicatorHelper.h"
#import "Photo+Flickr.h"

@implementation StanfordFlickrPhotosCDTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tagsToIgnore = @[@"cs193pspot", @"portrait", @"landscape"];
    [self.refreshControl addTarget:self
                            action:@selector(refresh)
                  forControlEvents:(UIControlEventValueChanged)];
}


- (IBAction)refresh
{
    [self.refreshControl beginRefreshing];
    dispatch_queue_t loaderQ = dispatch_queue_create("flickr Stanford loader", NULL);
    dispatch_async(loaderQ, ^{
        
        [NetworkIndicatorHelper setNetworkActivityIndicatorVisible:YES];
        NSArray *latestPhotos = [FlickrFetcher stanfordPhotos];
        [NetworkIndicatorHelper setNetworkActivityIndicatorVisible:NO];
        
        // put the photos in Core Data
        [self.managedObjectContext performBlock:^{  // Do this Block in the managedObjectContext's thread
            for (NSDictionary *photo in latestPhotos) {
                [Photo photoWithFlickrInfo:photo ignoreTags:self.tagsToIgnore inManagedObjectContext:self.managedObjectContext];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.refreshControl endRefreshing];
            });
        }];
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.managedObjectContext) [self useSharedDocument];
}

- (void)useSharedDocument
{
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:@"StanfordPhotos Document"];
    UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[url path]]){
        // Create the Database
        
        [document saveToURL:url
           forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
               if (success){
                   self.managedObjectContext = document.managedObjectContext;
                   [self refresh];  // Loads the DB with the Flickr Data
               }
           }];
    } else if (document.documentState == UIDocumentStateClosed){
        //open it
        [document openWithCompletionHandler:^(BOOL success){
            if (success){
                self.managedObjectContext = document.managedObjectContext;
            }
        }];
    } else {
        // try to use it
        self.managedObjectContext = document.managedObjectContext;
    }
}


@end
