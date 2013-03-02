//
//  RecentPhotoTVC.m
//  SPoT
//
//  Created by Michael Seganti on 2/28/13.
//  Copyright (c) 2013 Michael Seganti. All rights reserved.
//

#import "RecentPhotoTVC.h"

@interface RecentPhotoTVC ()

@end

@implementation RecentPhotoTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSMutableOrderedSet *recentPhotos = [NSMutableOrderedSet orderedSetWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:RECENTLY_VIEWED_PHOTOS]];
    self.photos = [[recentPhotos reversedOrderedSet] array];
}

@end
