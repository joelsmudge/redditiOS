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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _webViewer.delegate = self;
    [self.webViewer loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.post.url]]];
    
    [self.titleLabel setText:self.post.title];
    [self.subTitleLabel setText:[NSString stringWithFormat:@"by %@ - %@", self.post.author, self.post.domain]];
    [self.subSubTitleLabel setText:[NSString stringWithFormat:@"%@ {%@,%@} - %@ comments", self.post.score, self.post.ups, self.post.downs, self.post.numComments]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
