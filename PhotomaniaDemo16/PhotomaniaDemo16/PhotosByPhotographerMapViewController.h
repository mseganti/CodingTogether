//
//  PhotosByPhotographerMapViewController.h
//  PhotomaniaMap
//
//  Created by Michael Seganti on 3/19/13.
//  Copyright (c) 2013 Michael Seganti. All rights reserved.
//

#import "MapViewController.h"
#import "Photographer.h"

@interface PhotosByPhotographerMapViewController : MapViewController
@property (nonatomic, strong) Photographer *photographer;
@end
