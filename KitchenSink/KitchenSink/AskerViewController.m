//
//  AskerViewController.m
//  KitchenSink
//
//  Created by Michael Seganti on 3/21/13.
//  Copyright (c) 2013 Michael Seganti. All rights reserved.
//

#import "AskerViewController.h"

@interface AskerViewController ()
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UITextField *answerTextField;

@end

@implementation AskerViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.questionLabel.text = self.question;
    self.answerTextField.text = nil;
    [self.answerTextField becomeFirstResponder]; // make it the first responder for the keyboard
}

- (NSString *)answer
{
    return self.answerTextField.text;
}

@end
