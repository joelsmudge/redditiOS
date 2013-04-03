//
//  REDPostListViewController.m
//  Reddit
//
//  Created by Joel Harrison on 2/04/13.
//  Copyright (c) 2013 SmudgeApp. All rights reserved.
//

#import "REDPostListViewController.h"
#import "REDPost.h"
#import "REDPostListCell.h"
#import "REDPostViewController.h"

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
    _SearchResultsTable.delegate = self;
    _SearchResultsTable.dataSource = self;
    [self.loadingBar setBackgroundColor:[UIColor grayColor]];
    [self.loadingSpinner startAnimating];
    [self.navigationItem setTitle:[NSString stringWithFormat:@"r/%@", self.searchQuery]];
    if([[REDManager sharedREDManager] checkReachableWithMessage]){
        [self performSelectorInBackground:@selector(loadMorePosts:) withObject:self.searchQuery];
    } else {
        //[self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

// Performs GET request
- (void) loadMorePosts: (NSString*) subReddit
{
    
    REDPost* lastPost =  [_posts lastObject];
    NSString* url = [NSString stringWithFormat:@"http://www.reddit.com/r/%@.json?after=%@", subReddit, lastPost.name];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    [request setHTTPMethod: @"GET"];
    [request addValue:[REDManager sharedREDManager].redditCookie forHTTPHeaderField:@"reddit_session"];
    NSError *requestError;
    NSHTTPURLResponse *urlResponse = nil;
    NSData *response1 = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
//    [urlResponse statusCode];
    
    NSLog([[NSString alloc] initWithData:response1 encoding:NSUTF8StringEncoding]);

    if(NSClassFromString(@"NSJSONSerialization"))
    {
        NSError *error = nil;
        id object = [NSJSONSerialization
                     JSONObjectWithData:response1
                     options:0
                     error:&error];
        
        if(error) {}
        
        if([object isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *results = object;
            NSArray* jsonPosts = [[results objectForKey:@"data"] objectForKey:@"children"];
            
            for (id jsonPost in jsonPosts) {

                [self.posts addObject:[REDPost initCreatePostFromJson:jsonPost]];
            }
        }
    }
    [self performSelectorOnMainThread:@selector(reloadSearchResults) withObject:nil waitUntilDone:NO];
}


- (void) reloadSearchResults
{
    [self.SearchResultsTable reloadData];
    [self.loadingSpinner stopAnimating];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PostCell";
    static NSString *CellNib = @"REDPostListCell";
    REDPostListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellNib owner:self options:nil];
    	cell = (REDPostListCell*)[nib objectAtIndex:0];
    }
    REDPost* post = [self.posts objectAtIndex:indexPath.item];
    
    [cell setPost:post];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    // If index gets close to posts length then load more posts asyncronosly
    if([indexPath item] + 5 > self.currentlyLoadingToPostIndex){
        // Load more posts
        if([[REDManager sharedREDManager] checkReachableWithMessage]){
            [self.loadingSpinner startAnimating];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            [self performSelectorInBackground:@selector(loadMorePosts:) withObject:self.searchQuery];
        } else {
            //[self.navigationController popViewControllerAnimated:YES];
        }
        self.currentlyLoadingToPostIndex += 25;
    }
    
    
}


- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.posts count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    
    //allocate your view controller
    REDPostViewController *postView = [[REDPostViewController alloc] init];
    
    REDPost* post = [self.posts objectAtIndex:indexPath.item];
    
    //send properties to your view controller
    postView.post = post;
    
    //push it to the navigationController
    [[self navigationController] pushViewController:postView animated:YES];
}

- (void) viewWillAppear:(BOOL)animated
{
    // Deselecting Row
    [self.SearchResultsTable deselectRowAtIndexPath:[self.SearchResultsTable indexPathForSelectedRow] animated:YES];
}

-(void)webView:(UIWebView *)technobuffalo didFailLoadWithError:(NSError *)error {
    


}

@end
