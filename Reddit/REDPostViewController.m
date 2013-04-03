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
        //[self.navigationController popViewControllerAnimated:YES];
    }
    
    loadingIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(145, 190, 20,20)];
    [loadingIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [loadingIndicator setHidesWhenStopped:YES];
    [self.webViewer addSubview:loadingIndicator];
    
    [self.titleLabel setText:self.post.title];
    [self.subTitleLabel setText:[NSString stringWithFormat:@"by %@ - %@", self.post.author, self.post.domain]];
    [self.subSubTitleLabel setText:[NSString stringWithFormat:@"%@ {%@,%@} - %@ comments", self.post.score, self.post.ups, self.post.downs, self.post.numComments]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
