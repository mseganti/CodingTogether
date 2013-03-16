//
//  TaggedPhotosCDTVC.m
//  SPoTCD
//
//  Created by Michael Seganti on 3/15/13.
//  Copyright (c) 2013 Michael Seganti. All rights reserved.
//

#import "TaggedPhotosCDTVC.h"
#import "Tags.h"
#import "NetworkIndicatorHelper.h"
#import "FlickrFetcher.h"
#import "Photo+Flickr.h"

@interface TaggedPhotosCDTVC ()

@end

@implementation TaggedPhotosCDTVC

- (void)setTag:(Tags *)tag
{
    _tag = tag;
    self.title = [_tag.name capitalizedString];
    //self.sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES                                                 selector:@selector(localizedCaseInsensitiveCompare:)];
    //self.predicate = [NSPredicate predicateWithFormat:@"any tags.name = %@", tag.name];
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    if (managedObjectContext) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
        request.predicate = [NSPredicate predicateWithFormat:@"any tags.name = %@", self.tag.name];
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    } else {
        self.fetchedResultsController = nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Photos"];
    
    Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = photo.title;
    cell.detailTextLabel.text = photo.subtitle;
    cell.imageView.image = [UIImage imageWithData:photo.thumbNail];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = nil;
    
    NSLog(@"In prepare for segue");
    
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        indexPath = [self.tableView indexPathForCell:sender];
    }
    
    if (indexPath) {
        if ([segue.identifier isEqualToString:@"Show Image"]) {
            if ([segue.destinationViewController respondsToSelector:@selector(setImageURL:)]) {
                Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
                photo.lastViewed = [NSDate date];
                NSURL *url = [NSURL URLWithString:photo.imageURL];
                [segue.destinationViewController performSelector:@selector(setImageURL:) withObject:url];
                [segue.destinationViewController setTitle:photo.title];
            }
        }
    }
}

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

@end
