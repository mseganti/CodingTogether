//
//  Photographer+MKAnnotation.h
//  PhotomaniaMap
//
//  Created by Michael Seganti on 3/19/13.
//  Copyright (c) 2013 Michael Seganti. All rights reserved.
//

#import "Photographer.h"
#import <MapKit/MapKit.h>

@interface Photographer (MKAnnotation) <MKAnnotation>
- (UIImage *)thumbnail; // This blocks the main thread!
@end
