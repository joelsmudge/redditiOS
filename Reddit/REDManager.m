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
    NSURL *loginurl = [NSURL URLWithString:[NSString stringWithFormat:@"https://ssl.reddit.com/api/login/myusername"]];
    NSMutableURLRequest *loginrequest = [NSMutableURLRequest requestWithURL:loginurl];
    [loginrequest setHTTPMethod:@"POST"];
    
    [loginrequest setHTTPShouldHandleCookies:NO]; // Remove
    
    NSData *loginRequestBody = [[NSString stringWithFormat:@"api_type=json&rem=True&user=%@&passwd=%@",user,passw] dataUsingEncoding:NSUTF8StringEncoding];
    [loginrequest setHTTPBody:loginRequestBody];
    
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

-(BOOL) vote: (NSString*) postName direction:(int) dir
{
    NSURL *voteurl = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.reddit.com/api/vote"]];
    NSMutableURLRequest *loginrequest = [NSMutableURLRequest requestWithURL:voteurl];

    //[loginrequest setHTTPShouldHandleCookies:NO]; // Remove
    [loginrequest setHTTPMethod:@"POST"];
    NSData *loginRequestBody = [[NSString stringWithFormat:@"api_type=json&dir=%d&id=%@&uh=%@", dir, postName, self.modhash] dataUsingEncoding:NSUTF8StringEncoding];
    [loginrequest addValue:[REDManager sharedREDManager].redditCookie forHTTPHeaderField:@"reddit_session"];
    
    
    NSDictionary *cookieProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                      @"reddit.com", NSHTTPCookieDomain,
                                      @"\\", NSHTTPCookiePath,
                                      @"reddit_session", NSHTTPCookieName,
                                      [REDManager sharedREDManager].redditCookie, NSHTTPCookieValue,
                                      nil];
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    NSArray* cookieArray = [NSArray arrayWithObjects: cookie, nil];
    NSDictionary * headers = [NSHTTPCookie requestHeaderFieldsWithCookies:cookieArray];
    [loginrequest setAllHTTPHeaderFields:headers];

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
