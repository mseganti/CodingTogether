//
//  FlickrPhotoTVC.m
//  Shutterbug
//
//  Created by Michael Seganti on 2/27/13.
//  Copyright (c) 2013 Michael Seganti. All rights reserved.
//
// Borrowed Heavily from Juan C. Catalan - he did a nice job on this class...

#import "FlickrPhotoCDTVC.h"
#import "FlickrFetcher.h"
#import "Tags.h"

@interface FlickrPhotoCDTVC () <UISplitViewControllerDelegate>

@end

@implementation FlickrPhotoCDTVC


#pragma mark - UISplitViewControllerDelegate

- (void)awakeFromNib
{
    self.splitViewController.delegate = self;
}

- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = nil;
    
    if ([sender isKindOfClass:[UITableViewCell class]]){
        indexPath = [self.tableView indexPathForCell:sender];
    }
    
    if (indexPath){
        if ([segue.identifier isEqualToString:@"setTag:"]) {
            Tags *tag = [self.fetchedResultsController objectAtIndexPath:indexPath];
            if ([segue.destinationViewController respondsToSelector:@selector(setTag:)]){
                [segue.destinationViewController performSelector:@selector(setTag:) withObject:tag];
            }
            
            // Really need a Singleton for the managedObjectContext or a Database Helper Class
            // Pass the managedObjectContext to the Segue Class Instance
            if ([segue.destinationViewController respondsToSelector:@selector(setManagedObjectContext:)]){
                [segue.destinationViewController performSelector:@selector(setManagedObjectContext:) withObject:self.managedObjectContext];
            }
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Tags";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    Tags *tags = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [tags.name capitalizedString];;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d photos", [tags.photos count]];
    // Try this later - saw somewhere else... cell.detailTextLabel.text = [NSString stringWithFormat:@"%d Photo%@", numberOfPhotosWithTag, numberOfPhotosWithTag == 1 ? @"" : @"s"];
    
    return cell;
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    
    if (managedObjectContext)  {
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tags"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
        request.predicate = nil; // all Tags
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];

        
        /*  Group By expression for the Database - doesn't work well with fetchedResultsController returning NSDictionaryResultType
         
         Let’s suppose you have a bunch of Records, and each Record has a Status attribute among others,
         and you want a break down of how many have each Status. The SQL would be:
         
         SELECT Status, COUNT(*) FROM Records GROUP BY Status: 
        
        // start with a fetch request:
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tags"];
        
        //set up an attribute description and expression description for the two values we want in the results:
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tags" inManagedObjectContext:managedObjectContext];
        NSAttributeDescription *tagDesc = [entity.attributesByName objectForKey:@"name"];
        NSExpression *keyPathExpression = [NSExpression expressionForKeyPath: @"name"]; // Does not really matter
        NSExpression *countExpression = [NSExpression expressionForFunction: @"count:" arguments: [NSArray arrayWithObject:keyPathExpression]];
        NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
        [expressionDescription setName: @"count"];
        [expressionDescription setExpression: countExpression];
        [expressionDescription setExpressionResultType: NSInteger32AttributeType];
        
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];

        //tell the fetch request to only fetch these, and group by the tag attribute description
        
        [request setPropertiesToFetch:[NSArray arrayWithObjects:tagDesc, expressionDescription, nil]];
        [request setPropertiesToGroupBy:[NSArray arrayWithObject:tagDesc]];
        [request setResultType:NSDictionaryResultType];
        //[request setResultType:NSManagedObjectResultType];  // Can't do with a Grouped Expression
        
        NSError *error = nil;
        NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
        
        // The result is an array of dictionaries, each with “name” and “count” keys and corresponding values.
        // Even though the group by guarantees the grouped values be unique, there could be more than one grouped column, so it does make sense.
        
        //self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
         
         */
        
    } else {
        self.fetchedResultsController = nil;
    }
}

@end
