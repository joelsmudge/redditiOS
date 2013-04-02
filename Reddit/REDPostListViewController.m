//
//  REDPostListViewController.m
//  Reddit
//
//  Created by Joel Harrison on 2/04/13.
//  Copyright (c) 2013 SmudgeApp. All rights reserved.
//

#import "REDPostListViewController.h"
#import "REDPost.h"

@interface REDPostListViewController ()

@end

@implementation REDPostListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.posts = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationItem setTitle:[NSString stringWithFormat:@"r/%@", self.searchQuery]];
    
    [self performSelectorInBackground:@selector(performRequest:) withObject:@"http://www.reddit.com/r/funny.json"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) performRequest: (NSString*) url
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    [request setHTTPMethod: @"GET"];
    
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    
    NSData *response1 = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    
    //NSData *returnedData = [json dataUsingEncoding:NSUTF8StringEncoding];
    
    if(NSClassFromString(@"NSJSONSerialization"))
    {
        NSError *error = nil;
        id object = [NSJSONSerialization
                     JSONObjectWithData:response1
                     options:0
                     error:&error];
        
        if(error) { /* JSON was malformed, act appropriately here */ }
        
        // the originating poster wants to deal with dictionaries;
        // assuming you do too then something like this is the first
        // validation step:
        if([object isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *results = object;
            NSArray* jsonPosts = [[results objectForKey:@"data"] objectForKey:@"children"];
            
            for (id jsonPost in jsonPosts) {
                
                NSLog([NSString stringWithFormat:@"post : %@", [jsonPost description]]);
                NSLog([NSString stringWithFormat:@"data : %@", [jsonPost objectForKey:@"data"]]);
                [self.posts addObject:[REDPost initCreatePostFromJson:jsonPost]];
                
            }
        }
    }

    
    //NSString *output = [[NSString alloc] initWithData:response1 encoding:NSUTF8StringEncoding];
    
    //NSLog(@"output: %@", output);
}


@end
