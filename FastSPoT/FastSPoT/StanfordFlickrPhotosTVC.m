//
//  StanfordFlickrPhotosTVC.m
//  SPoT
//
//  Created by Michael Seganti on 2/28/13.
//  Copyright (c) 2013 Michael Seganti. All rights reserved.
//

#import "StanfordFlickrPhotosTVC.h"
#import "FlickrFetcher.h"

@implementation StanfordFlickrPhotosTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tagsToIgnore = @[@"cs193pspot", @"portrait", @"landscape"];
    [self gcdLoadStanfordPhotosFromFlickr];
    [self.refreshControl addTarget:self
                            action:@selector(gcdLoadStanfordPhotosFromFlickr)
                  forControlEvents:(UIControlEventValueChanged)];
}

- (void)loadStanfordPhotosFromFlickr
{
    [self.refreshControl beginRefreshing];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self.photos = [FlickrFetcher stanfordPhotos];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.refreshControl endRefreshing];
}

- (void)gcdLoadStanfordPhotosFromFlickr
{
    [self.refreshControl beginRefreshing];
    dispatch_queue_t loaderQ = dispatch_queue_create("flickr Stanford loader", NULL);
    dispatch_async(loaderQ, ^{
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        NSArray *latestPhotos = [FlickrFetcher stanfordPhotos];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.photos = latestPhotos;
            [self.refreshControl endRefreshing];
        });
    });
}

@end
