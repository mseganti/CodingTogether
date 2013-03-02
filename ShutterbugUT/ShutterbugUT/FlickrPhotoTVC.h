//
//  FlickrPhotoTVC.h
//  Shutterbug
//
//  Created by Michael Seganti on 2/27/13.
//  Copyright (c) 2013 Michael Seganti. All rights reserved.
//

// Will call setImageUrl: as part of any "Show Image" segue.
// "Show Image" Is the identifier name for the segue in the property inspector of the segue.
// You find it by clicking on the segue than click the propery inspector icon

#import <UIKit/UIKit.h>

@interface FlickrPhotoTVC : UITableViewController
@property (nonatomic, strong) NSArray *photos; // of NSDictionary
@end
