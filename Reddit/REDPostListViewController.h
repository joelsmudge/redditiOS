//
//  REDPostListViewController.h
//  Reddit
//
//  Created by Joel Harrison on 2/04/13.
//  Copyright (c) 2013 SmudgeApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface REDPostListViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *DebugSearchedForString;
@property (strong, nonatomic) NSString *searchQuery;
@property (weak, nonatomic) IBOutlet UIButton *DebugStuffButton;
@property (strong, nonatomic) NSMutableArray *posts;

@end
