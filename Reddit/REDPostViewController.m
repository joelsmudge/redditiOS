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
    
    if(![self.post.likes isEqualToString:@"<null>"]){
        if([self.post.likes isEqualToString:@"1"]){
            [self upVoteUI:YES];
            [self downVoteUI:NO];
        } else {
            [self upVoteUI:NO];
            [self downVoteUI:YES];
        }
    }
    
    
    loadingIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(145, 190, 20,20)];
    [loadingIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [loadingIndicator setHidesWhenStopped:YES];
    [self.webViewer addSubview:loadingIndicator];
    
    
    // Set the title names
    [self.titleLabel setText:self.post.title];
    [self.subTitleLabel setText:[NSString stringWithFormat:@"by %@ - %@", self.post.author, self.post.domain]];
    [self.subSubTitleLabel setText:[NSString stringWithFormat:@"%@ {%@,%@} - %@ comments", self.post.score, self.post.ups, self.post.downs, self.post.numComments]];
    
    // Alter View for login
    [self alterViewForLogin];
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]
                                    initWithTitle:@"Share"
                                    style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(share)];
    self.navigationItem.rightBarButtonItem = shareButton;
    
}

// Alters the view depending if the user is logged in
- (void) alterViewForLogin
{
    if(![[REDManager sharedREDManager].username isEqualToString:DEFAULT_USERNAME]){
        // Unique User. Voting symbols shown.
    } else {
        // Hide voting arrows and move text
        self.downVoteButton.hidden = YES;
        self.upVoteButton.hidden = YES;
        self.titleLabel.frame = CGRectMake(3, self.titleLabel.frame.origin.y, self.titleLabel.frame.size.width + self.titleLabel.frame.origin.x - 3, self.titleLabel.frame.size.height);
        self.subTitleLabel.frame = CGRectMake(3, self.subTitleLabel.frame.origin.y, self.subTitleLabel.frame.size.width + self.subTitleLabel.frame.origin.x - 3, self.subTitleLabel.frame.size.height);
        self.subSubTitleLabel.frame = CGRectMake(3, self.subSubTitleLabel.frame.origin.y, self.subSubTitleLabel.frame.size.width + self.subSubTitleLabel.frame.origin.x - 3, self.subSubTitleLabel.frame.size.height);
    }
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
        [self upVoteUI:NO];
        [[REDManager sharedREDManager] vote:self.post.name direction:0];
        self.post.likes = @"<null>";
    } else {
        [self upVoteUI:YES];
        [self downVoteUI:NO];
        [[REDManager sharedREDManager] vote:self.post.name direction:1];
        self.post.likes = @"1";
    }
}

- (IBAction)downVote:(id)sender {
    
    if(downvoted){
        [self downVoteUI:NO];
        [[REDManager sharedREDManager] vote:self.post.name direction:0];
        self.post.likes = @"<null>";
    } else {
        [self downVoteUI:YES];
        [self upVoteUI:NO];
        [[REDManager sharedREDManager] vote:self.post.name direction:-1];
        self.post.likes = @"0";
    }
}

- (void) upVoteUI: (BOOL) voted
{
    if(voted){
        UIImage *clickedUpVote = [UIImage imageNamed:@"upvoteClicked2.png"];
        [self.upVoteButton setImage:clickedUpVote forState:UIControlStateNormal];
        upvoted = YES;
    } else {
        UIImage *clickedUpVote = [UIImage imageNamed:@"unclickedup.png"];
        [self.upVoteButton setImage:clickedUpVote forState:UIControlStateNormal];
        upvoted = NO;
    }
}

- (void) downVoteUI: (BOOL) voted
{
    if(voted){
        UIImage *clickedUpVote = [UIImage imageNamed:@"dvcolcked2.png"];
        [self.downVoteButton setImage:clickedUpVote forState:UIControlStateNormal];
        downvoted = YES;
    } else {
        UIImage *clickedUpVote = [UIImage imageNamed:@"unclickedDown.png"];
        [self.downVoteButton setImage:clickedUpVote forState:UIControlStateNormal];
        downvoted = NO;
    }
}

@end
