//
//  KitchenSinkViewController.m
//  KitchenSink
//
//  Created by Michael Seganti on 3/21/13.
//  Copyright (c) 2013 Michael Seganti. All rights reserved.
//

#import "KitchenSinkViewController.h"
#import "AskerViewController.h"

@interface KitchenSinkViewController () <UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIView *kitchenSink;
@property (weak, nonatomic) NSTimer *drainTimer;    // Make this weak, since the Timer will hold the strong pointer to it
@property (weak, nonatomic) UIActionSheet *sinkControlActionSheet;
@end

@implementation KitchenSinkViewController

#define SINK_CONTROL @"Sink Controls"
#define SINK_CONTROL_STOP_DRAIN @"Stopper Drain"
#define SINK_CONTROL_UNSTOP_DRAIN @"Unstopper Drain"
#define SINK_CONTROL_CANCEL @"Cancel"  // Useful on iPhone only, no Cancel on iPad
#define SINK_CONTROL_EMPTY @"Empty"

- (IBAction)controlSink:(UIBarButtonItem *)sender
{
    if (!self.sinkControlActionSheet){
        NSString *drainButton = self.drainTimer ? SINK_CONTROL_STOP_DRAIN : SINK_CONTROL_UNSTOP_DRAIN;
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:SINK_CONTROL
                                                                 delegate:self
                                                        cancelButtonTitle:SINK_CONTROL_CANCEL
                                                   destructiveButtonTitle:SINK_CONTROL_EMPTY
                                                        otherButtonTitles:drainButton, nil];
        
        [actionSheet showFromBarButtonItem:sender animated:YES];
    }
}

// Delegate for the Action Sheet
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.destructiveButtonIndex){
        [self.kitchenSink.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    } else {
        NSString *choice = [actionSheet buttonTitleAtIndex:buttonIndex];
        if ([choice isEqualToString:SINK_CONTROL_STOP_DRAIN]){
            [self stopDrainTimer];
        } else if ([choice isEqualToString:SINK_CONTROL_UNSTOP_DRAIN]){
            [self startDrainTimer];
        }
    }
}

#define DISH_CLEANING_INTERVAL 2.0

-(void)cleanDish
{
    if (self.kitchenSink.window){
        [self addFood:nil];
        [self performSelector:@selector(cleanDish) withObject:nil afterDelay:DISH_CLEANING_INTERVAL];
    }
}

#define DRAIN_DURATION 3.0  // 3 seconds
#define DRAIN_DELAY 1.0

-(void)startDrainTimer
{
    self.drainTimer = [NSTimer scheduledTimerWithTimeInterval:DRAIN_DURATION/3 target:self selector:@selector(drain:) userInfo:nil repeats:YES];
}

-(void)drain:(NSTimer *)timer
{
    [self drain];
}

-(void)stopDrainTimer
{
    [self.drainTimer invalidate];   // Invalidate the currently running timer
    self.drainTimer = nil;          // Remove our pointer to it
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self startDrainTimer];     // Start the drain timer when view Appears
    [self cleanDish];           // Need to kick off the first cleanDish
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stopDrainTimer];  // Remove the timer when we are about to dissapear
}

-(void)drain
{
     // Use 3 steps to guarantee the animation doesn't skip steps
    for (UIView *view in self.kitchenSink.subviews){
        CGAffineTransform transform = view.transform;
        if (CGAffineTransformIsIdentity(transform)){
            [UIView animateWithDuration:DRAIN_DURATION/3 delay:DRAIN_DELAY options:UIViewAnimationOptionCurveLinear animations:^{
                                 view.transform = CGAffineTransformRotate(CGAffineTransformScale(transform, 0.7, 0.7), 2 * M_PI/3); // Transform the 1st 3rd to 70%
                             } completion:^(BOOL finished){
                                 // When 1st 3rd is completed, start the 2/3 animation
                                 if (finished) [UIView animateWithDuration:DRAIN_DURATION/3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                                     view.transform = CGAffineTransformRotate(CGAffineTransformScale(transform, 0.4, 0.4), -2 * M_PI/3); // Transform the 2/3 to 40%
                                 } completion:^(BOOL finished){
                                     // When 2/3 is completed, start the last animation
                                     if (finished) [UIView animateWithDuration:DRAIN_DURATION/3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                                         view.transform = CGAffineTransformScale(transform, 0.1, 0.1); // Transform the last to 10% - No Rotation here
                                     } completion:^(BOOL finished){
                                         if (finished){
                                             [view removeFromSuperview];
                                         }
                                     }];
                                 }];
                             }];
        }
    }
}

