//
//  RecentPhotoTVC.m
//  SPoT
//
//  Created by Michael Seganti on 2/28/13.
//  Copyright (c) 2013 Michael Seganti. All rights reserved.
//

#import "RecentPhotosCDTVC.h"
#import "Photo.h"
#import "NetworkIndicatorHelper.h"

@interface RecentPhotosCDTVC ()

@end

@implementation RecentPhotosCDTVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.managedObjectContext) [self useSharedDocument];
    [self.refreshControl addTarget:self
                            action:@selector(refresh)
                  forControlEvents:(UIControlEventValueChanged)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self refresh];
}

- (IBAction)refresh
{
    [self.refreshControl beginRefreshing];
    [self setManagedObjectContext:self.managedObjectContext];   // Force a re-query of the database
    [self.refreshControl endRefreshing];
}


- (void)useSharedDocument
{
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:@"StanfordPhotos Document"];
    UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[url path]]){
        // Create the Database
        
        [document saveToURL:url
           forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
               if (success){
                   self.managedObjectContext = document.managedObjectContext;
                   //[self refresh];  // Loads the DB with the Flickr Data
               }
           }];
    } else if (document.documentState == UIDocumentStateClosed){
        //open it
        [document openWithCompletionHandler:^(BOOL success){
            if (success){
                self.managedObjectContext = document.managedObjectContext;
            }
        }];
    } else {
        // try to use it
        self.managedObjectContext = document.managedObjectContext;
    }
}
- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    if (managedObjectContext) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"lastViewed" ascending:NO selector:@selector(compare:)]];
        request.predicate = nil;
        request.fetchLimit = MAX_RECENT_PHOTOS; // Only bring back the last 8 photos viewed
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

@end
