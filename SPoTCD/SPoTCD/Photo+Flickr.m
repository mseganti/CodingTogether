//
//  Photo+Flickr.m
//  Photomania
//
//  Created by Michael Seganti on 3/8/13.
//  Copyright (c) 2013 Michael Seganti. All rights reserved.
//

#import "Photo+Flickr.h"
#import "FlickrFetcher.h"
#import "Tags+Create.h"

@implementation Photo (Flickr)
+ (Photo *)photoWithFlickrInfo:(NSDictionary *)photoDictionary ignoreTags:(NSArray *)tagsToIgnore inManagedObjectContext:(NSManagedObjectContext *)context
{
    Photo *photo = nil;
    
    // See if photo is already in the database
    
    // Set up the Fetch Request (Query)
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"unique = %@", [photoDictionary[FLICKR_PHOTO_ID] description]];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];  // Do the Fetch Request
    
    if (!matches || ([matches count] > 1)){
        // Handle Error
        // if count > 0 shouldn't be dups in database
        // if matches is nil, check error variable for actual error
        
    } else if (![matches count]){   // No Photos Found in Query, create the object
        photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
        
        photo.unique = [photoDictionary[FLICKR_PHOTO_ID] description];
        photo.title = [photoDictionary[FLICKR_PHOTO_TITLE] description];
        photo.subtitle = [photoDictionary valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
        photo.imageURL = [[FlickrFetcher urlForPhoto:photoDictionary format:FlickrPhotoFormatLarge] absoluteString];
        photo.thumbNailURL = [[FlickrFetcher urlForPhoto:photoDictionary format:FlickrPhotoFormatSquare] absoluteString];
        photo.thumbNail = [[NSData alloc] initWithContentsOfURL:[FlickrFetcher urlForPhoto:photoDictionary format:FlickrPhotoFormatSquare]];
        
        NSMutableArray *photoTags = [NSMutableArray arrayWithArray:[photoDictionary[FLICKR_TAGS] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        [photoTags removeObjectsInArray:tagsToIgnore]; // Remove any Ignored tags from the Array

        NSMutableSet *tagSet = [[NSMutableSet alloc] init];
        
        // This set's up the entity Relationship Add Tags to the tags NSSet
        for (NSString *currentTag in photoTags){
            Tags *newTag = [Tags tagWithString:currentTag uniqueID:photo.unique inManagedObjectContext:context];
            [tagSet addObject:newTag];
        }
        
        photo.tags = tagSet;
    }
    else{
        photo = [matches lastObject];
    }
    
    return photo;
}

@end
