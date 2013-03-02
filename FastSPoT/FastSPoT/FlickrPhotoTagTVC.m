//
//  FlickrPhotoTagTVC.m
//  SPoT
//
//  Created by Michael Seganti on 2/28/13.
//  Copyright (c) 2013 Michael Seganti. All rights reserved.
//

#import "FlickrPhotoTagTVC.h"
#import "FlickrFetcher.h"

@interface FlickrPhotoTagTVC ()

// property NSDictionay *photosSortedByTag
// key: NSString, tag
// value: NSIndexSet with the indexes of the photos that match that tag
@property (nonatomic, strong) NSDictionary *photosIndexedByTag;
@property (nonatomic, strong) NSArray *alphaSortedTags; // of NSString, necessary to have the tags sorted only once
@property (nonatomic, strong) NSArray *currentPhotos;   // Pointer to the Photos - used to compare if the photos changed
@end

@implementation FlickrPhotoTagTVC

// creates a NSDictionary that groups photos by tag. For each tag it stores the indexes of all photos that have that tag.
// key: NSString *tag, the corresponding tag to use to group photos
// value: NSIndexSet *indexSet, indexes for the photos that have that tag
- (NSDictionary *)createIndexesByTag
{
    NSMutableDictionary *photosByTag = [[NSMutableDictionary alloc] init]; // of NSMutableIndexSet
    for (NSDictionary *photo in self.photos) {
        // get the tags from the photo
        NSMutableArray *tags = [NSMutableArray arrayWithArray:[photo[FLICKR_TAGS] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        // remove unwanted tags
        [tags removeObjectsInArray:self.tagsToIgnore];
        // obtain index for current photo
        NSUInteger index = [self.photos indexOfObject:photo];
        // for each tag, add index to set of indexes
        for (NSString *tag in tags) {
            if (photosByTag[tag])
                [(NSMutableIndexSet *)photosByTag[tag] addIndex:index]; // add the new index to the NSindexSet
            else
                photosByTag[tag]=[NSMutableIndexSet indexSetWithIndex:index]; // new tag found, create initial index
        }
    }
    return photosByTag;
}

- (NSArray *)alphaSortedTags
{
    // This is bad form, just too lazy to change it.
    // Since we now use a thread to get the photo data
    // the self.photos might be nil during UI initialization
    // We now keep a pointer to the photos in currentPhotos
    // and if currentPhotos object is not the same as the photos
    // object, we recreate the sortedTags and IndexByTag arrays
    // If you don't, the lazy instantiation creates an empty array
    // and will never try to recreate itself because it already exists
    // A better way to do this, would be to create a photosChanged property
    // and set it to true when the photos change, false when the view finished loading???
    
    if (self.currentPhotos != self.photos){
        self.currentPhotos = self.photos;
        _alphaSortedTags = nil;
        _photosIndexedByTag = nil;
    }
    
    if (!_alphaSortedTags) {
        // we get all tags from the dictionary and we return them ordered using NSString caseInsensitiveCompare: method
        _alphaSortedTags = [[self.photosIndexedByTag allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    }
    return _alphaSortedTags;
}

- (NSDictionary *)photosIndexedByTag
{
    if (!_photosIndexedByTag) {
        
        _photosIndexedByTag = [self createIndexesByTag];
    }
    return _photosIndexedByTag;
}

- (NSArray *)photosForTag:(NSString *)tag
{
    NSArray *photosForTag = [self.photos objectsAtIndexes:self.photosIndexedByTag[tag]];
    // before passing the array of photos to the next viewcontroller, we sort the photos by {key1,key2}
    NSSortDescriptor *firstKey = [[NSSortDescriptor alloc] initWithKey:FLICKR_PHOTO_TITLE ascending:YES]; //key1
    NSSortDescriptor *secondKey = [[NSSortDescriptor alloc] initWithKey:FLICKR_PHOTO_DESCRIPTION ascending:YES]; //key2
    return [photosForTag sortedArrayUsingDescriptors:@[firstKey,secondKey]]; //sorted by {key1,key2}
}

- (NSString *)tagForRow:(NSUInteger)row
{
    return self.alphaSortedTags[row];
}

#pragma mark - Segue

// prepares for the "Show List" segue by seeing if the destination view controller of the segue understands the method "setPhotos:"
// if it does, it sends setPhotos: to the destination view controller with the NSArray of the photos for the selected tag

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"Show List"]) {
                if ([segue.destinationViewController respondsToSelector:@selector(setPhotos:)]) {
                    NSString *tag = [self tagForRow:indexPath.row];
                    [segue.destinationViewController performSelector:@selector(setPhotos:) withObject:[self photosForTag:tag]];
                    [segue.destinationViewController setTitle:[self titleForRow:indexPath.row]];
                }
            }
        }
    }
}

#pragma mark - UITableViewDataSource

// lets the UITableView know how many rows it should display
// in this case, just the count of all the keys in the dictionary of photos sorted by tag

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.alphaSortedTags count];
}

//  and gets the title out of it

- (NSString *)titleForRow:(NSUInteger)row
{
    return [[self tagForRow:row] capitalizedString];
}

// a helper method that looks in the Model for the photo dictionary at the given row
//  and gets the owner of the photo out of it

- (NSString *)subtitleForRow:(NSUInteger)row
{
    return [NSString stringWithFormat:@"%d photos",[self.photosIndexedByTag[[self tagForRow:row]] count]];
}

// loads up a table view cell with the title and owner of the photo at the given row in the Model

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Flickr Photo";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [self titleForRow:indexPath.row];
    cell.detailTextLabel.text = [self subtitleForRow:indexPath.row];
    
    return cell;
}

@end
