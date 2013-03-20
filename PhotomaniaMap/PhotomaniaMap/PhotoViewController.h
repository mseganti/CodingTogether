//
//  PhotoViewController.h
//  PhotomaniaMap
//
//  Created by Michael Seganti on 3/19/13.
//  Copyright (c) 2013 Michael Seganti. All rights reserved.
//

#import "ImageViewController.h"
#import "Photo.h"

@interface PhotoViewController : ImageViewController
@property (nonatomic, strong) Photo *photo;
@end
