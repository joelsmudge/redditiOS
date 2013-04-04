//
//  REDSearchViewController.h
//  Reddit
//
//  Created by Joel Harrison on 2/04/13.
//  Copyright (c) 2013 SmudgeApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REDPostListViewController.h"
#import "REDLoginViewController.h"

@interface REDSearchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *SearchBar;
@property (weak, nonatomic) IBOutlet UITableView *SearchList;
@property (strong, nonatomic) NSMutableArray *history;
@property (strong, nonatomic) NSString *historyFileName;
@end
