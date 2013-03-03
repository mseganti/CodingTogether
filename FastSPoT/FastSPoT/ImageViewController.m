//
//  ImageViewController.m
//  Shutterbug
//
//  Created by Michael Seganti on 2/27/13.
//  Copyright (c) 2013 Michael Seganti. All rights reserved.
//

#import "ImageViewController.h"
#import "AttributedStringViewController.h"
#import "CacheNSData.h"

@interface ImageViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *titleBarButtonItem;
@property (strong, nonatomic) UIPopoverController *urlPopover;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@end

@implementation ImageViewController

// We know a nil imageURL (no photo selected before pressing popover button) will crash the app
// this gets called to see if we will allow the segue.  In here, check to see if the
// imageURL is nil and return YES if we have a URL, NO if we don't

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"Show URL"]){
        return (self.imageURL && !self.urlPopover.popoverVisible) ? YES : NO;
    } else {
        return [super shouldPerformSegueWithIdentifier:identifier sender:sender];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show URL"]){
        if ([segue.destinationViewController isKindOfClass:[AttributedStringViewController class]]){
            AttributedStringViewController *asc = (AttributedStringViewController *)segue.destinationViewController;
            
            // This will crash the application if the imageURL is nil (no Photo selected)
            // need to check if we can call it using the shouldPerformSegueWithIdentifier method
            asc.text = [[NSAttributedString alloc] initWithString:[self.imageURL description]];
            
            // Grab the popover controller and hold onto it.  This is to prevent
            // the user from pressing the popover button and a new popover being generated
            // each time.
            if ([segue isKindOfClass:[UIStoryboardPopoverSegue class]]){
                self.urlPopover = ((UIStoryboardPopoverSegue *)segue).popoverController;
            }
        }
    }
    
}

- (void)setTitle:(NSString *)title
{
    super.title = title;
    self.titleBarButtonItem.title = title;
}

- (void)setImageURL:(NSURL *)imageURL
{
    _imageURL = imageURL;
    [self resetImage];
}

- (void)resetImage
{
    if (self.scrollView){
        self.scrollView.contentSize = CGSizeZero;
        self.imageView.image = nil;
        
        [self.spinner startAnimating];  // Start the Spinner
        // Put this in a GCD Dispatch Queue
        
        NSURL *imageURL = self.imageURL;    // Create this so we know what the current URL is for use later
        // Not writing to this variable, so we don't need __block
        
        dispatch_queue_t imageFetchQ  = dispatch_queue_create("image fetcher", NULL); // Create the Queue
        
        // dispatch the code onto the queue
        dispatch_async(imageFetchQ, ^{
            // Check to see if the file is in the cache
            NSString *fileName = [[self.imageURL pathComponents] lastObject];                       // get the filename
            NSData *imageData = [[CacheNSData sharedInstance] dataInCacheForIdentifier:fileName];   // Query the Cache
            
            if (!imageData){    // Not found in the cache, go get it off the Net... 

                [UIApplication sharedApplication].networkActivityIndicatorVisible = YES; // Start the network indicater spinning wheel! -- Baaad
                imageData = [[NSData alloc] initWithContentsOfURL:self.imageURL];
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO; // Stop the network indicater spinning wheel! -- Baaad
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{        // Save this to cache in the background
                    [[CacheNSData sharedInstance] cacheData:imageData withIdentifier:fileName];
                });
            }
            
            UIImage *image = [[UIImage alloc] initWithData:imageData];
            
            if (self.imageURL == imageURL){ // Has imageURL changed while we were on the Queue?
                
                // Need to dispatch UI back to the main thread
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (image){
                        self.scrollView.zoomScale = 1.0; // Make sure to reset this, especially after Pinch/Zoom
                        self.scrollView.contentSize = image.size; // Set to Size of the image
                        self.imageView.image = image;   // set the image
                        self.imageView.frame = CGRectMake(0,0, image.size.width, image.size.height);
                    }
                    [self.spinner stopAnimating];
                }); // main Q dispatch
                
            } // if self.imageURL
            
        }); // imageFetchQ
    }
}

- (UIImageView *)imageView
{
    if (!_imageView) _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    return _imageView;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView addSubview:self.imageView];
    self.scrollView.minimumZoomScale = 0.2;
    self.scrollView.maximumZoomScale = 5.0;
    self.scrollView.delegate = self;
    [self resetImage];
    self.titleBarButtonItem.title = self.title;
}

@end
