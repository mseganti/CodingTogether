//
//  FlickrPhotoTVC.m
//  Shutterbug
//
//  Created by Michael Seganti on 2/27/13.
//  Copyright (c) 2013 Michael Seganti. All rights reserved.
//
// Borrowed Heavily from Juan C. Catalan - he did a nice job on this class...

#import "FlickrPhotoTVC.h"
#import "FlickrFetcher.h"

@interface FlickrPhotoTVC ()

@end

@implementation FlickrPhotoTVC

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    [self.tableView reloadData];
}

+ (void)addRecentPhoto:(NSDictionary *)photo
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableOrderedSet *recentPhotos = [NSMutableOrderedSet orderedSetWithArray:[defaults objectForKey:RECENTLY_VIEWED_PHOTOS]];
    
    if (!recentPhotos) {
        recentPhotos = [NSMutableOrderedSet orderedSet];
    }
    
    if ([recentPhotos containsObject:photo])
    {
        int index = [recentPhotos indexOfObject:photo];
        NSIndexSet *indexset = [NSIndexSet indexSetWithIndex:index];
        [recentPhotos moveObjectsAtIndexes:indexset toIndex:[recentPhotos indexOfObject:[recentPhotos lastObject]]];
    }
    else {
        if ([recentPhotos count]>=RECENTLY_VIEWED_PHOTOS_LIST_LIMIT) [recentPhotos removeObjectAtIndex:0];
        [recentPhotos addObject:photo];
    }
    
    [defaults setObject:[recentPhotos array] forKey:RECENTLY_VIEWED_PHOTOS];
    
    [defaults synchronize];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]){
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath){
            if ([segue.identifier isEqualToString:@"Show Image"]) {
                if ([segue.destinationViewController respondsToSelector:@selector(setImageURL:)]){
                    NSURL *url = [FlickrFetcher urlForPhoto:self.photos[indexPath.row] format:FlickrPhotoFormatLarge];
                    [segue.destinationViewController performSelector:@selector(setImageURL:) withObject:url];
                    [segue.destinationViewController setTitle:[self titleForRow:indexPath.row]];
                    
                    // Should check to see if this is the RecentPhotoTVC class
                    // But since the addRecentPhoto checks to see if it already
                    // has this photo, it doesn't really matter. 

                    [[self class] addRecentPhoto:self.photos[indexPath.row]]; // Add this to the Recent Photos
                }
            }
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.photos count];
}

- (NSString *)titleForRow:(NSUInteger)row
{
    return [self.photos[row][FLICKR_PHOTO_TITLE] description];
}

- (NSString *)subtitleForRow:(NSUInteger)row
{
    return [self.photos[row][FLICKR_PHOTO_OWNER] description];

}

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
