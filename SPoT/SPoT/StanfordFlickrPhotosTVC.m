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
    self.photos = [FlickrFetcher stanfordPhotos];
}

@end
