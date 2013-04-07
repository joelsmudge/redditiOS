//
//  REDLoginViewController.m
//  Reddit
//
//  Created by Joel Harrison on 5/04/13.
//  Copyright (c) 2013 SmudgeApp. All rights reserved.
//

#import "REDLoginViewController.h"

@interface REDLoginViewController ()

@end

@implementation REDLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.loggingInView.hidden = YES;
    [self.userNameField becomeFirstResponder];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonPressed:(id)sender {
    [self.view endEditing:YES];
    self.loggingInView.hidden = NO;
    [self.loggingInSpinner startAnimating];
    self.loggingInSpinner.hidden = NO;
    self.LoggingInMessage.text = @"";
    if([[REDManager sharedREDManager] checkReachableWithMessage]){
        // There is a connection
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        self.LoggingInMessage.text = @"Logging in...";
        [self performSelectorInBackground:@selector(performLoginRequest) withObject:nil];
    } else {
        // No Connection
        self.loggingInView.hidden = YES;
    }
    
}

- (void) performLoginRequest
{
    
    BOOL success = [[REDManager sharedREDManager] login:self.userNameField.text pass:self.passwField.text];
    //BOOL success = NO;
    NSString* successMessage = @"NO";
    if (success) {
        successMessage = @"YES";
    }
    [self performSelectorOnMainThread:@selector(loginCompleted:) withObject:successMessage waitUntilDone:NO];
}

- (void) loginCompleted: (NSString*) successful
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    if([successful isEqualToString:@"YES"]){
        // Login Successful
        [self.loggingInSpinner stopAnimating];
        self.loggingInSpinner.hidden = YES;
        self.LoggingInMessage.text = @"Logged In";
        [[REDManager sharedREDManager] saveUserCredentials];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        // Incorrect Login Details
        [self.loggingInSpinner stopAnimating];
        self.loggingInSpinner.hidden = YES;
        self.LoggingInMessage.text = @"Incorrent Username or Password";
    }
}



@end
