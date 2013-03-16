//
//  Photo+Flickr.h
//  Photomania
//
//  Created by Michael Seganti on 3/8/13.
//  Copyright (c) 2013 Michael Seganti. All rights reserved.
//

#import "Photo.h"

@interface Photo (Flickr)
+ (Photo *)photoWithFlickrInfo:(NSDictionary *)photoDictionary ignoreTags:(NSArray *)tagsToIgnore inManagedObjectContext:(NSManagedObjectContext *)context;
@end
