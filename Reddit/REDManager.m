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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Lost" message: @"Please check your Internet connection before relaunching the application." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
    
        [alert show];
        return NO;
    } 
    return YES;
    
}

-(BOOL) login:(NSString*)user pass:(NSString*) passw
{
    
    [self eraseCredentials];
    //NSURL *loginurl = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.reddit.com/api/login/%@",user]];
    NSURL *loginurl = [NSURL URLWithString:[NSString stringWithFormat:@"https://ssl.reddit.com/api/login/myusername"]];
    NSMutableURLRequest *loginrequest = [NSMutableURLRequest requestWithURL:loginurl];
    [loginrequest setHTTPMethod:@"POST"];
    
    [loginrequest setHTTPShouldHandleCookies:NO]; // Remove
    
    NSData *loginRequestBody = [[NSString stringWithFormat:@"api_type=json&user=%@&passwd=%@&rem=True",user,passw] dataUsingEncoding:NSUTF8StringEncoding];
    [loginrequest setHTTPBody:loginRequestBody];
    
    
    // Remove
    //NSLog(@"login request is %@",[loginrequest description]);
    //NSLog([NSHTTPCookieStorage cookies:@"reddit.com"]);
    
    // End remove
    
    NSURLResponse *loginResponse = NULL;
    NSError *loginRequestError = NULL;
    NSData *loginResponseData = [NSURLConnection sendSynchronousRequest:loginrequest returningResponse:&loginResponse error:&loginRequestError];
    NSString *loginResponseString = [[NSString alloc]initWithData:loginResponseData encoding:NSUTF8StringEncoding];
    NSLog(@"REsponse is %@",loginResponseString);
    
    NSError *error;
    NSData *jsonData = [loginResponseString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *loginResults = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
    NSArray* errors = [[loginResults valueForKey:@"json"] valueForKey:@"errors"];
    
    NSString* modhash = [[[loginResults valueForKey:@"json"] valueForKey:@"data"]valueForKey:@"modhash"];
    NSString* cookie = [[[loginResults valueForKey:@"json"] valueForKey:@"data"]valueForKey:@"cookie"];
    
    NSLog(@"Modhash is %@",modhash);
    NSLog(@"Cookie is %@",cookie);
    NSLog(@"ERRORs is %@", errors);
    
    
    if([errors count] == 0 && modhash != nil && cookie != nil){
        // Log in was successful, set username and other credentials
        self.username = user;
        self.modhash = [[[loginResults valueForKey:@"json"] valueForKey:@"data"]valueForKey:@"modhash"];
        self.redditCookie = [[[loginResults valueForKey:@"json"] valueForKey:@"data"]valueForKey:@"cookie"];
    
        NSLog(@"Modhash is %@",self.modhash);
        NSLog(@"Cookie is %@",self.redditCookie);
        
        return YES;
    } else {
        return NO;
    }
    
}

- (void) eraseCredentials{
    NSURLCredentialStorage *credentialsStorage = [NSURLCredentialStorage sharedCredentialStorage];
    NSDictionary *allCredentials = [credentialsStorage allCredentials];
    
    //iterate through all credentials to find the twitter host
    for (NSURLProtectionSpace *protectionSpace in allCredentials)
        if ([[protectionSpace host] isEqualToString:@"www.reddit.com"]){
            //to get the twitter's credentials
            NSDictionary *credentials = [credentialsStorage credentialsForProtectionSpace:protectionSpace];
            //iterate through twitter's credentials, and erase them all
            for (NSString *credentialKey in credentials)
                [credentialsStorage removeCredential:[credentials objectForKey:credentialKey] forProtectionSpace:protectionSpace];
        }
}

-(BOOL) vote: (NSString*) postName direction:(int) dir
{
    
    NSURL *voteurl = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.reddit.com/api/vote"]];
    NSMutableURLRequest *loginrequest = [NSMutableURLRequest requestWithURL:voteurl];
    [loginrequest setHTTPMethod:@"POST"];
    NSData *loginRequestBody = [[NSString stringWithFormat:@"api_type=json&dir=%d&id=%@&uh=%@", dir, postName, self.modhash] dataUsingEncoding:NSUTF8StringEncoding];
    [loginrequest addValue:[REDManager sharedREDManager].redditCookie forHTTPHeaderField:@"reddit_session"];
    [loginrequest setHTTPBody:loginRequestBody];
    NSURLResponse *loginResponse = NULL;
    NSError *loginRequestError = NULL;
    NSData *loginResponseData = [NSURLConnection sendSynchronousRequest:loginrequest returningResponse:&loginResponse error:&loginRequestError];
    NSString *loginResponseString = [[NSString alloc]initWithData:loginResponseData encoding:NSUTF8StringEncoding];
    NSLog(@"REsponse is %@",loginResponseString);
    
}

-(void) saveUserCredentials
{
    [[NSUserDefaults standardUserDefaults] setObject:self.username forKey:@"User"];
    [[NSUserDefaults standardUserDefaults] setObject:self.modhash forKey:@"Modhash"];
    [[NSUserDefaults standardUserDefaults] setObject:self.redditCookie forKey:@"Cookie"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void) loadUserCredentials
{
    self.username = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    self.modhash = [[NSUserDefaults standardUserDefaults] objectForKey:@"Modhash"];
    self.redditCookie = [[NSUserDefaults standardUserDefaults] objectForKey:@"Cookie"];
}



@end
