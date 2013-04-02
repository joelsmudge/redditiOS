//
//  REDSearchViewController.m
//  Reddit
//
//  Created by Joel Harrison on 2/04/13.
//  Copyright (c) 2013 SmudgeApp. All rights reserved.
//

#import "REDSearchViewController.h"

@interface REDSearchViewController ()

@end

@implementation REDSearchViewController

-(void) keyboardDidShow:(NSNotification *)notification{
    NSLog(@"keyboardDidShow");
    
    
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.SearchList.contentInset = contentInsets;
    self.SearchList.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.SearchList.frame;
    aRect.size.height -= kbSize.height;
}

-(void) keyboardDidHide:(NSNotification *)notification{
    NSLog(@"keyboardDidHide");    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.SearchList.contentInset = contentInsets;
    self.SearchList.scrollIndicatorInsets = contentInsets;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.history = [[NSMutableArray alloc] init];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    _SearchList.delegate = self;
    _SearchList.dataSource = self;
    _SearchBar.delegate = self;
    [self.navigationItem setTitle:@"Search"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"tableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSString* cellText = [[self.history objectAtIndex:indexPath.item] description];
    [cell.textLabel setText:cellText];

    return cell;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"History Count %d", [self.history count]);
    return [self.history count];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [self.history addObject:searchBar.text];
    
    [self searchForSubReddit:searchBar.text];
}

-(void) searchForSubReddit:(NSString*) subReddit
{    
    //allocate your view controller
    REDPostListViewController *postListView = [[REDPostListViewController alloc] init];
    
    //send properties to your view controller
    postListView.searchQuery = subReddit;
    
    //push it to the navigationController
    [[self navigationController] pushViewController:postListView animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self searchForSubReddit:cell.textLabel.text];
    
    
    NSLog(@"table selected");
}

- (void)viewWillAppear:(BOOL)animated{
    [self.SearchList reloadData];
}


@end
