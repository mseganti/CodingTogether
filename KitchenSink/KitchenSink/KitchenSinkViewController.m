//
//  KitchenSinkViewController.m
//  KitchenSink
//
//  Created by Michael Seganti on 3/21/13.
//  Copyright (c) 2013 Michael Seganti. All rights reserved.
//

#import "KitchenSinkViewController.h"
#import "AskerViewController.h"

@interface KitchenSinkViewController ()

@end

@implementation KitchenSinkViewController

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
    NSLog(@"%@", asker.answer);
}


@end
