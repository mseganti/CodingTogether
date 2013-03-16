//
//  Photographer+Create.h
//  Photomania
//
//  Created by Michael Seganti on 3/8/13.
//  Copyright (c) 2013 Michael Seganti. All rights reserved.
//

#import "Tags.h"

@interface Tags (Create)
+ (Tags *)tagWithString:(NSString *)name uniqueID:(NSString *)unique inManagedObjectContext:(NSManagedObjectContext *)context;
@end
