//
//  Photographer+MKAnnotation.m
//  PhotomaniaMap
//
//  Created by Michael Seganti on 3/19/13.
//  Copyright (c) 2013 Michael Seganti. All rights reserved.
//

#import "Photographer+MKAnnotation.h"

@implementation Photographer (MKAnnotation)

// Implement the MKAnnotation Category

- (NSString *)title
{
    return self.name;
}

- (NSString *)subtitle
{
    return [NSString stringWithFormat:@"%d photos", [self.photos count]];
}

// For location of the photographer, we pick any random photo and
// use it's coordinates

- (CLLocationCoordinate2D)coordinate
{
    return [[self.photos anyObject] coordinate];
}

- (UIImage *)thumbnail
{
    return [[self.photos anyObject] thumbnail];
}

@end
