//
//  REDLoginViewController.h
//  Reddit
//
//  Created by Joel Harrison on 5/04/13.
//  Copyright (c) 2013 SmudgeApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface REDLoginViewController : UIViewController
- (IBAction)loginButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwField;


@property (weak, nonatomic) IBOutlet UIView *loggingInView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loggingInSpinner;
@property (weak, nonatomic) IBOutlet UILabel *LoggingInMessage;

@end
