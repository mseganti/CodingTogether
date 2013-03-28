//
//  AskerViewController.h
//  KitchenSink
//
//  Created by Michael Seganti on 3/21/13.
//  Copyright (c) 2013 Michael Seganti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AskerViewController : UIViewController
@property (nonatomic, strong) NSString *question;
@property (nonatomic, readonly) NSString *answer;
@end
