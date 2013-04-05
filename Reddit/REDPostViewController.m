//
//  REDPostViewController.m
//  Reddit
//
//  Created by Joel Harrison on 2/04/13.
//  Copyright (c) 2013 SmudgeApp. All rights reserved.
//

#import "REDPostViewController.h"

@interface REDPostViewController ()

@end

@implementation REDPostViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.webViewer.delegate = self;
        upvoted = NO;
        downvoted = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _webViewer.delegate = self;
    [self.loadingSplashView setBackgroundColor:[UIColor grayColor]];
    
    if([[REDManager sharedREDManager] checkReachableWithMessage]){
        [self.webViewer loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.post.url]]];
    } else {
        // Connection Error
    }
    
    loadingIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(145, 190, 20,20)];
    [loadingIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [loadingIndicator setHidesWhenStopped:YES];
    [self.webViewer addSubview:loadingIndicator];
    
    [self.titleLabel setText:self.post.title];
    [self.subTitleLabel setText:[NSString stringWithFormat:@"by %@ - %@", self.post.author, self.post.domain]];
    [self.subSubTitleLabel setText:[NSString stringWithFormat:@"%@ {%@,%@} - %@ comments", self.post.score, self.post.ups, self.post.downs, self.post.numComments]];
    
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Share"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(share)];
    self.navigationItem.rightBarButtonItem = shareButton;

}

// Sharing Stuff
- (void)share
{
    NSLog(@"share button pressed");
    NSString *text = [NSString stringWithFormat:@"%@\n", self.post.title];
    NSURL *postURL = [NSURL URLWithString:self.post.url];
    NSArray *activityItems = @[text, postURL];
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [loadingIndicator startAnimating];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [loadingIndicator stopAnimating];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (IBAction)upVote:(id)sender {
    
    if(upvoted){
        UIImage *clickedUpVote = [UIImage imageNamed:@"unclickedup.png"];
        [self.upVoteButton setImage:clickedUpVote forState:UIControlStateNormal];
        upvoted = NO;
        [[REDManager sharedREDManager] vote:self.post.name direction:0];
    } else {
        UIImage *clickedUpVote = [UIImage imageNamed:@"upvoteClicked2.png"];
        [self.upVoteButton setImage:clickedUpVote forState:UIControlStateNormal];
        upvoted = YES;
        UIImage *downVote = [UIImage imageNamed:@"unclickedDown.png"];
        [self.downVoteButton setImage:downVote forState:UIControlStateNormal];
        downvoted = NO;
        [[REDManager sharedREDManager] vote:self.post.name direction:1];
    }
}

- (IBAction)downVote:(id)sender {
    
    if(downvoted){
        UIImage *clickedUpVote = [UIImage imageNamed:@"unclickedDown.png"];
        [self.downVoteButton setImage:clickedUpVote forState:UIControlStateNormal];
        downvoted = NO;
        [[REDManager sharedREDManager] vote:self.post.name direction:0];
    } else {
        UIImage *clickedUpVote = [UIImage imageNamed:@"dvcolcked2.png"];
        [self.downVoteButton setImage:clickedUpVote forState:UIControlStateNormal];
        downvoted = YES;
        UIImage *upVote = [UIImage imageNamed:@"unclickedup.png"];
        [self.upVoteButton setImage:upVote forState:UIControlStateNormal];
        upvoted = NO;
        [[REDManager sharedREDManager] vote:self.post.name direction:-1];
    }

    
}
@end
