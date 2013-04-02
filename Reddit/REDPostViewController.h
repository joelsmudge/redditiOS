//
//  REDPostViewController.h
//  Reddit
//
//  Created by Joel Harrison on 2/04/13.
//  Copyright (c) 2013 SmudgeApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RedPost.h"

@interface REDPostViewController : UIViewController <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webViewer;
@property (strong, nonatomic) REDPost* post;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subSubTitleLabel;

@end