#define MOVE_DURATION 3.0   // 3 seconds

// Tap Gesture 
- (IBAction)tap:(UITapGestureRecognizer *)sender
{
    CGPoint tapLocation = [sender locationInView:self.kitchenSink];
    
    for (UIView *view in self.kitchenSink.subviews){
        if (CGRectContainsPoint(view.frame, tapLocation)){ // If tap is in this frame
            //[self setRandomLocationForView:view];          // set it to a random location
            // Animate the move to the Random Location
            [UIView animateWithDuration:MOVE_DURATION delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                [self setRandomLocationForView:view];
                view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.99, 0.99);   // Catch it before it goes down the Drain, make it ineligible 
            } completion:^(BOOL finished){
                // After we grab it, make it eligible to go down the drain again
                view.transform = CGAffineTransformIdentity;
            }];
        }
    }
}

#define BLUE_FOOD @"Jello"
#define GREEN_FOOD @"Broccoli"
#define ORANGE_FOOD @"Carrot"
#define RED_FOOD @"Beet"
#define PURPLE_FOOD @"Eggplant"
#define BROWN_FOOD @"Potatoe Peels"

-(void)addFood:(NSString *)food
{
    UILabel *foodLabel = [[UILabel alloc] init];    // Calls initWithFrame with 0,0,0,0 frame
    
    
    static NSDictionary *foods = nil;
    if (!foods) foods = @{BLUE_FOOD : [UIColor blueColor],
                          GREEN_FOOD : [UIColor greenColor],
                          ORANGE_FOOD : [UIColor orangeColor],
                          RED_FOOD : [UIColor redColor],
                          PURPLE_FOOD : [UIColor purpleColor],
                          BROWN_FOOD : [UIColor brownColor] };
    
    if (![food length]){
        food = [[foods allKeys] objectAtIndex:arc4random()%[foods count]];
        foodLabel.textColor = [foods objectForKey:food];
    }
    
    foodLabel.text = food;
    foodLabel.font = [UIFont systemFontOfSize:46];
    foodLabel.backgroundColor = [UIColor clearColor];
    [self setRandomLocationForView:foodLabel];
    [self.kitchenSink addSubview:foodLabel];
}

-(void)setRandomLocationForView:(UIView *)view
{
    [view sizeToFit];
    CGRect sinkBounds = CGRectInset(self.kitchenSink.bounds, view.frame.size.width/2, view.frame.size.height/2);
    CGFloat x = arc4random() % (int)sinkBounds.size.width + view.frame.size.width/2;
    CGFloat y = arc4random() % (int)sinkBounds.size.height + view.frame.size.height/2;
    view.center = CGPointMake(x, y);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Ask"]){
        AskerViewController *asker = segue.destinationViewController;
        asker.question = @"What food do you want in the sink?";
    }
}

- (IBAction)cancelAsking:(UIStoryboardSegue *)segue
{
    // Nothing here on Cancel, need it to unwind the segue
}

- (IBAction)doneAsking:(UIStoryboardSegue *)segue
{
    AskerViewController *asker = segue.sourceViewController;
    // Changed for Lecture 17
    // NSLog(@"%@", asker.answer);
    [self addFood:asker.answer];
}


@end
