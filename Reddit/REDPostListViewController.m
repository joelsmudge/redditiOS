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
    [self.navigationItem setTitle:[NSString stringWithFormat:@"r/%@", self.searchQuery]];
    if([[REDManager sharedREDManager] checkReachableWithMessage]){
        [self performSelectorInBackground:@selector(performRequest:) withObject:[NSString stringWithFormat:@"http://www.reddit.com/r/%@.json", self.searchQuery]];
    } else {
        //[self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

// Performs GET request
- (void) performRequest: (NSString*) url
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    [request setHTTPMethod: @"GET"];
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    NSData *response1 = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];

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
    
    // Set text for the cell labels
    [cell.TitleLabel setText:post.title];
    [cell.SubTitleLabel setText:[NSString stringWithFormat:@"by %@ - %@", post.author, post.domain]];
    [cell.SubSubTitleLabel setText:[NSString stringWithFormat:@"%@ {%@,%@} - %@ comments", post.score, post.ups, post.downs, post.numComments]];
    
    return cell;
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

-(void)webView:(UIWebView *)technobuffalo didFailLoadWithError:(NSError *)error {
    


}

@end
