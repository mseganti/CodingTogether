//
//  Photo.h
//  SPoTCD
//
//  Created by Michael Seganti on 3/14/13.
//  Copyright (c) 2013 Michael Seganti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tags;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSDate * lastViewed;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSData * thumbNail;
@property (nonatomic, retain) NSString * thumbNailURL;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * unique;
@property (nonatomic, retain) NSSet *tags;
@end

@interface Photo (CoreDataGeneratedAccessors)

- (void)addTagsObject:(Tags *)value;
- (void)removeTagsObject:(Tags *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

@end
