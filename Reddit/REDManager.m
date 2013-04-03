//
//  REDManager.m
//  Reddit
//
//  Created by Joel Harrison on 3/04/13.
//  Copyright (c) 2013 SmudgeApp. All rights reserved.
//

#import "REDManager.h"
#import "Reachability.h"

@implementation REDManager

+(REDManager *) sharedREDManager{
    static REDManager *sharedRedManager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedRedManager = [[REDManager alloc] init];
    });
    
    return sharedRedManager;
}

-(id) init{
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}

-(BOOL)reachable {
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}

-(BOOL) checkReachableWithMessage
{
    if (![self reachable]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message: @"Web View was unable to load. Please check your Internet connection before relaunching the application." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
    
        [alert show];
        return NO;
    } 
    return YES;
    
}

-(BOOL) login:(NSString*)username pass:(NSString*) password
{
    
    
    NSURL *loginurl = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.reddit.com/api/login/%@",username]];
    NSMutableURLRequest *loginrequest = [NSMutableURLRequest requestWithURL:loginurl];
    [loginrequest setHTTPMethod:@"POST"];
    NSData *loginRequestBody = [[NSString stringWithFormat:@"api_type=json&user=%@&passwd=%@",username,password] dataUsingEncoding:NSUTF8StringEncoding];
    [loginrequest setHTTPBody:loginRequestBody];
    NSURLResponse *loginResponse = NULL;
    NSError *loginRequestError = NULL;
    NSData *loginResponseData = [NSURLConnection sendSynchronousRequest:loginrequest returningResponse:&loginResponse error:&loginRequestError];
    NSString *loginResponseString = [[NSString alloc]initWithData:loginResponseData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",loginResponseString);
    
    NSError *error;
    NSData *jsonData = [loginResponseString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *loginResults = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
    NSArray* errors = [[loginResults valueForKey:@"json"] valueForKey:@"errors"];
    NSLog(@"Errors is %d", [errors count]);
    
    if([errors count] == 0){
        // Log in was successful, set username and other credentials
        self.username = username;
        self.modhash = [[[loginResults valueForKey:@"json"] valueForKey:@"data"]valueForKey:@"modhash"];
        self.redditCookie = [[[loginResults valueForKey:@"json"] valueForKey:@"data"]valueForKey:@"cookie"];
    
        NSLog(@"Modhash is %@",self.modhash);
        NSLog(@"Cookie is %@",self.redditCookie);
        return YES;
    } else {

        // For Debugging
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Error" message: @"Incorrect Username or Password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
        
        
        return NO;
    }
    
}





@end
