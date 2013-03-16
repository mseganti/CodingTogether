//
//  PhotosByTagCDTVC.h
//  SPoTCD
//
//  Created by Michael Seganti on 3/13/13.
//  Copyright (c) 2013 Michael Seganti. All rights reserved.
//

#import "FlickrPhotoCDTVC.h"
#import "Tags.h"

@interface FilteredPhotosByTagCDTVC : FlickrPhotoCDTVC
@property (nonatomic, strong) NSArray *tagsToIgnore;
@end
