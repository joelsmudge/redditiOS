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
        
        //Creating a history file
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        self.historyFileName = [documentsDirectory stringByAppendingPathComponent:@"subreddithistory.dat"];
        
        
        
        
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
    
    //Load the history array from the search history file
    self.history = [[NSMutableArray alloc] initWithContentsOfFile: self.historyFileName];
    if(self.history == nil)
    {
        //Array file didn't exist... create a new one
        self.history = [[NSMutableArray alloc] initWithCapacity:10];
        
        //Fill with default values
        [self.history addObject:@"All"];
        [self.history writeToFile:self.historyFileName atomically:YES];
    }
    
    // Nav Bar Customisation
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem:backButton];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"common_bg"]];
    

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
    
    int index = ([self.history count] - 1 - indexPath.item);
    NSString* cellText = [[self.history objectAtIndex:index] description];
    [cell.textLabel setText:cellText];
    cell.textLabel.textColor = [UIColor whiteColor];
    return cell;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.history count];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{    
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
    
    // remove all occurances of search items from history
    while([self.history containsObject:subReddit]){
        int index = [self.history indexOfObject:subReddit];
        [self.history removeObjectAtIndex:index];
        
    }
    
    // Add searched object to history
    [self.history addObject:subReddit];
    
    // limit to 10 items
    while([self.history count] >= 10){
        [self.history removeObjectAtIndex:0];
    }
    
    //Save the array
    [self.history writeToFile:self.historyFileName atomically:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self searchForSubReddit:cell.textLabel.text];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.SearchList reloadData];
}


@end
