//
//  PhotographerMapViewController.m
//  PhotomaniaMap
//
//  Created by Michael Seganti on 3/19/13.
//  Copyright (c) 2013 Michael Seganti. All rights reserved.
//

#import "PhotographerMapViewController.h"
#import <CoreData/CoreData.h>
#import "Photographer+MKAnnotation.h"

@interface PhotographerMapViewController ()

@end

@implementation PhotographerMapViewController

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    // Only reload if I'm on screen
    if (self.view.window) [self reload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self reload];          // could wait for viewWillAppear
}

-(void)reload
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photographer"];
    request.predicate = [NSPredicate predicateWithFormat:@"photos.@count > 2"];  // Only Photographers with more than 2 photos
    NSArray *photographers = [self.managedObjectContext executeFetchRequest:request error:NULL];
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:photographers];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"setPhotographer:"]){
        if ([sender isKindOfClass:[MKAnnotationView class]]){
            MKAnnotationView *aView = sender;
            if ([aView.annotation isKindOfClass:[Photographer class]]){
                Photographer *photographer = aView.annotation;
                if ([segue.destinationViewController respondsToSelector:@selector(setPhotographer:)]){
                    [segue.destinationViewController performSelector:@selector(setPhotographer:) withObject:photographer];
                }
            }
        }
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"setPhotographer:" sender:view];  // send which annotation view got tapped
}

@end
