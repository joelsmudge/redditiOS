//
//  REDAppDelegate.m
//  Reddit
//
//  Created by Joel Harrison on 2/04/13.
//  Copyright (c) 2013 SmudgeApp. All rights reserved.
//

#import "REDAppDelegate.h"
#import "REDSearchViewController.h"

@implementation REDAppDelegate
@synthesize searchView;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [REDManager sharedREDManager];

    NSString* username = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    if(username == nil){
        // Never been logged in, not even the default
        // Log in default
        NSLog(@"No one logged in");
        if([[REDManager sharedREDManager] checkReachableWithMessage]){
            [[REDManager sharedREDManager] login:DEFAULT_USERNAME pass:DEFAULT_PASSW];
            [[REDManager sharedREDManager] saveUserCredentials];
        }
    }
    
    if(![username isEqualToString:DEFAULT_USERNAME]){
        NSLog(@"Unique logged in");
        [REDManager sharedREDManager].userIsLoggedIn = YES;
        [[REDManager sharedREDManager] loadUserCredentials];
    } else {
        NSLog(@"Default logged in");
        [REDManager sharedREDManager].userIsLoggedIn = NO;
        [[REDManager sharedREDManager] loadUserCredentials];
    }
    
    self.searchView = [[REDSearchViewController alloc] initWithNibName:@"REDSearchViewController" bundle:nil];
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:self.searchView];
    
    if ([controller.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
        UIImage *image = [UIImage imageNamed:@"rageface.png"];
        [controller.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = controller;
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // Navagation Bar Stuff
    // Override point for customization after application launch.
    UIImage *navBackgroundImage = [UIImage imageNamed:@"navbar_bg"];
    [[UINavigationBar appearance] setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];
    UIImage *backButtonImage = [[UIImage imageNamed:@"button_back"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 6)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];// Change the appearance of other navigation button
    UIImage *barButtonImage = [[UIImage imageNamed:@"button_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 6, 0, 6)];
    [[UIBarButtonItem appearance] setBackgroundImage:barButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    return YES;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
}

@end
