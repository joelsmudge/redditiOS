//
//  REDPostListViewController.h
//  Reddit
//
//  Created by Joel Harrison on 2/04/13.
//  Copyright (c) 2013 SmudgeApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface REDPostListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSString *searchQuery;
@property (strong, nonatomic) NSMutableArray *posts;
@property (weak, nonatomic) IBOutlet UITableView *SearchResultsTable;
@property int currentlyLoadingToPostIndex;
@property (weak, nonatomic) IBOutlet UIView *loadingBar;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingSpinner;


@end
