//
//  Tags+Create.m
//  SPoTCD
//
//  Created by Michael Seganti on 3/13/13.
//  Copyright (c) 2013 Michael Seganti. All rights reserved.
//

#import "Tags+Create.h"

@implementation Tags (Create)

+ (Tags *)tagWithString:(NSString *)name uniqueID:(NSString *)unique inManagedObjectContext:(NSManagedObjectContext *)context
{
    Tags *thisTag = nil;
    
    // This is just like Photo(Flickr)'s method.  Look there for commentary.
    
    if (name.length) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tags"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                                  ascending:YES
                                                                   selector:@selector(localizedCaseInsensitiveCompare:)]];
        request.predicate = [NSPredicate predicateWithFormat:@"(name = %@)", name];
        
        NSError *error;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        
        if (!matches || ([matches count] > 1)) {
            // handle error
        } else if (![matches count]) {
            thisTag = [NSEntityDescription insertNewObjectForEntityForName:@"Tags" inManagedObjectContext:context];
            thisTag.name = name;
        } else {
            thisTag = [matches lastObject];
        }
    }
    
    return thisTag;
}

@end
