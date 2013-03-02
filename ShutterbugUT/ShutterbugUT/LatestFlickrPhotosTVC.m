//
//  LatestFlickrPhotosTVC.m
//  Shutterbug
//
//  Created by Michael Seganti on 2/27/13.
//  Copyright (c) 2013 Michael Seganti. All rights reserved.
//

#import "LatestFlickrPhotosTVC.h"
#import "FlickrFetcher.h"

@interface LatestFlickrPhotosTVC ()

@end

@implementation LatestFlickrPhotosTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadLatestPhotosFromFlickr];
    [self.refreshControl addTarget:self
                  action:@selector(loadLatestPhotosFromFlickr)
                  forControlEvents:(UIControlEventValueChanged)];
}

- (void)loadLatestPhotosFromFlickr
{
    [self.refreshControl beginRefreshing];
    dispatch_queue_t loaderQ = dispatch_queue_create("flickr latest loader", NULL);
    dispatch_async(loaderQ, ^{
        // The Network indicator is global, be mindful of other threads setting it
        
        // Should probably put the networkActivity in the FlickFetcher code instead of doing this all over the place
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES; // Start the network indicater spinning wheel! -- Baaad
        NSArray *latestPhotos = [FlickrFetcher latestGeoreferencedPhotos];
        // The Network indicator is global, be mindful of other threads setting it
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO; // Start the network indicater spinning wheel! -- Baaad
        dispatch_async(dispatch_get_main_queue(), ^{
            self.photos = latestPhotos;
            [self.refreshControl endRefreshing];
        });
    });
}

@end
